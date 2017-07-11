clear

handdur=1.5*2000; %durée de transport de la boîte et déplacements: 1.5seconds * 2000 Hz

%% Import generic paths
GenericPath_EN

%% Get participants
[~,Alias.pseudo,~]=xlsread([Path.ExpertNovice, 'participants.xlsx'],...
    'Information participant', 'E5:E100');

for isujet = 1%length(Alias.pseudo):-1:1
    
    load([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat']);
    
    %% Make triggers on EMG channel and ACC channel consistent
    %Identify which trigger is on EMG channel (trig1) and which is on ACC channel based on offset (trig2)
    offsettrig=min(data(1).trigger,[],1);
    trig1=find(offsettrig==max(offsettrig));
    trig2=find(offsettrig~=max(offsettrig));
    
    for itrial=1:length(data)
        % for each trial remove the offset
        offsettrig=min(data(itrial).trigger,[],1);
        data(itrial).ftrigger=data(itrial).trigger-offsettrig;
        
        %Smoothe les données pour compenser pour la différence d'acquisition
        for j=7:size(data(itrial).ftrigger,1)-6
            data(itrial).ftrigger(j,trig2)=mean(data(itrial).ftrigger(j-6:j+6,trig2));
        end
        
        % Ajuste le gain pour qu'ils soient dans le même ordre de grandeur
        data(itrial).ftrigger(:,trig2)=data(itrial).ftrigger(:,trig2)/10; 
        
        %% Identify each box handling
        % find instants when a box is handled
        tempbox=find(sum(data(itrial).ftrigger,2)>0.02);
        
        % find the instant when a box is handle just before and after a 1 second gap 
        data(itrial).box(1,1)=tempbox(1);
        data(itrial).box(1,2)=tempbox(find(diff(tempbox)>handdur,1,'first'));
        
        i=2;
        while data(itrial).box(i-1,2)<tempbox(end)
            
            data(itrial).box(i,1)=tempbox(find(tempbox>data(itrial).box(i-1,2)+handdur,1,'first'));
            
            if ~isempty(find(tempbox(1:end-1)>data(itrial).box(i,1)+handdur & diff(tempbox)>handdur))
            data(itrial).box(i,2)=tempbox(find(tempbox(1:end-1)>data(itrial).box(i,1)+handdur...
                & diff(tempbox)>handdur,1,'first'));
            else
                data(itrial).box(i,2)=tempbox(end);
            end
            
            i=i+1;
        end
            
        data(itrial).box=data(itrial).box(2:end-1,1:2);
           
        
    end
    save([Path.RepetitiveMMH, Alias.pseudo{isujet}, '.mat'], 'data');
    clear data
    
end
