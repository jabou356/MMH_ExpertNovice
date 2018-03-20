if Path.machinetype == 1 % If PC: backslashes
%% Chemin des fichiers d'importation
    % Dossier du sujet
    Path.DirModels  = [Path.ServerAddressF '\Data\Shoulder\Lib\' Alias.pseudo{isujet} 'd\Model_2\'];
    % Dossier du modèle pour le sujet
    Path.pathModel  = [Path.DirModels 'Model.s2mMod'];
    % Dossier des data
	
    Path.importdata = [Path.importRaw Alias.date{isujet}, '\' Alias.pseudo{isujet}, '\'];
    Path.importfatigue = [Path.importdata 'fatigue\'];
	

	
	%% Dossiers d'exportation OpenSim, if those folder, don't exist, create them
    % Dossier général
	Path.OSIMexportPath = [Path.OSIMPath, Alias.pseudo{isujet} '\'];
    
    if isdir(Path.OSIMexportPath)==0
        mkdir(Path.OSIMexportPath);
	end
    
	% Dossier .trc (marqueurs)
    Path.TRCpath=[Path.OSIMexportPath,'TRC\'];
    if isdir(Path.TRCpath)==0
        mkdir(Path.TRCpath);
	end
    
	% Dossier .mot (Qs)
    Path.IKpath=[Path.OSIMexportPath,'IKOSIM\'];
    Path.IKresultpath=[Path.IKpath,'result\'];
    Path.IKsetuppath=[Path.IKpath,'setup\'];
    if isdir(Path.IKpath)==0
        mkdir(Path.IKpath);
        mkdir(Path.IKresultpath);
        mkdir(Path.IKsetuppath);
	end
    
	% Dossier muscle direction
    Path.MDpath=[Path.OSIMexportPath,'MuscleDirection\'];
    Path.MDresultpath=[Path.MDpath,'result\'];
    Path.MDsetuppath=[Path.MDpath,'setup\'];
    if isdir(Path.MDpath)==0
        mkdir(Path.MDpath);
        mkdir(Path.MDresultpath);
        mkdir(Path.MDsetuppath);
    end
    
elseif Path.machinetype == 2 % If MAC: forward slashes
    %% Chemin des fichiers d'importation
    % Dossier du sujet
    Path.DirModels  = [Path.ServerAddressF '/Data/Shoulder/Lib/' Alias.pseudo{isujet} 'd/Model_2/'];
   
	% Dossier du modèle pour le sujet
    Path.pathModel  = [Path.DirModels 'Model.s2mMod'];
	
    % Dossier des data brutes
	Path.importdata = [Path.importRaw Alias.date{isujet}, '\' Alias.pseudo{isujet}, '\'];
	Path.importfatigue = [Path.importdata 'fatigue/'];


    %% Dossiers d'exportation OPENSIM, si le dossier n'existe pas, crée le
	% Dossier général
    Path.OSIMexportPath = [Path.OSIMPath, Alias.pseudo{isujet} '/'];
  
    if isdir(Path.OSIMexportPath)==0
        mkdir(Path.OSIMexportPath);
	end
	
    % Dossier .trc (marqueurs)
    Path.TRCpath=[Path.OSIMexportPath,'TRC/'];
    if isdir(Path.TRCpath)==0
        mkdir(Path.TRCpath);
	end
    
	% Dossier .mot (Qs)
    Path.IKpath=[Path.OSIMexportPath,'IKOSIM/'];
    Path.IKresultpath=[Path.IKpath,'result/'];
    Path.IKsetuppath=[Path.IKpath,'setup/'];
    if isdir(Path.IKpath)==0
        mkdir(Path.IKpath);
        mkdir(Path.IKresultpath);
        mkdir(Path.IKsetuppath);
	end
    
	% Dossier muscle direction
    Path.MDpath=[Path.OSIMexportPath,'MuscleDirection/'];
    Path.MDresultpath=[Path.MDpath,'result/'];
    Path.MDsetuppath=[Path.MDpath,'setup/'];
    if isdir(Path.MDpath)==0
        mkdir(Path.MDpath);
        mkdir(Path.MDresultpath);
        mkdir(Path.MDsetuppath);
    end
end
    