clear

Muscles = {'deltant', 'deltmed', 'deltpost', 'biceps', 'triceps', 'uptrap'...
	, 'pect' 'ssp', 'isp', 'subs'}; %THIS IS THE GOOD CONVENTION

trialsForTimefreq = {'s_u'};

useold = 0;
%% Import generic paths
GenericPath_EN

%% Get participants
load(Path.SubjectID);
trialsForTimefreq = {'s_u'};

if useold 
    load([Path.GroupFatigue, 'GroupEMGMMH.mat']);
end
    
for isujet = [ 30 31 32]%length(Alias.pseudo):-1:1
    
    %% Load data
    load([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat']);
    
    for icond = 1: length(trialsForTimefreq)
     trials = find(cellfun(@(x,y)(strncmp(trialsForTimefreq{icond},x.trialname{1},3)),data));

    for imuscle = 1:length(Muscles)
        y = cellfun(@(x)(mean(mean(x.TFMedianFrequency(:,imuscle,:),3,'omitnan'))),data(trials));
        y = y / y(1);
        x = 1: length(trials);
        GroupData.FreqMed((isujet-1)*length(Muscles)*length(trialsForTimefreq)+(icond-1)*length(Muscles)+imuscle,:)=...
        interp1(x,y,1:(length(x)-1)/9:length(x));
    %GroupData{isujet}.(trialsForTimefreq{icond}).FreqMed{imuscle} = interp1(x,y,1:(length(x)-1)/9:length(x));
        
        y = cellfun(@(x)(mean(mean(x.NormRMS(:,imuscle,:),3,'omitnan'))),data(trials));
        y = y / y(1);
        GroupData.RMS((isujet-1)*length(Muscles)*length(trialsForTimefreq)+(icond-1)*length(Muscles)+imuscle,:)=...
        interp1(x,y,1:(length(x)-1)/9:length(x));
        %GroupData{isujet}.(trialsForTimefreq{icond}).RMS{imuscle} = interp1(x,y,1:(length(x)-1)/9:length(x));
        GroupData.muscle((isujet-1)*length(Muscles)*length(trialsForTimefreq)+(icond-1)*length(Muscles)+imuscle,:)=...
        data{1}.emgname(imuscle);
        GroupData.Cond((isujet-1)*length(Muscles)*length(trialsForTimefreq)+(icond-1)*length(Muscles)+imuscle,:)=...
        trialsForTimefreq(icond);

    end
    end
end

save([Path.GroupFatigue, 'GroupEMGMMH.mat'],'GroupData');