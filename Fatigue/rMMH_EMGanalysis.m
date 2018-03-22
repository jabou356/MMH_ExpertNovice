clear

%% Import generic paths
GenericPath_EN

%% Get participants
load(Path.SubjectID);

for isujet = length(Alias.pseudo)%[18 19 21 24 25 26 29 30 31]%length(Alias.pseudo):-1:1
    
    %% For each trial, run EMG compute (filtering, RMS)
    load([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat']);
    disp(['data loaded: Subject # ', num2str(isujet), Alias.pseudo{isujet}]) 
    
    % Process emg (bandpass filter + RMS)
    data=rMMH_emg_compute(data,2000);
    disp(['data processed: Subject # ', num2str(isujet), Alias.pseudo{isujet}]) 


    
    %Partition data based on the presence of a box 
    data = PartionRMMH(data, {'deltant', 'biceps'});
    disp(['data partitionned: Subject # ', num2str(isujet), Alias.pseudo{isujet}]) 

    for imuscle = 1:size(data{1}.NormRMS,2)
        
        trialID.trial=[];
        trialID.box=[];
        
        tovalidate = [];
        for itrial = 1:length(data)
            trialID.trial = [trialID.trial,repmat(itrial,1, size(data{itrial}.box,1))];
            trialID.box = [trialID.box, 1:size(data{itrial}.box,1)];
            
            
            tovalidate = [tovalidate, squeeze(data{1,itrial}.NormRMS(:,imuscle,:))];
            
        end
        
        data = clean_datarMMH(data,imuscle,Alias.pseudo{isujet},tovalidate,trialID);

    end 
        
    % Process emg time-frequency
 %   data = TimeFreqEMG(data);
%   for itrial=1:length(data)
%         
%                 disp(['Processing Subject #', num2str(isujet), ': ', Alias.pseudo(isujet), ', Trial # ',...
% num2str(itrial)])
%         %% For each EMG channel, cut data to isolate moments when a box is handled from those when no box is handled
%         %         for imuscle = 1:length(data(itrial).emgname)
%         for ibox=length(data(itrial).box(:,1)):-1:1
%             data(itrial).cutemg(ibox).rmsEMGbox(:,:)=data(itrial).rmsEMG(data(itrial).box(ibox,1):data(itrial).box(ibox,2),:);
%                         data(itrial).cutemg(ibox).prctemgbox=prctile(data(itrial).cutemg(ibox).rmsEMGbox(:,:),1:100,1);
% 
%             if ibox<length(data(itrial).cutemg)
%                 data(itrial).cutemg(ibox).rmsEMGnobox(:,:)=data(itrial).rmsEMG(data(itrial).box(ibox,2):data(itrial).box(ibox+1,1),:);
%                 data(itrial).cutemg(ibox).prctemgnobox=prctile(data(itrial).cutemg(ibox).rmsEMGnobox(:,:),1:100,1);
%             end
%             
%         end
%         
%         
%     end
%     
save([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat'], 'data');

clear data

    
end