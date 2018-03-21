function [data] = TimeFreqEMG(data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% TFR
    Freq = data{1,1}.analogueFz;
    FreqMin = 10 ; % low pass filter (on pourrait mettre low pass)
    FreqMax = 450 ; % high pass
    Resolution = 1 ; % pas de 1 Hz
    WaveNumber = 7 ; % R�solution temporelle
    Args = WaveletParameters(FreqMin,FreqMax,Resolution,WaveNumber,Freq) ;
    FreqRange = length(FreqMin:Resolution:FreqMax) ;
   % Nb_Interp_Pnts = 1 ; % Si 1 pas d'interpolation, sinon mettre le nombre de point d�sir�
    
    for itrial = 1 : length(data)
       Nb_Interp_Pnts = size(data{1,itrial}.femg,1); 
        for imuscle = 1 : size(data{1,itrial}.femg,2)
            
            if sum(isnan(data{1,itrial}.femg(:,imuscle))) == 0
               [data{itrial}.TimeFreqEMG(:,:,imuscle), data{1,itrial}.Time, data{1,itrial}.Wave_FreqS]...
                   = TimeFreqTransform(data{1,itrial}.femg(:,imuscle),Freq,Args,Nb_Interp_Pnts);
            end
            
        end
        
    end

    
end

