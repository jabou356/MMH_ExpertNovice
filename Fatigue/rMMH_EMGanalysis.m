clear

%% Import generic paths
GenericPath_EN

%% Get participants
[~,Alias.pseudo,~]=xlsread([Path.ExpertNovice, 'participants.xlsx'],...
    'Information participant', 'E5:E100');

for isujet = 1%length(Alias.pseudo):-1:1
    
    %% For each trial, run EMG compute (filtering, RMS)
    load([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat']);
    
    data=rMMH_emg_compute(data,2000);

    for itrial=1:length(data)
        
        
        %% For each EMG channel, cut data to isolate moments when a box is handled from those when no box is handled
        %         for imuscle = 1:length(data(itrial).emgname)
        for ibox=1:length(data(itrial).box(:,1))
            data(itrial).cutemg(ibox).rmsEMGbox(:,:)=data(itrial).rmsEMG(data(itrial).box(ibox,1):data(itrial).box(ibox,2),:);
                        data(itrial).cutemg(ibox).prctemgbox=prctile(data(itrial).cutemg(ibox).rmsEMGbox(:,:),1:100,1);

            if ibox<length(data(itrial).cutemg)
                data(itrial).cutemg(ibox).rmsEMGnobox(:,:)=data(itrial).rmsEMG(data(itrial).box(ibox,2):data(itrial).box(ibox+1,1),:);
                data(itrial).cutemg(ibox).prctemgnobox=prctile(data(itrial).cutemg(ibox).rmsEMGnobox(:,:),1:100,1);
            end
            
        end
        
        
    end
    
        save([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat'], 'data');

    
end