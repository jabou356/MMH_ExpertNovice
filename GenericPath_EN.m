%% Chargement des fonctions
% WhereRU=menu('Where are you','At Home', 'At the Office');
% if WhereRU ==1
%     Path.ServerAddressE='\\bime'c7-kinesio.kinesio.umontreal.ca\e';
%     Path.ServerAddressF='\\bimec7-kinesio.kinesio.umontreal.ca\f';
% elseif WhereRU == 2
%     Path.ServerAddressE='E:';
%     Path.ServerAddressF='F:';
% end

Path.ServerAddressE=uigetdir('C:','Go get the E: path');
Path.ServerAddressF=uigetdir('C:','Go get the F: path');
Path.machinetype=menu('Are you working on a MAC or a PC?', 'PC','MAC');

if Path.machinetype == 1 % If PC: backslashes
    
%     if isempty(strfind(path, [Path.ServerAddressE, '\Librairies\S2M_Lib\']))
%         % Librairie S2M
%         cd([Path.ServerAddressE '\Librairies\S2M_Lib\']);
%         S2MLibPicker;
%     end
    
    
    %% Setup common data path    
    % Project Path
    Path.ExpertNovice=[Path.ServerAddressE, '\Projet_ExpertsNovices\'];
	
	% Initial Paths
	Path.ExcelPath=[Path.ExpertNovice, 'excel\'];
	Path.importRaw=[Path.ExpertNovice, 'data\raw\'];
	
	
    % Processed data
    Path.ProcessedData=[Path.ExpertNovice, 'ElaboratedData\'];
    
	Path.Matrices=[Path.ProcessedData, 'matrices\'];
	Path.Fatigue=[Path.Matrices, 'Fatigue\'];
    Path.RepetitiveMMH=[Path.Fatigue, 'RepetitiveMMH\'];
	Path.StandardEMG=[Path.Fatigue, 'StandardEMG\'];
	
	Path.OSIMPath=[Path.ProcessedData, 'OpenSim\'];
	
	Path.GroupData=[Path.ProcessedData, 'GroupData\'];
	Path.GroupFatigue = [Path.GroupData, 'Fatigue\'];
	Path.GroupStandardEMG = [Path.GroupFatigue, 'StandardEMG\'];
	  
    % Setup common OpenSim paths
    Path.OpensimSetupJB=[Path.OSIMPath, 'OpenSimSetUpFiles\'];
    Path.OpensimGenericModel=[Path.OpensimSetupJB,'GenericShoulderCoRAnatoJB.osim'];
    Path.OpensimGenericScale=[Path.OpensimSetupJB,'Conf_scaling.xml'];
    Path.OpensimGenericIK=[Path.OpensimSetupJB,'Conf_IK.xml'];
    Path.OpensimGenericMD=[Path.OpensimSetupJB,'Conf_MD.xml'];
    
elseif Path.machinetype == 2 %if MAC: forward slashes
    
%     if isempty(strfind(path, [Path.ServerAddressE, '/Librairies/S2M_Lib/']))
%         % Librairie S2M
%         cd([Path.ServerAddressE '/Librairies/S2M_Lib/']);
%         S2MLibPicker;
%     end
    
    
    %% Setup common data path
    
    % Project Path
    Path.ExpertNovice=[Path.ServerAddressE, '/Projet_ExpertsNovices/'];
	
	% Initial Paths
	Path.ExcelPath=[Path.ExpertNovice, 'excel/'];
	Path.importRaw=[Path.ExpertNovice, 'data/raw/'];
	
    % Processed data
    Path.ProcessedData=[Path.ExpertNovice, 'ElaboratedData/'];
	
	Path.OSIMPath=[Path.ProcessedData, 'OpenSim/'];
	
    Path.Matrices=[Path.ProcessedData, 'matrices/'];
    Path.Fatigue=[Path.Matrices, 'Fatigue/'];
    Path.RepetitiveMMH=[Path.Fatigue, 'RepetitiveMMH/'];
	Path.StandardEMG=[Path.Fatigue, 'StandardEMG/'];
	
	Path.GroupData=[Path.ProcessedData, 'GroupData/'];
	Path.GroupFatigue = [Path.GroupData, 'Fatigue/'];
	Path.GroupStandardEMG = [Path.GroupFatigue, 'StandardEMG/'];
    
    % Setup common OpenSim paths
    Path.OpensimSetupJB=[Path.OSIMPath, 'OpenSimSetUpFiles/'];
    Path.OpensimGenericModel=[Path.OpensimSetupJB,'GenericShoulderCoRAnatoJB.osim'];
    Path.OpensimGenericScale=[Path.OpensimSetupJB,'Conf_scaling.xml'];
    Path.OpensimGenericIK=[Path.OpensimSetupJB,'Conf_IK.xml'];
    Path.OpensimGenericMD=[Path.OpensimSetupJB,'Conf_MD.xml'];
    
end