%------------------------------------------------------------------------------------------------------------------------------
% SEDIMENTION ENHANCING STRATEGY, DECISION SUPPORT TOOl
% A concise tool to help inform people,involved in the decisionmaking
% process, on different sedimentation enhancing strategies. Part I consists of 2 runs for
% the current delta regime scenario (towards river/tide/wave dominance) and for an altered scenario's tending
% towards river/wave/tide dominance. Part II ranks different sedimentation
% enhancing strategies on environmental impact and land gain/
% implementation costs.
% E. Sieben 18-03-2021
%------------------------------------------------------------------------------------------------------------------------------

clc
clear all;
close all;

sed_strat    = readtable('Sedimentation Enhancing Strategies.xlsx','ReadRowNames',true); % Data of the different sediment strategies

% 
trial_delta  = readtable('Trial_delta','ReadRowNames',true); % Input file with data from the user of the tool
output_model = sed_strat; % Output file from the model

% ----- PART I ------


%       1. Runs for the different scenarios

for s = (1:2) %Loop for the 2 scenarios, the current/wave/river/tide regime, the ratio's can be altered for the altered scenario sediment fluxes (w/r/t) differ per regime. 

%        2. Ranking of the strategies

% Loop running over all the strategies. Calculates distance between the point of different ratios of sediment fluxes of
% ''input delta'' to the point of the different ratios for the delta in
% which the strategy is applied. Then the strategies are sorted to rel
% ''resemblence' with the system or shortest distances between the points. 

for j = (1:(height(sed_strat)));

dis_delta(j,1) = sqrt(((trial_delta{s,1}-(sed_strat{j,'Qrivier_Qwave___'}))^2)+((trial_delta{s,2}-sed_strat{j,'Qrivier_Qtide___'})^2)+ ((trial_delta{s,3}-sed_strat{j,'Qwave_Qtide___'})^2));

dis_delta(:,2) = ((dis_delta(:,1)/max(dis_delta(:,1))*100));

end

dis_deltaT = array2table(dis_delta(:,2)); % Conversion array to rable
dis_deltaT.Properties.VariableNames = {'Delta regime user rel. to delta regime lowest resemblence (%)'};
outputmodel_a = [output_model dis_deltaT]; % Addition of the values to the output file
outputmodel_2 = sortrows(outputmodel_a,'Delta regime user rel. to delta regime lowest resemblence (%)'); % Sorting of values to highest resemblence with input delta settings 


%          3. Yes/no criteria

%
suitability((height(sed_strat)),5) = (0);
trial_delta_array(1,:)= table2cell(trial_delta(1,:));
outputmodel_c_array(:,1) = table2array(outputmodel_2(:,'LeveesystemNecessaryForImplementationStrategy')); 
outputmodel_c_array(:,2) = table2array(outputmodel_2(:,'Polder_beelNecessaryForImplementationStrategy')); 
outputmodel_c_array(:,3) = table2cell(outputmodel_2(:,'AreaImplemented_polderAreaHa_km2_')); 
outputmodel_c_array(:,4) = table2cell(outputmodel_2(:,'ImplementationCosts_USD__')); 
outputmodel_c_array(:,5) = table2cell(outputmodel_2(:,'GainedLandType_Nature_'));  
outputmodel_c_array(:,6) = table2cell(outputmodel_2(:,'GainedLandType_Agricultural_'));  
outputmodel_c_array(:,7) = table2cell(outputmodel_2(:,'GainedLandType_Aquaculture_'));  
outputmodel_c_array(:,8) = table2cell(outputmodel_2(:,'GainedLandType_Wetland_'));  
outputmodel_c_array(:,9) = table2cell(outputmodel_2(:,'GainedLandType_Recreation_'));  
outputmodel_c_array(:,10) = table2cell(outputmodel_2(:,'GainedLandType_Residential_'));  


% Loop for the different strategies 
for j = (1:(height(sed_strat)));   
    
    
% Levee system present and/or necessary
  if  isequal(trial_delta_array(1,4),outputmodel_c_array(j,1)); 
      suitability (j,1) = 1;
  end 
  if  isequal(trial_delta_array(1,4),{'Yes'});
      suitability (j,1) = 1;
  end  

% Polder/beels present and/or necessary 
  if  isequal(trial_delta_array(1,5),outputmodel_c_array(j,2)); 
      suitability(j,2) = 1;
  end 
  if  isequal(trial_delta_array(1,5),{'Yes'});
      suitability (j,2) = 1;      
  end   
  
