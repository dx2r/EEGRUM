%%%
%
% Script which computes the Amplitude Envelope Correlation (in the beta band) for the DMN network defined by Raichle. (https://doi.org/10.1146/annurev-neuro-071013-014030)
% In order to be able to run the code, you need to install the matlab functions which can be found here: https://github.com/dx2r/EEG_Pipeline.git
% The data on which the analysis has ran, is available upon reasonable request. Email: gert.vanhollebeke@ugent.be
%
% Gert Vanhollebeke (16/12/2021)
%
%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 0: WRITE IN SHORT WHAT YOU ARE GOING TO DO BELOW %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FC analysis: AEC, beta band (14 - 30 Hz), network defined by Raichle. (2015)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1: ADJUST VARIABLES HERE %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the part where you adjust the variables to your specific preferences. 
% Check each variable and check if it is correct or not.

    %%%
    % LOCATION VARIABLES
    %%% 

        % don't put a backslash at the end of the path
        %example: 'C:\Some_Study\EEG Data'
        location_data_from = ''; %full path to the directory where the data is located.
        location_data_to = ''; %full path to the directory where the new data needs to be stored. 
        location_data_information = ''; %full path to the directory where the dataset information needs to be stored
    
    %%%
    % MAP NAME VARIABLES
    %%%
    
        pow_results_map_name = '';
        fc_results_map_name = 'DMN - AEC (Beta 14 - 30)';
        dynfc_resuls_map_name = '';
        dyncausal_results_map_name = '';
        graph_results_map_name = '';
        
    %%%
    % FREQUENCY RANGES
    %%%

        delta_frequency_range = [0.5 4]; % frequency range for the delta frequency band (Hz)
        theta_frequency_range = [4 8]; % frequency range for the theta frequency band (Hz)
        alpha_frequency_range = [8 13]; % frequency range for the alpha frequency band (Hz)
        beta_frequency_range = [14 30]; % frequency range for the beta frequency band (Hz)

    %%%
    % BRAIN REGIONS
    %%%

        %region 1: gyrus rectus L
        region_1 = 23;
        region_1_name = "";
        %region 2: gurys rectus R
        region_2 = 24;
        region_2_name = "";
        %region 3: dorsal medial prefrontal cortex L
        region_3 = 101;
        region_3_name = "";
        %region 4: dorsal medial prefrontal cortex R
        region_4 = 102;
        region_4_name = "";
        %region 5: posterior cingulate cortex L
        region_5 = 13;
        region_5_name = "";
        %region 6: posterior cingulate cortex R
        region_6 = 14;
        region_6_name = ""; 
        %region 7: precuneus L 
        region_7 = [95 97];
        region_7_name = "precuneus L";
        %region 8: precuneus R
        region_8 = [96 98];
        region_8_name = "precuneus R";
        %region 9: lateral parietal cortex L
        region_9 = 1;
        region_9_name = "lateral parietal cortex L";
        %region 10: lateral parietal cortex R
        region_10 = 2;
        region_10_name = "lateral parietal cortex R";

    %%%
    % EPOCH INFORMATION
    %%%

        epoch_length = 3; %length of the epochs (defined in the preprocessing) in seconds

    %%%
    % EEG INFORMATION
    %%%

        sample_frequency = 512; %sample frequency of the EEG signal

    %%%
    % ANALYSIS INFORMATION
    %%%
    
        %POWER ANALYSIS
        analysis_choice_power = '';
        %FUNCTIONAL CONNECTIVITY ANALYSIS
        analysis_choice_fc = "AEC";
        fc_varargin = [14 30];
        %DYNAMIC FUNCTIONAL CONNECTIVITY ANALYSIS
        analysis_choice_dynfc = "";
        %DYNAMIC CAUSAL MODELING ANALYSIS
        analysis_choice_dyncausal = "";
        %GRAPH ANALYSIS ANALYSIS
        analysis_choice_graph = "";
        gr_bin_or_weight = ""; %"binary" or "weighted"
        gr_threshold = [];
        gr_undir_or_dir = ""; %"directed" or "undirected"
        graph_varargin = {};
        
    %%%
    % SELECT WHICH ANALYSIS NEED TO BE RUN
    %%%
    
    %if you want the specific analysis, set the variable to 1, if not, set to 0.
    
        %POWER ANALYSIS
        run_analysis_power = 0;
        %FUNCTIONAL CONNECTIVITY ANALYSIS
        run_analysis_fc = 1;
        %DYNAMIC FUNCTIONAL CONNECTIVITY ANALYSIS
        run_analysis_dynfc = 0;
        %DYNAMIC CAUSAL MODELING ANALYSIS
        run_analysis_dyncausal = 0;
        %GRAPH ANALYSIS ANALYSIS
        run_analysis_graph = 0;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 2: LOAD IN DATASET %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %load the paths and names of the dataset
    [dataset_files, dataset_names] = Generate_Paths_All_Together(location_data_from);
    %get the size of the current dataset
    dataset_size = size(dataset_names,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 3: POWER CALCULATIONS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(run_analysis_power == 1)
    %as of yet not implemented.
else
    disp('Power Analysis not selected...');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 4: FUNCTIONAL CONNECTIVITY CALCULATIONS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(run_analysis_fc == 1)
    %%%
    % SUBSTEP 1: CREATE A RESULTS MAP
    %%%
        [FC_Results_map] = Create_Directory(location_data_to,fc_results_map_name);
    %%%
    % SUBSTEP 2: MAIN FOR LOOP
    %%%
        %first, write the loop for every participant (use parfor for parallel computing)
        for participant_i = 1:3:dataset_size  %jumps of 3 to only run the baseline code
            %get the name of the current participant
            current_participant_name = dataset_names(participant_i); 
            %Tell what is going on (which participant is worked on)
            disp(current_participant_name);
            %load the timeseries of the current participant
            current_participant_datafile = Extract_Timeseries_From_Structure(dataset_files(participant_i));
            %define the regions which need to be used
            [current_participant_region_timeseries, current_participant_region_names] = Extract_Time_Series_And_Names(current_participant_datafile,...
                                                                                                                      region_1, region_1_name,...
                                                                                                                      region_2, region_2_name,...
                                                                                                                      region_3, region_3_name,...
                                                                                                                      region_4, region_4_name,...
                                                                                                                      region_5, region_5_name,...
                                                                                                                      region_6, region_6_name,...
                                                                                                                      region_7, region_7_name,...
                                                                                                                      region_8, region_8_name,...
                                                                                                                      region_9, region_9_name,...
                                                                                                                      region_10, region_10_name);
            %run the functional connectivity analysis
            current_participant_values = TF_calculate_functional_connectivity(current_participant_region_timeseries,...
                                                                                        sample_frequency,...
                                                                                        epoch_length,...
                                                                                        analysis_choice_fc,...
                                                                                        fc_varargin);
            
                                                                                    %save the results in the previously defined map
            Save_Results_To_Directory(current_participant_values,current_participant_name,FC_Results_map);
        end
        
    %%%
    % SUBSTEP 3: SAVE ADDITIONAL INFORMATION
    %%%       
        %Save the region names and indices to be able to reproduce the results.
        region_indices = {region_1; region_2; region_3; region_4; region_5; region_6; region_7; region_8; region_9; region_10};
        region_names = current_participant_region_names;
        Analysis_Region_Information = table(region_indices,region_names);
        Save_Results_To_Directory(Analysis_Region_Information, 'Analysis_Region_Information',location_data_information);

else
    disp('Functional Connectivity Analysis not selected...');
end
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 5: DYNAMIC FUNCTIONAL CONNECTIVITY CALCULATIONS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(run_analysis_dyncausal == 1)
    % As of yet not implemented.
else
    disp('Dynamic Functional Connectivity Analysis not selected...');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 6: DYNAMIC CAUSAL MODELING CALCULATIONS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(run_analysis_dynfc == 1)
    % As of yet not implemented.
else
    disp('Dynamic Causal Modeling Analysis not selected...');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 7: GRAPH ANALYSIS CALCULATIONS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(run_analysis_graph == 1)
    %%%
    % SUBSTEP 1: CREATE A RESULTS MAP
    %%%
        [Graph_Results_map] = Create_Directory(location_data_to,graph_results_map_name);
    %%%
    % SUBSTEP 2: MAIN FOR LOOP
    %%%
        %first, write the loop for every participant (use parfor for parallel computing)
        for participant_i = 1:dataset_size 
            %get the name of the current participant
            current_participant_name = dataset_names(participant_i); 
            %Tell what is going on (which participant is worked on)
            disp(current_participant_name);
            %load the timeseries of the current participant
            current_participant_datafile = Extract_Object_From_Structure(dataset_files(participant_i));           
            %run the graph analysis
            current_participant_values = TF_calculate_graph(current_participant_datafile,...
                                                            gr_bin_or_weight,...
                                                            gr_threshold,...
                                                            gr_undir_or_dir,...
                                                            analysis_choice_graph,...
                                                            graph_varargin);
            %save the results in the previously defined map
            Save_Results_To_Directory(current_participant_values,current_participant_name,Graph_Results_map);
        end
        
    %%%
    % SUBSTEP 3: SAVE ADDITIONAL INFORMATION
    %%%       
        
else
    disp('Graph Analysis not selected...');
end

%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 8: NOTIFICATION %
%%%%%%%%%%%%%%%%%%%%%%%%

    %play a sound when the program is finished
    load handel
    sound(y,Fs)