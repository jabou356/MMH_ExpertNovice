% Script to make a group file for standard EMG fatigue assessment

clear; clc;

%% Import generic paths
GenericPath_EN

%% Set conditions studied
Condin={'1_abd', '1_flex', '2_abd', '2_flex'};
Condout={'pre_abd', 'pre_flex', 'post_abd', 'post_flex'};

%% Get participants with data in Path.StandardEMG
sujets = arrayfun(@(x) x.name, dir(Path.StandardEMG),'UniformOutput',false);
sujets = sujets(~cellfun('isempty',regexp(sujets,'mat')));

for isubject = length(sujets) : -1 : 1
	
	% Load Standard EMG data
	load([Path.StandardEMG, sujets{isubject}]);
	
	GroupData.name(isubject) = sujets(isubject);
	
	for icond = 1 : length(Condin)
            
            trials=arrayfun(@(x)(strncmp(x.trialname, Condin{icond}, length(Condin{icond}))), data);
            trials=find(trials);
            
            for itrial= 1: length(trials)
                
                for imuscles= length(data(itrial).emgname) : -1 : 1
					
                    GroupData.onesecRMS.(data(itrial).emgname{imuscles}).(Condout{icond})(itrial,isubject)=data(trials(itrial)).onesecRMS(imuscles);
                    GroupData.plateautiming.(data(itrial).emgname{imuscles}).(Condout{icond})(itrial,isubject)=data(trials(itrial)).plateautiming(imuscles);
                    GroupData.MedFreq.(data(itrial).emgname{imuscles}).(Condout{icond})(itrial,isubject)=data(trials(itrial)).MedFreq(imuscles);
					GroupData.trialduration.(Condout{icond})(itrial,isubject)=data(trials(itrial)).trialduration;
				end
                
			end          
            
	end
	
	clear data
	
end

save([Path.GroupFatigue, 'StandardEMG.mat'], 'GroupData');