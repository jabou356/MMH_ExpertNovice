function data = rMMH_emg_compute (data,freq)  %(MVC,data,freq) Add MVC for real data. Uncomment linee 48
%this function is mostly the same as emg_compute, but without time
%normalization
%% parameters
param.bandfilter = [10,450]; % lower and upper freq
param.lowfilter = nan;
param.RMSwindow = 250 * freq / 1000 ;
if mod(param.RMSwindow,2)==0 %if bin length is an even number
    param.RMSwindow=param.RMSwindow+1;
end

%% treatment
for itrial = length(data):-1:1
    emg = data{itrial}.emg;
    
    % 1) Rebase
    emg = emg - repmat(mean(emg),size(emg,1),1);
    
    % 2) band-pass filter
    [b, a]=butter(2, [param.bandfilter(1)/(freq/2) param.bandfilter(2)/(freq/2)]);
    for imuscle=1:size(data{itrial}.emg,2)
        emg(:,imuscle)=filtfilt(b,a,emg(:,imuscle));
    end
    
    %% method lp
    %) 3) signal rectification
    
    
    %     % 4) low pass filter at 5Hz
    %     emg = lpfilter(emg, param.lowfilter, freq.emg);
    %
    % %% method rms
    % 3) RMS
    
	femg = emg;
	emg = abs(emg);
    temp=mean(emg(1:param.RMSwindow,:),1);
    RMS(1:floor(param.RMSwindow/2),:)=repmat(temp,floor(param.RMSwindow/2),1);
    temp=mean(emg(end-param.RMSwindow+1:end,:),1);
    RMS(ceil(length(emg)-param.RMSwindow/2)+1:length(emg),:)=repmat(temp,floor(param.RMSwindow/2),1);
    
    for i=ceil(param.RMSwindow/2):ceil(length(emg)-param.RMSwindow/2)
        RMS(i,:)=mean(emg(ceil(i-param.RMSwindow/2):floor(i+param.RMSwindow/2),:),1);
    end
    
    % 5) Normalization
   % emg = emg ./ (repmat(MVC/100,size(emg,1),1)); 
    
    data{itrial}.rmsEMG = RMS;
    data{itrial}.femg = femg;


    clearvars emg RMS 
end


