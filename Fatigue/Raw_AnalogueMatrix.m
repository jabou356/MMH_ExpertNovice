%% Function by Jason Bouffard to get access to Fatigue data

clear 
%% Set channel names
% emgnames={'deltant', 'deltmed', 'deltpost', 'biceps', 'triceps', 'uptrap'...
%     , 'pect', 'ssp', 'isp', 'subs'}; %THIS IS THE GOOD CONVENTION

emgnames={'antdelt', 'meddelt', 'postdelt', 'biceps', 'triceps', 'uptrap'};%...
%     , 'pect', 'ssp', 'isp', 'subs'};

%triggername={'glove'};
triggernames={'D2', 'MC2'};

%% Import generic paths
GenericPath_EN

%% Get participants 
[~,Alias.pseudo,~]=xlsread([Path.ExpertNovice, 'participants.xlsx'],...
    'Information participant', 'E5:E100');

for isujet = 1%length(Alias.pseudo):-1:1
    
    SubjectPath_EN
    
    trialnames=dir(Path.importdata); 
    trialnames = arrayfun(@(x) x.name, trialnames,'UniformOutput',false);
    trialnames=trialnames(strncmp(trialnames, 'l_',2) | strncmp(trialnames, 'm_',2) | strncmp(trialnames, 's_',2));
    
    for itrial=length(trialnames):-1:1
        
        disp(['Processing Subject #', num2str(isujet), ': ', Alias.pseudo(isujet), ', Trial # ',...
            num2str(itrial), '/', num2str(length(trialnames))])
        % Import analog data and get channel names
        input=btkReadAcquisition(([Path.importdata, char(trialnames(itrial))]));
        analogue=btkGetAnalogs(input);
        
        
        inputnames=fieldnames(analogue);
        
        emgidx=arrayfun(@(x) find(strncmp(inputnames,char(x),length(char(x)))),emgnames);
        data(itrial).emg=cell2mat(arrayfun(@(x) (analogue.(char(inputnames(x)))),emgidx,'UniformOutput',false));
        
        % Load info into the data structure
        data(itrial).emgname=emgnames;        
        data(itrial).subjectname=Alias.pseudo(isujet);
        data(itrial).trialname=trialnames(itrial);
        
        triggeridx=find(strncmp(inputnames,char(triggernames(2)),length(char(triggernames(2)))))';
        triggeridx=[triggeridx, find(strncmp(inputnames,char(triggernames(1)),length(char(triggernames(1)))))']; % À retirer lorsque le triggername sera unique (glove)

        data(itrial).trigger=cell2mat(arrayfun(@(x) (analogue.(char(inputnames(x)))),triggeridx,'UniformOutput',false));    

    end
    
    save([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat'], 'data');
    
    clear data
end