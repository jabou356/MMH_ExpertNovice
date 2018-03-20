%% Script by Jason Bouffard to analyse Standard EMG data for fatigue assessment

clear; clc;

%% Import generic paths
GenericPath_EN

%% Get participants with data in Path.StandardEMG
sujets = arrayfun(@(x) x.name, dir(Path.StandardEMG),'UniformOutput',false);
sujets = sujets(~cellfun('isempty',regexp(sujets,'mat')));


for isujet =  length(sujets) : -1 : 1
	
	
	% Load Standard EMG data
	load([Path.StandardEMG, sujets{isujet}]);
	
	% Run EMG compute (Bandpass filter + RMS)
	data=rMMH_emg_compute(data,data(1).analogueFz);
	
	for itrial=length(data) : -1 : 1
		
		% Calculate the standard deviation and mean rms for the following 1 second for each sample
		for itime=1:size(data(itrial).rmsEMG,1)-data(1).analogueFz
			
			mvtsd(itime,:)=std(data(itrial).rmsEMG(itime:itime+data(1).analogueFz,:),0,1);
			mvtave(itime,:)=mean(data(itrial).rmsEMG(itime:itime+data(1).analogueFz,:),1);
			
		end
		
		% For each muscle, find the moment when the sd is the lowest, but the rms is greater than the median to avoid the initial part of the file
		for imuscle = 1:size(data(itrial).rmsEMG,2)
			
			if max(mvtave(:,imuscle)) > 0
				plateautiming = find(mvtsd(:,imuscle) == min(mvtsd(mvtave(:,imuscle) > median(mvtave(:,imuscle)),imuscle)) & mvtave(:,imuscle) > median(mvtave(:,imuscle)));
				data(itrial).onesecRMS(imuscle) = mvtave(plateautiming,imuscle);
				data(itrial).plateautiming(imuscle) = plateautiming / data(1).analogueFz;
				data(itrial).MedFreq(imuscle)=medfreq(data(itrial).femg(plateautiming:plateautiming+data(1).analogueFz,imuscle),data(1).analogueFz);
			else
				data(itrial).onesecRMS(imuscle) =  nan;
				data(itrial).plateautiming(imuscle) = nan;
				data(itrial).MedFreq(imuscle)=nan;
				
				
				
			end
			
		end
		
		data(itrial).trialduration=size(data(itrial).rmsEMG,1)/ data(1).analogueFz;
		
		clear mvtsd mvtave
	end
	
	save([Path.StandardEMG, sujets{isujet}], 'data');
	clear data
	
	
end