%Maximum area available for outfall of the strategy
  if trial_delta_array{1,6} >= outputmodel_c_array{j,3};
      suitability (j,3) = 1;
  end

%Restricted budget
 if trial_delta_array{1,7} >= outputmodel_c_array{j,4};
      suitability (j,4) = 1;
 end

%land type gained for every type and combination
 if isequal(trial_delta_array(1,8),outputmodel_c_array(j,5)) 
       suitability (j,5) = 1;
 end
 if    isequal(trial_delta_array(1,8),outputmodel_c_array(j,6)) 
       suitability (j,5) = 1;
 end
 if isequal(trial_delta_array(1,8),outputmodel_c_array(j,7)) 
       suitability (j,5) = 1;
 end
 if isequal(trial_delta_array(1,8),outputmodel_c_array(j,8)) 
       suitability (j,5) = 1;
 end
 if  isequal(trial_delta_array(1,8),outputmodel_c_array(j,9)) 
       suitability (j,5) = 1;
 end
 if    isequal(trial_delta_array(1,8),outputmodel_c_array(j,10)) 
     suitability (j,5) = 1;
 end
  
 if isequal(trial_delta_array(1,8),{'Not important'});
      suitability(j,5) = 1;
 end 
 
end

suitabilityT = array2table(suitability);

land_types(:,1) = table2cell(outputmodel_2(:,{'GainedLandType_Nature_'}));
land_types(:,2) = table2cell(outputmodel_2(:,{'GainedLandType_Agricultural_'}));
land_types(:,3) = table2cell(outputmodel_2(:,{'GainedLandType_Aquaculture_'}));
land_types(:,4) = table2cell(outputmodel_2(:,{'GainedLandType_Wetland_'}));
land_types(:,5) = table2cell(outputmodel_2(:,{'GainedLandType_Recreation_'}));
land_types(:,6) = table2cell(outputmodel_2(:,{'GainedLandType_Residential_'}));

% Combine the land types in one cell for final output
for j = (1:(height(sed_strat)))
    
joined_land_types{j,1} = strcat(land_types(j,1),land_types(j,2),land_types(j,3),land_types(j,4),land_types(j,5),land_types(j,6));
obtained_land_type = array2table(joined_land_types, 'VariableNames',{'Obtained land type'});

end

 % Changing results to right format  
  for j = (1:(height(sed_strat)));
   
  if ( [suitabilityT{j,1}]== 0) ;
  result_3{j,1} = ('Not suitable, as no leveesystem is present.');
  else 
  result_3{j,1} = [];
  end
if ( [suitabilityT{j,2}]== 0) ;
  result_3{j,2} = ('Not suitable, as no polder/beel is present.');
  else 
  result_3{j,2} = [];
end
  
if ( [suitabilityT{j,3}]== 0) ;
  result_3{j,3} = ('Not suitable, as outfall area of the strategy does not fit the available area.');
  else 
  result_3{j,3} = [];
end

if ( [suitabilityT{j,4}]== 0) ;
  result_3{j,4} = ('Not suitable, as implementation costs exceed budget.');
  else 
  result_3{j,4} = [];
end

if ( [suitabilityT{j,5}]== 0) ;
  result_3{j,5} = ('Not suitable, as necessary land type does not match with obtained land type.');
  else 
  result_3{j,5} = [];
end
  end

for j = (1:(height(sed_strat)))
    result_3{j,6} = strcat(result_3(j,1),result_3(j,2),result_3(j,3),result_3(j,4),result_3(j,5));
    
if isequal(result_3{j,6}, {[]});
   result_3{j,6} = ('Suitable');
end
  
end 

result_3_n = array2table(result_3, 'VariableNames',{'Leveesystem' 'Polder/beel' 'Outfall area' 'Restricted budget' 'Land type' 'Suitability of the strategy'});


outputmodel_3 = [outputmodel_2 result_3_n(:,'Suitability of the strategy')]; % Addition of results yes/no criteria to output file
 

%              4. Sediment balance

Rise = table2cell(outputmodel_3(:,{'LandRaisedIn_mm_yr_'}));
Slr(:,1)  = table2cell(outputmodel_3(:,{'RateOfSLR_mm_yr__RCP4_5Scenario'}));
Slr(:,2)  = table2cell(outputmodel_3(:,{'RateOfSLR_mm_yr__RCP8_5Scenario'}));
Slr_user(:,1)  = table2cell(trial_delta(:,{'SeaLevelRise_mm_yr__RCP4_5Scenario'}));
Slr_user(:,2)  = table2cell(trial_delta(:,{'SeaLevelRise_mm_yr__RCP8_5Scenario'}));

