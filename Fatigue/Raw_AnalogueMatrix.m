%% Function by Jason Bouffard to get access to Fatigue data

clear 
%% Set channel names
 emgnames={'deltant', 'deltmed', 'deltpost', 'biceps', 'triceps', 'uptrap'...
     , 'pect' 'ssp', 'isp', 'subs'}; %THIS IS THE GOOD CONVENTION

% emgnames={'antdelt', 'meddelt', 'postdelt', 'biceps', 'triceps', 'uptrap'};%...
% %     , 'pect', 'ssp', 'isp', 'subs'}; % for pilote 1


%% Import generic paths
GenericPath_EN

%% Get participants 
[~,Alias.pseudo,~]=xlsread([Path.ExcelPath, 'participants.xlsx'],...
    'info_participants', 'D4:D33');
[~,Alias.date,~]=xlsread([Path.ExcelPath, 'participants.xlsx'],...
    'info_participants', 'H4:H33');

for isujet = length(Alias.pseudo)%:-1:1
    
    SubjectPath_EN
    
    trialnames = arrayfun(@(x) x.name, dir(Path.importfatigue),'UniformOutput',false);
    rMMHtrialnames=trialnames(strncmp(trialnames, 'l_',2) | strncmp(trialnames, 'm_',2) | strncmp(trialnames, 's_',2));
	sEMGtrialnames=trialnames(strncmp(trialnames, 'abd',3) | strncmp(trialnames, 'flex',4));

    
    for itrial=length(rMMHtrialnames):-1:1
        
        disp(['Processing Subject #', num2str(isujet), ': ', Alias.pseudo(isujet), ', Trial # ',...
            num2str(itrial), '/', num2str(length(rMMHtrialnames))])
		
        % Import analog data and get channel names
        input=btkReadAcquisition(([Path.importfatigue, char(rMMHtrialnames(itrial))]));
        analogue=btkGetAnalogs(input);
             
        inputnames=fieldnames(analogue);
        
        emgidx=arrayfun(@(x) find(strncmp(inputnames,char(x),length(char(x)))),emgnames);
	
        data(itrial).emg=cell2mat(arrayfun(@(x) (analogue.(char(inputnames(x)))),emgidx,'UniformOutput',false));
        
        % Load info into the data structure
        data(itrial).emgname=emgnames;        
        data(itrial).subjectname=Alias.pseudo(isujet);
        data(itrial).trialname=rMMHtrialnames(itrial);
        
    end
    
    save([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat'], 'data');
    
    clear data
	
	for itrial=length(sEMGtrialnames):-1:1
        
        disp(['Processing Subject #', num2str(isujet), ': ', Alias.pseudo(isujet), ', Trial # ',...
            num2str(itrial), '/', num2str(length(sEMGtrialnames))])
		
        % Import analog data and get channel names
        input=btkReadAcquisition(([Path.importfatigue, char(sEMGtrialnames(itrial))]));
        analogue=btkGetAnalogs(input);
             
        inputnames=fieldnames(analogue);
        
        emgidx=arrayfun(@(x) find(strncmp(inputnames,char(x),length(char(x)))),emgnames);
	
        data(itrial).emg=cell2mat(arrayfun(@(x) (analogue.(char(inputnames(x)))),emgidx,'UniformOutput',false));
        
        % Load info into the data structure
        data(itrial).emgname=emgnames;        
        data(itrial).subjectname=Alias.pseudo(isujet);
        data(itrial).trialname=sEMGtrialnames(itrial);
        
	end
	
	save([Path.StandardEMG, Alias.pseudo{isujet}, '.mat'], 'data');
	clear data

end