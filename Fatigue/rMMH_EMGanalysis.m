clear

%% Import generic paths
GenericPath_EN

%% Get participants
load(Path.SubjectID);
trialsForTimefreq = {'s_u'};

for isujet = [18 19 21 24 25 26 29 30 31]%length(Alias.pseudo):-1:1
    
    %% Load data
    load([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat']);
    disp(['data loaded: Subject # ', num2str(isujet), Alias.pseudo{isujet}]) 
    
    %% Process emg (bandpass filter + RMS)
    data=rMMH_emg_compute(data,2000);
    disp(['data processed: Subject # ', num2str(isujet), Alias.pseudo{isujet}]) 


    
    %% Partition data based on the presence of a box 
    data = PartionRMMH(data, {'deltant', 'biceps'});
    disp(['data partitionned: Subject # ', num2str(isujet), Alias.pseudo{isujet}]) 

    %% Clean data
%     for imuscle = 1:size(data{1}.NormRMS,2)
%         
%         trialID.trial=[];
%         trialID.box=[];
%         
%         tovalidate = [];
%         for itrial = 1:length(data)
%             trialID.trial = [trialID.trial,repmat(itrial,1, size(data{itrial}.box,1))];
%             trialID.box = [trialID.box, 1:size(data{itrial}.box,1)];
%             
%             
%             tovalidate = [tovalidate, squeeze(data{1,itrial}.NormRMS(:,imuscle,:))];
%             
%         end
%         
%         data = clean_datarMMH(data,imuscle,Alias.pseudo{isujet},tovalidate,trialID);
% 
%     end 
        
    %% Process emg time-frequency
    for i = 1:length(trialsForTimefreq)
    trials = find(cellfun(@(x)(strncmp(trialsForTimefreq{i},x.trialname{1},3)),data));
    data = TimeFreqEMG(data,trials);
    end

save([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat'], 'data');

clear data

    
end