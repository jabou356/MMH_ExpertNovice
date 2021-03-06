%% Function by Jason Bouffard to get access to Fatigue data

clear; clc;
%% Set channel names
emgnames={'deltant', 'deltmed', 'deltpost', 'biceps', 'triceps', 'uptrap'...
	, 'pect' 'ssp', 'isp', 'subs'}; %THIS IS THE GOOD CONVENTION

%% Trials we want to include
% Find repetitive lifting trials (l_u_x.c3d, l_d_x.c3d, m_u_x.c3d, m_d_x.c3d, s_u_x.c3d, s_d_x.c3d)
TrialsrMMH = {'l_u_','m_u_','s_u_'};


%% Import generic paths
GenericPath_EN

%% Get participants
load(Path.SubjectID);
% [~,Alias.pseudo,~]=xlsread([Path.ExcelPath, 'participants.xlsx'],...
% 	'info_participants', 'D4:D35');
% [~,Alias.date,~]=xlsread([Path.ExcelPath, 'participants.xlsx'],...
% 	'info_participants', 'H4:H35');

for isujet = length(Alias.pseudo)%-1:-1:1
	
	SubjectPath_EN
	
	%% Find files in the participant's fatigue directory
	trialnames = arrayfun(@(x) x.name, dir(Path.importfatigue),'UniformOutput',false);
	
	
	% Find repetitive lifting trials (l_u_x.c3d, l_d_x.c3d, m_u_x.c3d, m_d_x.c3d, s_u_x.c3d, s_d_x.c3d)
    
    rMMHtrialnames = trialnames(sum(cell2mat(cellfun(@(x)(strncmp(trialnames,x,4)),TrialsrMMH, 'UniformOutput', false)),2)>0 & ~cellfun('isempty',regexp(trialnames, 'c3d')));
    	
	% Find standardized EMG trials (x_flex_y.c3d, x_abd_y.c3d)
	sEMGtrialnames=trialnames((~cellfun('isempty',regexp(trialnames, 'abd')) | ~cellfun('isempty',regexp(trialnames, 'flex'))) ...
		& ~cellfun('isempty',regexp(trialnames, 'c3d')));
	
	%% Extract EMG data from repetitive lifting trials and export in Path.RepetitiveMMH
	for itrial=length(rMMHtrialnames):-1:1
		
		disp(['Processing Subject #', num2str(isujet), ': ', Alias.pseudo(isujet), ', Trial # ',...
			num2str(itrial), '/', num2str(length(rMMHtrialnames))])
		
		% Import analog data, channel names and sampling frequency
		input=btkReadAcquisition([Path.importfatigue, rMMHtrialnames{itrial}]);
		analogue=btkGetAnalogs(input); % serait probablement plus rapide si j'importais uniquement les canaux d'int�r�t avec btkGetAnalog
		analogueFz=btkGetAnalogFrequency(input);
		
		%Find EMG channels based on emgnames variable
		inputnames=fieldnames(analogue);
		emgidx=cellfun(@(x) find(strncmp(inputnames,x,length(x))),emgnames);
        %emgidx=arrayfun(@(x) find(strncmp(inputnames,char(x),length(char(x)))),emgnames);
		
		% Input EMG data and info into the data structure
		data{itrial}.emg=cell2mat(arrayfun(@(x) (analogue.(inputnames{x})),emgidx,'UniformOutput',false)); %data
		
		data{itrial}.emgname=emgnames;
		data{itrial}.subjectname=Alias.pseudo(isujet);
		data{itrial}.trialname=rMMHtrialnames(itrial);
		data{itrial}.analogueFz=analogueFz;
		
		btkCloseAcquisition(input);
	end
	
	save([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat'], 'data');
	clear data
	
	%% Extract EMG data from Standard EMG trials and export in Path.StandardEMG
	for itrial=length(sEMGtrialnames):-1:1
		
		disp(['Processing Subject #', num2str(isujet), ': ', Alias.pseudo(isujet), ', Trial # ',...
			num2str(itrial), '/', num2str(length(sEMGtrialnames))])
		
		% Import analog data and get channel names
		input=btkReadAcquisition(([Path.importfatigue, sEMGtrialnames{itrial}]));
		analogue=btkGetAnalogs(input);
		analogueFz=btkGetAnalogFrequency(input);
		
		%Find EMG channels based on emgnames variable
		inputnames=fieldnames(analogue);
		emgidx=cellfun(@(x) (find(strncmp(inputnames,x,length(x)))),emgnames);
		
		% Import analog data, channel names and sampling frequency
		data{itrial}.emg=cell2mat(arrayfun(@(x) (analogue.(inputnames{x})),emgidx,'UniformOutput',false)); %data
		
		data{itrial}.emgname=emgnames;
		data{itrial}.subjectname=Alias.pseudo(isujet);
		data{itrial}.trialname=sEMGtrialnames(itrial);
		data{itrial}.analogueFz=analogueFz;
		
		btkCloseAcquisition(input);


		
	end
	
	save([Path.StandardEMG, Alias.pseudo{isujet}, '.mat'], 'data');
	clear data
	
end