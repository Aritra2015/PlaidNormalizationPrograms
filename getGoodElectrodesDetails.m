function [tmpElectrodeStringList,tmpElectrodeArrayList,allElecs,monkeyNameList] = getGoodElectrodesDetails(monkeyName,sessionNum,oriSelectiveFlag,folderSourceString)
gridType = 'microelectrode';


if sessionNum <= 22 % data for a single session for any monkey
    monkeyNameList{1} = monkeyName; 
    tmpElectrodeStringList = cell(1,1);
    tmpElectrodeArrayList = cell(1,1);
    
    numSessions = 1;
    tmpElectrodeListArray = cell(1,numSessions);
    tmpElectrodeListStr = cell(1,numSessions);
    numElecs = 0;
    
    [tmpElectrodeListArray{1},tmpElectrodeListStr{1},goodElectrodes] = getGoodElectrodesSingleSession(monkeyName,gridType,sessionNum,folderSourceString,oriSelectiveFlag);
    numElecs = numElecs+length(goodElectrodes);
    
    tmpElectrodeStringList{1} = tmpElectrodeListStr;
    tmpElectrodeArrayList{1} = tmpElectrodeListArray;
    allElecs = numElecs;
         
elseif sessionNum == 23 || sessionNum == 24 % data combined across all sessions for alpaH or kesariH
    monkeyNameList{1} = monkeyName; 
    tmpElectrodeStringList = cell(1,1);
    tmpElectrodeArrayList = cell(1,1);
    allElecs = zeros(1,1);
    for i=1:1
        disp(['MonkeyName: ' monkeyName])
        clear expDates protocols
        [~,protocolNames,~,~]= dataInformationPlaidNorm(monkeyName,gridType,0);
%         protocolNames = protocols{sessionNum};
        numSessions = length(protocolNames);
        tmpElectrodeListArray = cell(1,numSessions);
        tmpElectrodeListStr = cell(1,numSessions);
        numElecs = 0;
        for SessionNum = 1:numSessions
            [tmpElectrodeListArray{SessionNum},tmpElectrodeListStr{SessionNum},goodElectrodes] = getGoodElectrodesSingleSession(monkeyName,gridType,SessionNum,folderSourceString,oriSelectiveFlag);
            numElecs = numElecs+length(goodElectrodes);
        end
        tmpElectrodeStringList{i} = tmpElectrodeListStr;
        tmpElectrodeArrayList{i} = tmpElectrodeListArray;
        allElecs(i) = numElecs;
    end  

elseif strcmp(monkeyName,'all') && sessionNum == 25 % data combined across all sessions for both monkeys
    monkeyNameList{1} = 'alpaH'; monkeyNameList{2} = 'kesariH';

    tmpElectrodeStringList = cell(1,2);
    tmpElectrodeArrayList = cell(1,2);
    allElecs = zeros(1,2);
    for i=1:2
        disp(['MonkeyName: ' monkeyNameList{i}])
        clear expDates protocols
        [~,protocolNames,~,~]= dataInformationPlaidNorm(monkeyNameList{i},gridType,0);
%         protocolNames = protocols{sessionNum};
        numSessions = length(protocolNames);
        tmpElectrodeListArray = cell(1,numSessions);
        tmpElectrodeListStr = cell(1,numSessions);
        numElecs = 0;
        for SessionNum = 1:numSessions
            [tmpElectrodeListArray{SessionNum},tmpElectrodeListStr{SessionNum},goodElectrodes] = getGoodElectrodesSingleSession(monkeyNameList{i},gridType,SessionNum,folderSourceString,oriSelectiveFlag);
            numElecs = numElecs+length(goodElectrodes);
        end
        tmpElectrodeStringList{i} = tmpElectrodeListStr;
        tmpElectrodeArrayList{i} = tmpElectrodeListArray;
        allElecs(i) = numElecs;
    end
end