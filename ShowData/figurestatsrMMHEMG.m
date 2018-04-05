clear g
close all
Muscles = {'deltant', 'deltmed', 'deltpost', 'biceps', 'triceps', 'uptrap'...
	, 'pect' 'ssp', 'isp', 'subs'}; %THIS IS THE GOOD CONVENTION

for imuscle = 1 : length(Muscles)
%% FreqMed Stats
% Code for computing paired t-test for FreqMed
flag = strcmp(GroupData.muscle,Muscles{imuscle})' & ...
    ~isnan(GroupData.FreqMed(:,1))' ;

Y1 = GroupData.FreqMed(flag, 1);
Y2 = GroupData.FreqMed(flag, end); 

snpm       = spm1d.stats.ttest_paired(Y1,Y2);
snpmi = snpm.inference(0.05, 'two_tailed', true);
MDFTTEST.(Muscles{imuscle}).z = snpmi.z;
MDFTTEST.(Muscles{imuscle}).zstar = snpmi.zstar;
MDFTTEST.(Muscles{imuscle}).p = snpmi.p;

%% FreqMed plot
% Code for generating figure for FreqMed

if ismember(imuscle, 1:3)
    g(1,imuscle)=gramm('x',repmat([1:10]',1,length(GroupData.muscle))','y',GroupData.FreqMed,'subset', flag);
    g(1,imuscle).stat_summary('type','sem','geom','area','setylim','true');
    g(1,imuscle).set_title([Muscles{imuscle}, ' FreqMed: p =' num2str(MDFTTEST.(Muscles{imuscle}).p)]);

elseif ismember(imuscle, 4:6)
    g(2,imuscle-3)=gramm('x',repmat([1:10]',1,length(GroupData.muscle))','y',GroupData.FreqMed,'subset', flag);
    g(2,imuscle-3).stat_summary('type','sem','geom','area','setylim','true');
    g(2,imuscle-3).set_title([Muscles{imuscle}, ' FreqMed: p =' num2str(MDFTTEST.(Muscles{imuscle}).p)]);

elseif ismember(imuscle, 7:9)
    g(3,imuscle-6)=gramm('x',repmat([1:10]',1,length(GroupData.muscle))','y',GroupData.FreqMed,'subset', flag);
    g(3,imuscle-6).stat_summary('type','sem','geom','area','setylim','true');
    g(3,imuscle-6).set_title([Muscles{imuscle}, ' FreqMed: p =' num2str(MDFTTEST.(Muscles{imuscle}).p)]);

elseif ismember(imuscle, 10)
    g(4,imuscle-9)=gramm('x',repmat([1:10]',1,length(GroupData.muscle))','y',GroupData.FreqMed,'subset', flag);
    g(4,imuscle-9).stat_summary('type','sem','geom','area','setylim','true');
    g(4,imuscle-9).set_title([Muscles{imuscle}, ' FreqMed: p =' num2str(MDFTTEST.(Muscles{imuscle}).p)]);

end

%% rms Stats
% Code for computing paired t-test for RMS

flag = strcmp(GroupData.muscle,Muscles{imuscle})' & ...
    ~isnan(GroupData.RMS(:,1))' ;

Y1 = GroupData.RMS(flag, 1);
Y2 = GroupData.RMS(flag, end); 

snpm       = spm1d.stats.ttest_paired(Y1,Y2);
snpmi = snpm.inference(0.05, 'two_tailed', true);
RMSTTEST.(Muscles{imuscle}).z = snpmi.z;
RMSTTEST.(Muscles{imuscle}).zstar = snpmi.zstar;
RMSTTEST.(Muscles{imuscle}).p = snpmi.p;

%% RMS plot
% Code for creating figures for RMS

if ismember(imuscle, 1:3)
    h(1,imuscle)=gramm('x',repmat([1:10]',1,length(GroupData.muscle))','y',GroupData.RMS,'subset', flag);
    h(1,imuscle).stat_summary('type','sem','geom','area','setylim','true');
    h(1,imuscle).set_title([Muscles{imuscle}, ' RMS: p =' num2str(RMSTTEST.(Muscles{imuscle}).p)]);

elseif ismember(imuscle, 4:6)
    h(2,imuscle-3)=gramm('x',repmat([1:10]',1,length(GroupData.muscle))','y',GroupData.RMS,'subset', flag);
    h(2,imuscle-3).stat_summary('type','sem','geom','area','setylim','true');
    h(2,imuscle-3).set_title([Muscles{imuscle}, ' RMS: p =' num2str(RMSTTEST.(Muscles{imuscle}).p)]);

elseif ismember(imuscle, 7:9)
    h(3,imuscle-6)=gramm('x',repmat([1:10]',1,length(GroupData.muscle))','y',GroupData.RMS,'subset', flag);
    h(3,imuscle-6).stat_summary('type','sem','geom','area','setylim','true');
    h(3,imuscle-6).set_title([Muscles{imuscle}, ' RMS: p =' num2str(RMSTTEST.(Muscles{imuscle}).p)]);

elseif ismember(imuscle, 10)
    h(4,imuscle-9)=gramm('x',repmat([1:10]',1,length(GroupData.muscle))','y',GroupData.RMS,'subset', flag);
    h(4,imuscle-9).stat_summary('type','sem','geom','area','setylim','true');
    h(4,imuscle-9).set_title([Muscles{imuscle}, ' RMS: p =' num2str(RMSTTEST.(Muscles{imuscle}).p)]);

end

end

%% EMG signs of fatigue
% After filtering (debase + zerolag 10-450 Hz butterworth) Data have been 
% partitionned using biceps and anterior deltoid RMS EMG using a 
% combination of automatic threshold detection (+2SD of gaps with a minimal
% contraction duration of 2 seconds) + manual validation. 
% 
% RMS EMG have been calculated with a 250 ms window width, then summarized 
% in a single point for each trial by averaging.
% Median frequency have been calculated using Morlet's Wavelets (Fabien's
% codes) on partitionned data, then summarized in a single point for each
% trial by averaging.  

%% Changes in Median Frequency with fatigue during repetitive Manual material handling
% Median Frequency: Data are shown for trials when participants lifted the
% small boxes from the pallet to the highest location on the box pile. 
% X axis: 1 = beginning of the experiment,  10 = end of the experiment (45
% minutes)
% Y axis: MedFreq(x) / MedFreq(1)
% P values are presented for a paired t-test MedFreq(1) vs MedFreq(10)
% Data are presented for 10 experts subjects
figure('units','normalized','outerposition',[0 0 0.8 0.8])
g.draw;

%% Changes in RMS  with fatigue during repetitive Manual material handling
% RMS: Data are shown for trials when participants lifted the
% small boxes from the pallet to the highest location on the box pile. 
% X axis: 1 = beginning of the experiment,  10 = end of the experiment (45
% minutes)
% Y axis: RMS(x) / RMS(1)
% P values are presented for a paired t-test RMS(1) vs RMS(10)
% Data are presented for 10 experts subjects
figure('units','normalized','outerposition',[0 0 0.8 0.8])
h.draw  ; 