Sub(:,1) = table2cell(outputmodel_3(:,{'MeanSubsidence_mm_yr_'} )); 
Sub_user = table2cell(trial_delta(:,{'SubsidenceOfTheDelta_mm_yr_'}));

for j = (1:(height(sed_strat)));
result_4a{j,1} = Rise{j,1} - Slr{j,1} - Sub{j,1};
result_4a{j,2} = Rise{j,1} - Slr{j,2} - Sub{j,1};
result_4a{j,3} = Rise{j,1} - Slr_user{1,1} - Sub_user{1,1};
result_4a{j,4} = Rise{j,1} - Slr_user{1,2} - Sub_user{1,1};

end

result_4b = array2table(result_4a, 'VariableNames',{'Delta of strategy, RCP 4.5, Land gain - sub.- slr (mm/yr)','Delta of strategy, RCP 8.5, Land gain - sub. - slr (mm/yr)', 'Delta of user, RCP 4.5,Land gain - sub. - slr (mm/yr)', 'Delta of user, RCP 8.5, Land gain - sub. - slr (mm/yr)'});

outputmodel_4 = [outputmodel_3 result_4b]; % Addition of results sediment balance to output file
 
%______OUTPUT PART 1____

if s == 1
    Current_regime_ = outputmodel_4;
   
elseif s== 2
    Altered_Scenario_  =  outputmodel_4;
   
end
end

for j = (1:(height(sed_strat)));
    
    
Current_regime(j,:) = [ Current_regime_(j,{'Suitability of the strategy'}) Current_regime_(j,{'SedimentManagementStrategy_Project'}) Current_regime_(j,{'DeltaSystem'}) Current_regime_(j,{'Country_Coast_'}) Current_regime_(j,{'Delta regime user rel. to delta regime lowest resemblence (%)'})   Current_regime_(j,{'ShortDescriptionOfSES'}) Current_regime_(j,{'PrimaryObjectiveOfTheProject'}) Current_regime_(j,{'LandUseTypeBeforeImplementationOfTheSES'}) obtained_land_type(j,{'Obtained land type'}) Current_regime_(j,{'Remarks'}) Current_regime_(j,{'MainDrawbacks'}) Current_regime_(j,{'MainHighlights'}) Current_regime_(j,{ 'Delta of strategy, RCP 4.5, Land gain - sub.- slr (mm/yr)'}) Current_regime_(j,{ 'Delta of strategy, RCP 8.5, Land gain - sub. - slr (mm/yr)'}) Current_regime_(j,{ 'Delta of user, RCP 4.5,Land gain - sub. - slr (mm/yr)'}) Current_regime_(j,{ 'Delta of user, RCP 8.5, Land gain - sub. - slr (mm/yr)'})];
Altered_Scenario(j,:) = [ Altered_Scenario_(j,{'Suitability of the strategy'}) Altered_Scenario_(j,{'SedimentManagementStrategy_Project'}) Altered_Scenario_(j,{'DeltaSystem'}) Altered_Scenario_(j,{'Country_Coast_'}) Altered_Scenario_(j,{'Delta regime user rel. to delta regime lowest resemblence (%)'})   Altered_Scenario_(j,{'ShortDescriptionOfSES'}) Altered_Scenario_(j,{'PrimaryObjectiveOfTheProject'}) Altered_Scenario_(j,{'LandUseTypeBeforeImplementationOfTheSES'}) obtained_land_type(j,{'Obtained land type'}) Altered_Scenario_(j,{'Remarks'}) Altered_Scenario_(j,{'MainDrawbacks'}) Altered_Scenario_(j,{'MainHighlights'}) Altered_Scenario_(j,{ 'Delta of strategy, RCP 4.5, Land gain - sub.- slr (mm/yr)'}) Altered_Scenario_(j,{ 'Delta of strategy, RCP 8.5, Land gain - sub. - slr (mm/yr)'}) Altered_Scenario_(j,{ 'Delta of user, RCP 4.5,Land gain - sub. - slr (mm/yr)'}) Altered_Scenario_(j,{ 'Delta of user, RCP 8.5, Land gain - sub. - slr (mm/yr)'})];

end

% ----- PART II ------

%         5. Scoring/ranking the strategies

Strategies = table2array(outputmodel_4(:,{'SedimentManagementStrategy_Project'})); 

% -Environmental impact-

