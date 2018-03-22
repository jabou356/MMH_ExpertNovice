function [data] = PartionRMMH(data,SyncName)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Determine the amount of EMG needed to consider it as a contraction
nSD = 2; % number of baseline standard diviation
MinDuration = 2; % minimum duration of contraction (in seconds)
MinDuration = MinDuration * data{1}.analogueFz;

MinDurationgap = 1; % minimum duration of contraction (in seconds)
MinDurationgap = MinDurationgap * data{1}.analogueFz;

% find chan number of signals used to partition data
triggerChan = find(ismember(data{1}.emgname,SyncName));

%% Using the first trial, determine the level of EMG expected when there is no box

% locate silent periods in the data (periods without a box)
clf
MaxTrigChan = max(data{1,1}.rmsEMG(:,triggerChan),[],1);
plot(data{1,1}.rmsEMG(:,triggerChan)./MaxTrigChan)
hold on


otherSilent = 1;
k=0;
while otherSilent==1
    
    k=k+1;
    title(['Select the beginning and the end of silent period (no box) #', num2str(k)])
    [Silent(:,k), ~]= ginput(2);
    Silent(:,k) = round(Silent(:,k));

    otherSilent = menu('Are there other silent periods?', 'Yes', 'No');
    
    % determine baseline level for this silent period

    BaselineSD(k) = std(sum(data{1,1}.rmsEMG(Silent(1,k):Silent(2,k),triggerChan)./MaxTrigChan,2));
    BaselineMean(k) = mean(sum(data{1,1}.rmsEMG(Silent(1,k):Silent(2,k),triggerChan)./MaxTrigChan,2));
   
end

% Determine the average baseline sd emg
BaselineSD = mean(BaselineSD);
BaselineMean = mean(BaselineMean);

for itrial = length(data):-1:1
    
    EMGdetected = sum(data{1,itrial}.rmsEMG(:,triggerChan)./MaxTrigChan,2) > BaselineMean + nSD * BaselineSD;
    
    NewEMG = find(diff(EMGdetected) > 0);
    NewSilent = find(diff(EMGdetected) < 0);
    
    % I want to start with a NewEMG and finish with a New Silent so
    % length(NewEMG) == length(newSilent)
    if NewSilent(1) < NewEMG(1)
        NewSilent = NewSilent(2:end);
    end
    
    if NewEMG(end)>NewSilent(end)
        NewEMG = NewEMG(1:end-1);
    end

    % The participant carry a box when his contraction is longer than
    % minimal duration
    boxes = find (NewSilent - NewEMG >= MinDuration);
    
        
    data{1,itrial}.box = [NewEMG(boxes),NewSilent(boxes)];
    data{1,itrial}.gap = [NewSilent(boxes(1:end-1)),NewEMG(boxes(2:end))];

    falsegap = find(data{1,itrial}.gap(:,2)-data{1,itrial}.gap(:,1) <= MinDurationgap);
    
    if falsegap
        for ifalse = 1:length(falsegap)
            boxbefore = find(data{1,itrial}.box(:,2) == data{1,itrial}.gap(falsegap(ifalse),1));
            data{1,itrial}.box(boxbefore,2) = data{1,itrial}.box(boxbefore+1,2);
            
            data{1,itrial}.box(boxbefore+1,:) = nan;
            data{1,itrial}.box=data{1,itrial}.box(~isnan(data{1,itrial}.box(:,1)),:);
        end
            
        data{1,itrial}.gap(falsegap,:) = nan; 
        data{1,itrial}.gap=data{1,itrial}.gap(~isnan(data{1,itrial}.gap(:,1)),:);
        
    end
        




end

