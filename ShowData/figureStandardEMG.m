close all
muscle='deltmed';
trial={'pre_abd', 'post_abd'};

RMSfig=figure('name', 'RMS fatigue', 'Color', 'w', 'NumberTitle', 'off',...
	'Position', [0, 0, 1000, 500]);

myax(1)=subplot(3,1,1);
baseline=mean(GroupData.onesecRMS.(muscle).(trial{1}),1);
plot([GroupData.onesecRMS.(muscle).(trial{1})./repmat(baseline,2,1)*100; GroupData.onesecRMS.(muscle).(trial{2})./repmat(baseline,2,1)*100],'bo-')
hold on
plot([1 4],[100, 100],'k','linewidth',3)
plot([1.5, 3.5], [mean(GroupData.onesecRMS.(muscle).(trial{1}),1)./baseline*100; mean(GroupData.onesecRMS.(muscle).(trial{2}),1)./baseline*100],'ro-')


myax(2)=subplot(3,1,2);
baseline=mean(GroupData.MedFreq.(muscle).(trial{1}),1);
plot([GroupData.MedFreq.(muscle).(trial{1})-repmat(baseline,2,1); GroupData.MedFreq.(muscle).(trial{2})-repmat(baseline,2,1)],'bo-')
hold on
plot([1 4],[0, 0],'k','linewidth',3)
plot([1.5, 3.5], [mean(GroupData.MedFreq.(muscle).(trial{1}),1)-baseline; mean(GroupData.MedFreq.(muscle).(trial{2}),1)-baseline],'ro-')


myax(3)=subplot(3,1,3);
plot([GroupData.trialduration.(trial{1})-GroupData.plateautiming.(muscle).(trial{1}); GroupData.trialduration.(trial{2})-GroupData.plateautiming.(muscle).(trial{2})],'bo-')


