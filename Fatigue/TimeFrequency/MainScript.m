%% KIN = CONTREX: Wavelet de Morlet (sinus * Gaussien)

%clear ; close all ; clc
tic

%path = '\\10.89.24.15' ;

%load([path '\f\Data\Contrex\Projet_Sylvain\Results\FatigueResults_controlswimmers.mat'])
%load([path '\f\Data\Contrex\Projet_Sylvain\Results\Fatigue_EMGdeleteReps.mat'])

%addpath([path '\e\Bureau\Fabien\Projet_Fatigue_Musculaire\wtc-r16'])

MuscleNames = {'Pectoralis_major', 'Latissimus_dorsi', 'Upper_Trapezius', 'Middle_Trapezius',...
    'Lower_Trapezius', 'Posterior_Deltoid', 'Medial_Deltoid', 'Serratus_anterior',...
    'Supraspinatus', 'Infraspinatus', 'Subscapularis'} ;

Freq = 900 ;
FreqContrex = 128 ;
tic
for iS = 1:27
    disp(iS)
    DATA_EMG = FatResults.FatigueRAW{iS,1}(:,1:11) ;
    Cycles_EMG = FatResults.locpks{iS,1} ;
    
    DATA_Kin = FatResults.CXP{iS,1} ;
    Cycles_Kin = FatResults.locpksCXP{iS,1} ;
    
    %% EMG cleaning
    DATA_EMG = pretraitementEMG(DATA_EMG(:,1:11),Freq) ;
    
    [b,a] = butter(2,2*10/FreqContrex) ;
    DATA_Kin(:,1) = filtfilt(b,a,DATA_Kin(:,1)) ;
    
    %% Epoch trials
    iT = 1 ; Trials = [] ;
    for p=1:2:length(Cycles_EMG)-1
        Trials{iT,1} = DATA_EMG(Cycles_EMG(p):Cycles_EMG(p+2),:) ;
        
        tmp = DATA_Kin(Cycles_Kin(p):Cycles_Kin(p+2),:) ;
        Trials{iT,1}(:,12:14) = interp1(1:length(tmp),tmp,linspace(1,length(tmp),length(Trials{iT,1})),'spline') ;
        
        iT = iT + 1 ;
    end
    
    %% Remove bad trials
    Bad_Trials = EMGdelete{iS,1} ;
    for iT = 1:50
        Trials{iT,1}(:,Bad_Trials(iT,:)==1) = nan ;        
    end   
    
    %% TFR
    FreqMin = 1 ; % low pass filter (on pourrait mettre low pass)
    FreqMax = 400 ; % high pass
    Resolution = 1 ; % pas de 1 Hz
    WaveNumber = 7 ; % Résolution temporelle
    Args = WaveletParameters(FreqMin,FreqMax,Resolution,WaveNumber,Freq) ;
    FreqRange = length(FreqMin:Resolution:FreqMax) ;
    Nb_Interp_Pnts = 1 ; % Si 1 pas d'interpolation, sinon mettre le nombre de point désiré
    
    %% Compute TFR
    for iM = 1:length(MuscleNames)
        TFR.(MuscleNames{iM}) = nan(length(FreqMin:Resolution:FreqMax), Nb_Interp_Pnts) ;
        MedianFreq.(MuscleNames{iM}) = nan(Nb_Interp_Pnts,length(Trials)) ;
        
        for iT = 1:length(Trials)
            if sum(isnan(Trials{iT,1}(:,iM)))==0 % il ne faut pas de NaN au début et à la fin (ou au milieu) de l'essai
                [norm, Time, Wave_FreqS] = TimeFreqTransform(Trials{iT,1}(:,iM),Freq,Args,Nb_Interp_Pnts) ;
                TFR.(MuscleNames{iM})(:,:,iT) = norm ;                
                MedianFreq.(MuscleNames{iM})(:,iT) = Compute_Median_Frequency(TFR.(MuscleNames{iM})(:,:,iT),Wave_FreqS) ;
            end            
        end
    end
    
    TFR.freq = Wave_FreqS ;
    TFR.time = 1:100 ;
    TFR.muscles = MuscleNames ;
    MedianFreq.muscles = MuscleNames ;
    
    Contrex = [] ;
    for iT = 1:length(Trials)
        Contrex(:,:,iT) = interp1(1:length(Trials{iT,1}),Trials{iT,1}(:,12:14),1:length(Trials{iT,1})/100:length(Trials{iT,1}),'spline') ;
    end
    
    %save([path '\e\Bureau\Fabien\Projet_Fatigue_Musculaire\Results\TFR_Subject_' num2str(iS)], 'TFR')
    %save([path '\e\Bureau\Fabien\Projet_Fatigue_Musculaire\Results\Contrex_Subject_' num2str(iS)], 'Contrex')
    %save([path '\e\Bureau\Fabien\Projet_Fatigue_Musculaire\Results\MedianFreq_Subject_' num2str(iS)], 'MedianFreq')
    
    clear TFR Contrex
    toc ; tic
end