% Degree positive impact 
for j = (1:(height(sed_strat)));
     
    result_5_1_p{j,1}    = outputmodel_4{j, {'SedimentManagementStrategy_Project'}}; 
    result_5_1_p{j,2}    = outputmodel_4{j, {'DegreeOfPositiveImpact_Low_Moderate_High_VeryHigh_'}};
    

    % Degree of positive impact
       
    if  isequal(outputmodel_4{j,'DegreeOfPositiveImpact_Low_Moderate_High_VeryHigh_'},{'Very high'})
         result_5_EIA_p{j,1} = 1;
         
    elseif    isequal(outputmodel_4{j,'DegreeOfPositiveImpact_Low_Moderate_High_VeryHigh_'},{'High'})
        result_5_EIA_p{j,1} = 2;
    
    elseif    isequal(outputmodel_4{j,'DegreeOfPositiveImpact_Low_Moderate_High_VeryHigh_'},{'Moderate'})
         result_5_EIA_p{j,1} = 3;
         
    elseif    isequal(outputmodel_4{j,'DegreeOfPositiveImpact_Low_Moderate_High_VeryHigh_'},{'Low'})
         result_5_EIA_p{j,1} = 4;
    end 
end

result_5_1_p = [result_5_1_p result_5_EIA_p]; 
result_5_EIA_p_sorted = sortrows(result_5_1_p,3); % Sorting of the strategies from Very high to low postive degree impact

% Degree negative impact
 for j = (1:(height(sed_strat)));
     
    result_5_1_n{j,1}    = outputmodel_4{j, {'SedimentManagementStrategy_Project'}}; 
    result_5_1_n{j,2}    = outputmodel_4{j, {'DegreeOfNegativeImpact_Low_Moderate_High_VeryHigh__'}};
    result_5_1_n{j,3}    = outputmodel_4{j, {'EnivronmentalImpactAdditionalRemark'}};
    % Degree of positive impact
       
    if  isequal(outputmodel_4{j,'DegreeOfNegativeImpact_Low_Moderate_High_VeryHigh__'},{'Very high'})
         result_5_EIA_n{j,1} = 1;
         
    elseif    isequal(outputmodel_4{j,'DegreeOfNegativeImpact_Low_Moderate_High_VeryHigh__'},{'High'})
        result_5_EIA_n{j,1} = 2;
    
    elseif    isequal(outputmodel_4{j,'DegreeOfNegativeImpact_Low_Moderate_High_VeryHigh__'},{'Moderate'})
         result_5_EIA_n{j,1} = 3;
         
    elseif    isequal(outputmodel_4{j,'DegreeOfNegativeImpact_Low_Moderate_High_VeryHigh__'},{'Low'})
         result_5_EIA_n{j,1} = 4;
    end 
end

result_5_1_n = [result_5_1_n result_5_EIA_n]; 
result_5_EIA_n_sorted = sortrows(result_5_1_n,4); % Sorting of the strategies from Very high to low postive degree impact   
    
result_5_EIA_x = [result_5_EIA_p_sorted result_5_EIA_n_sorted]; 
result_5_EIA_x(:,3) = [];
result_5_EIA_x(:,6) = [];
result_5_EIA = array2table(result_5_EIA_x, 'VariableNames',{'Strategy sorted on degree of positive impact, descending' 'Degree of postive impact' 'Strategy sorted on degree of negative impact, ascending ' 'Degree of negative impact' 'EnivronmentalImpactAdditionalRemark'});

% Landgain/ costs: implementation costs to increase 1 mm/year 

Imp_costs = table2cell(outputmodel_4(:,{'ImplementationCosts_USD__'}));
% 
 for j = (1:(height(sed_strat)));
    result_5_Costs_gain{j,2} = (Imp_costs {j,1})./(Rise{j,1});
    result_5_Costs_gain{j,1} = Strategies{j,1};
end 

result_5_Costs_gain_sorted_x = sortrows(result_5_Costs_gain,2);
result_5_Costs_gain_sorted = array2table(result_5_Costs_gain_sorted_x , 'VariableNames',{'Strategies sorted, ascending costs/land gain' 'Implementation costs (USD$) for 1 mm/yr land gain'});,

% Result of scoring and ranking

Ranked_strategies = ([result_5_EIA result_5_Costs_gain_sorted]);

% ------- FINAL OUTPUT -------------

% writetable(Final_output,F_xlsx,'Sheet',files(i).name)
filename = 'Final_output_SES.xlsx';

writetable(Current_regime,filename, 'Sheet',1 , 'Range', 'A1');
writetable(Altered_Scenario,filename, 'Sheet',2, 'Range', 'A1');
writetable(Ranked_strategies,filename, 'Sheet',3, 'Range', 'A1');


