function [data] = TimeFreqEMG(data,trials)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% TFR
    Freq = data{1,1}.analogueFz;
    FreqMin = 10 ; % low pass filter (on pourrait mettre low pass)
    FreqMax = 450 ; % high pass
    Resolution = 1 ; % pas de 1 Hz
    WaveNumber = 7 ; % Résolution temporelle
    Args = WaveletParameters(FreqMin,FreqMax,Resolution,WaveNumber,Freq) ;
    FreqRange = length(FreqMin:Resolution:FreqMax) ;
    Nb_Interp_Pnts = 100; 

   % Nb_Interp_Pnts = 1 ; % Si 1 pas d'interpolation, sinon mettre le nombre de point désiré
    
    for itrial = 1 : length(trials)
        for imuscle = 1 : size(data{1,trials(itrial)}.femg,2)
            
            for ibox = 1:length(data{trials(itrial)}.Partfemg)
             disp(['Processing trial: ' num2str(itrial) ' / ', num2str(length(trials)), ', muscle: ',...
                 num2str(imuscle) ' / ', num2str(size(data{1,trials(itrial)}.femg,2))])
             
            if sum(isnan(data{1,trials(itrial)}.Partfemg{ibox}(:,imuscle))) == 0
               [data{trials(itrial)}.TimeFreqEMG(:,:,imuscle,ibox), data{1,trials(itrial)}.Time, data{1,trials(itrial)}.Wave_FreqS]...
                   = TimeFreqTransform(data{1,trials(itrial)}.Partfemg{ibox}(:,imuscle),Freq,Args,Nb_Interp_Pnts);
               
               data{trials(itrial)}.TFMedianFrequency(:,imuscle, ibox) = Compute_Median_Frequency(...
                   data{trials(itrial)}.TimeFreqEMG(:,:,imuscle,ibox),data{1,trials(itrial)}.Wave_FreqS);
                   
            end
            
            end
            
        end
        
    end

    
end

