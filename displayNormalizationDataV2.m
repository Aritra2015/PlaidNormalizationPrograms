% This program displays results of Normalization experiments
% for different neural measures - spikes / LFP (alpha, gamma or SSVEP power)
% for a single session or all sessions for a single monkey or both monkeys
% based on options selected in the GUI panel

% Response matrix is drawn in such a way that rows correspond to increasing
% contrasts of component Grating 2 in positive y direction and columns
% correspond to contrasts of component Grating 1 in positive x direction

function displayNormalizationDataV2(folderSourceString)

if ~exist('folderSourceString','var')
    if strcmp(getenv('username'),'RayLabPC-Aritra') || strcmp(getenv('username'),'Lab Computer-Aritra')
        folderSourceString = 'E:\data\PlaidNorm\';
    else
        folderSourceString = 'M:\CommonData\Non_Standard\PlaidNorm\';
    end
end

close all; % closes any open figure to avoid any overlaying issues

% Display Options
fontSizeSmall = 10; fontSizeMedium = 12; fontSizeLarge = 16; % Fonts
panelHeight = 0.2; panelStartHeight = 0.68; backgroundColor = 'w'; % Panels

hFigure = figure(1);
set(hFigure,'units','normalized','outerposition',[0 0 1 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Session(s) panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FileNameString
[fileNameStringAll,~,fileNameStringListArray] = getFileNameStringList;

figure(1);
hSessionPanel= uipanel('Title','Session Panel','titleposition','centertop',...
    'fontSize',fontSizeLarge,'Unit','Normalized','Position',...
    [0.05 0.89 0.225 0.11]);

hSession = uicontrol('Parent',hSessionPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, 'Position', ...
    [0 0.9 1 0.12], 'HorizontalAlignment','Center','Style',...
    'popup','String',...
    fileNameStringAll,'FontSize',fontSizeLarge);

% To align the strings inside the pop-up menu, a separate function jobj
% is required which uses JAVA graphics properties
% jobj = findjobj(hSession);
% renderer = jobj.getRenderer();
% renderer.setHorizontalAlignment(renderer.CENTER);

hOriTunedCheckbox = uicontrol('Parent',hSessionPanel,'Unit','Normalized',...
    'Position',[0.18 0.1 0.8 0.3],'Style','checkbox',...
    'String','Orientation tuned Electrodes','FontSize',fontSizeMedium);

hTimingPanel = uipanel('Title','Timing Panel','titleposition','centertop',...
    'fontSize',fontSizeLarge,'Unit','Normalized','Position',...
    [0.275 0.89 0.225 0.11]);

timingTextWidth = 0.5; timingBoxWidth = 0.2;
timingHeight = 1/3;

uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[0 1-timingHeight 0.5 timingHeight],...
    'Style','text','String','Parameter','FontSize',fontSizeSmall);

uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[timingTextWidth 1-timingHeight timingBoxWidth...
    timingHeight], 'Style','text','String','Min',...
    'FontSize',fontSizeSmall);

uicontrol('Parent',hTimingPanel,'Unit','Normalized', ...
    'Position',[timingTextWidth+timingBoxWidth 1-timingHeight ...
    timingBoxWidth timingHeight], ...
    'Style','text','String','Max','FontSize',fontSizeSmall);


% Stimulus Range
stimPeriod = [0.15 0.4];
uicontrol('Parent',hTimingPanel,'Unit','Normalized',...
    'Position',[0 1-3*timingHeight 0.5 timingHeight]...
    ,'Style','text','String','Stim Period (s)',...
    'FontSize',fontSizeSmall);
hStimPeriodMin = uicontrol('Parent',hTimingPanel,...
    'Unit','Normalized','BackgroundColor', backgroundColor,...
    'Position',[timingTextWidth 1-3*timingHeight...
    timingBoxWidth timingHeight],'Style','edit',...
    'String',num2str(stimPeriod(1)),'FontSize',fontSizeSmall);
hStimPeriodMax = uicontrol('Parent',hTimingPanel,...
    'Unit','Normalized','BackgroundColor', backgroundColor,...
    'Position',[timingTextWidth+timingBoxWidth 1-3*timingHeight...
    timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(stimPeriod(2)),...
    'FontSize',fontSizeSmall);

% Baseline Range
baseline = -0.05+[-diff(stimPeriod) 0];
uicontrol('Parent',hTimingPanel,'Unit','Normalized',...
    'Position',[0 1-2*timingHeight 0.5 timingHeight]...
    ,'Style','text','String','Baseline (s)',...
    'FontSize',fontSizeSmall);
hBaselineMin = uicontrol('Parent',hTimingPanel,...
    'Unit','Normalized','BackgroundColor', backgroundColor,...
    'Position',[timingTextWidth 1-2*timingHeight...
    timingBoxWidth timingHeight],'Style','edit',...
    'String',num2str(baseline(1)),'FontSize',fontSizeSmall);
hBaselineMax = uicontrol('Parent',hTimingPanel,...
    'Unit','Normalized','BackgroundColor', backgroundColor,...
    'Position',[timingTextWidth+timingBoxWidth 1-2*timingHeight...
    timingBoxWidth timingHeight], ...
    'Style','edit','String',num2str(baseline(2)),...
    'FontSize',fontSizeSmall);


hMTPanel = uipanel('Title','Multi-taper Panel','titleposition','centertop',...
    'fontSize',fontSizeLarge,'Unit','Normalized','Position',...
    [0.5 0.89 0.225 0.11]);

mtTextWidth = 0.5; mtBoxWidth = 0.2;
mtHeight = 1/3;


% Time Bandwidth and Tapers
uicontrol('Parent',hMTPanel,'Unit','Normalized', ...
    'Position',[0 1-mtHeight mtTextWidth mtHeight], ...
    'Style','text','String','MT Parameter','FontSize',fontSizeSmall);

uicontrol('Parent',hMTPanel,'Unit','Normalized', ...
    'Position',[mtTextWidth 1-mtHeight mtBoxWidth mtHeight], ...
    'Style','text','String','TW','FontSize',fontSizeSmall);

uicontrol('Parent',hMTPanel,'Unit','Normalized', ...
    'Position',[mtTextWidth+mtBoxWidth 1-mtHeight mtBoxWidth mtHeight], ...
    'Style','text','String','K','FontSize',fontSizeSmall);

taperParameters = [1 1];
uicontrol('Parent',hMTPanel,'Unit','Normalized', ...
    'Position',[0 1-2*mtHeight mtTextWidth mtHeight], ...
    'Style','text','String','tapers','FontSize',fontSizeSmall);
hTimeBandWidthProduct = uicontrol('Parent',hMTPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[mtTextWidth 1-2*mtHeight mtBoxWidth mtHeight], ...
    'Style','edit','String',num2str(taperParameters(1)),'FontSize',fontSizeSmall);
hTapers = uicontrol('Parent',hMTPanel,'Unit','Normalized', ...
    'BackgroundColor', backgroundColor, ...
    'Position',[mtTextWidth+mtBoxWidth 1-2*mtHeight mtBoxWidth mtHeight], ...
    'Style','edit','String',num2str(taperParameters(2)),'FontSize',fontSizeSmall);

hLoadDataPanel = uipanel('Title','Data Processing Panel',...
    'titleposition','centertop','fontSize',fontSizeLarge,...
    'Unit','Normalized','Position',...
    [0.725 0.89 0.225 0.11]);

hLFPResponsePanel = uibuttongroup('Parent',hLoadDataPanel,...
    'Unit','Normalized','Position',[0 0.5 1 0.5]);
uicontrol('parent',hLFPResponsePanel,'Style','radiobutton', ...
    'String','Evoked Response','Unit','Normalized',...
    'Position',[0.1 0 0.5 1],'FontSize',fontSizeSmall);

uicontrol('parent',hLFPResponsePanel,'Style','radiobutton',...
    'String','Induced Response','Unit','Normalized',...
    'Position',[0.5 0 0.5 1],'FontSize',fontSizeSmall);

uicontrol('Parent',hLoadDataPanel,'Unit','Normalized',...
    'Position',[0.25 0 0.5 0.5],'Style','pushbutton','String','Load DATA',...
    'FontSize',fontSizeMedium,'Callback',{@processData_Callback});


    function processData_Callback(~,~)
        
        try
            % We turn the interface off for processing.
            InterfaceObj_DataProcessing = findobj(hFigure,'Enable','on');
            set(InterfaceObj_DataProcessing,'Enable','off');
            
            % get Session Information
            sessionNum = get(hSession,'val');
            fileNameStringTMP = fileNameStringListArray{sessionNum};
            blRange = [str2double(get(hBaselineMin,'String'))...
                str2double(get(hBaselineMax,'String'))];
            stRange = [str2double(get(hStimPeriodMin,'String'))...
                str2double(get(hStimPeriodMax,'String'))];
            
            gridType = 'Microelectrode';
            oriSelectiveFlag = get(hOriTunedCheckbox,'val');
            LFPdataProcessingMethod = get(get(hLFPResponsePanel,'SelectedObject'),'String');
            
            % parameters for MT analysis
            TW = str2double(get(hTimeBandWidthProduct,'String'));
            K = str2double(get(hTapers,'String'));
            if K~=2*TW-1
                error('Set TW and K as K = 2TW-1')
            elseif K == 2*TW-1
                tapers_MT = [TW K];
            end
            
            % Electrode parameters
            elecParams.spikeCutoff = 15;
            elecParams.snrCutoff = 2;
            elecParams.dRange = [0 0.75];
            elecParams.getSpikeElectrodesFlag = 1;
            elecParams.unitID = 0;
            elecParams.oriSelectiveFlag = oriSelectiveFlag;
            
            timeRangeForComputation = stRange;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%% Find Good Electrodes %%%%%%%%%%%%%%%%%%%
            [ElectrodeStringListAll,ElectrodeArrayListAll,electrodeList]= getElectrodesList(fileNameStringTMP,elecParams,timeRangeForComputation,folderSourceString);
            
            % Show electrodes on Grid
            electrodeGridPos = [0.05 panelStartHeight 0.22 panelHeight];
            hElectrodesonGrid = showElectrodeLocations(electrodeGridPos,[], ...
                [],[],1,0,gridType,'alpaH');% Electrode grid Layout are similar for both alpaH and kesariH hybrid grid
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            freqRanges{1} = [8 12]; % alpha
            freqRanges{2} = [32 80]; % gamma
            freqRanges{3} = [104 248]; % hi-gamma
            freqRanges{4} = [16 16];  % SSVEP
            
            dataParameters.blRange = blRange;
            dataParameters.stRange = stRange;
            dataParameters.erpRange = [0.05 0.2];
            
            if strcmp(LFPdataProcessingMethod,'Evoked Response')
                removeERPFlag = 0;
            elseif strcmp(LFPdataProcessingMethod,'Induced Response')
                removeERPFlag = 1;
            end
            
            
            % get Data for Selected Session & Parameters
            [erpData,firingRateData,fftData,energyData,energyDataTF,oriTuningData,NI_Data,electrodeArray,~] = getData(folderSourceString,...
                fileNameStringTMP,electrodeList,dataParameters,tapers_MT,freqRanges,elecParams,removeERPFlag); %#ok<*ASGLU>
            %             freqRangeStr = {'alpha','gamma','SSVEP'};
            %             numFreqRanges = length(freqRanges);
            
            figure(1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters panel %%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            hParameterPanel = uipanel('Title','Parameters','titleposition','centertop','fontSize', ...
                fontSizeLarge,'Unit','Normalized','Position',...
                [0.275 panelStartHeight 0.225 panelHeight]);
            paramsHeight=1/6;
            
            % ElectrodeString
            uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
                'Position',[0 1-paramsHeight 0.5 paramsHeight],...
                'Style','text','String','Electrode','FontSize',fontSizeMedium);
            hElectrode = uicontrol('Parent',hParameterPanel,...
                'Unit','Normalized','BackgroundColor', backgroundColor, ...
                'Position',[0.5 1-paramsHeight 0.5 paramsHeight],...
                'Style','popup','String',ElectrodeStringListAll{1},...
                'FontSize',fontSizeMedium);
            
            % Analysis Method
            analysisMethodString ='FFT Amplitude|Multi-Taper Power';
            
            uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
                'Position',[0 1-2*paramsHeight 0.5 paramsHeight],...
                'Style','text','String','AnalysisMethod',...
                'FontSize',fontSizeMedium);
            hAnalysisMethod = uicontrol('Parent',hParameterPanel,...
                'Unit','Normalized','BackgroundColor', backgroundColor,...
                'Position',[0.5 1-2*paramsHeight 0.5 paramsHeight], ...
                'Style','popup','String',analysisMethodString,...
                'FontSize',fontSizeMedium);
            
            % Analysis Type
            analysisTypeString = ...
                ['ERP|Firing Rate|Raster|Alpha [8-12 Hz]|Gamma Power [30-80 Hz]| Hi-Gamma Power [104-250 Hz]|'...
                'SSVEP (16 Hz)|STA'];
            
            uicontrol('Parent',hParameterPanel,'Unit','Normalized', ...
                'Position',[0 1-3*paramsHeight 0.5 paramsHeight],...
                'Style','text','String','AnalysisMeasure',...
                'FontSize',fontSizeMedium);
            hAnalysisType = uicontrol('Parent',hParameterPanel,...
                'Unit','Normalized','BackgroundColor', backgroundColor,...
                'Position',[0.5 1-3*paramsHeight 0.5 paramsHeight], ...
                'Style','popup','String',analysisTypeString,...
                'FontSize',fontSizeMedium);
            
            hRelativeMeasures = uicontrol('Parent',hParameterPanel,...
                'Unit','Normalized', ...
                'Position',[0 1-5*paramsHeight 1 paramsHeight], ...
                'Style','togglebutton',...
                'String','Show Relative Measures (Stimulus - Baseline)',...
                'FontSize',fontSizeMedium);
            
            hNormalizeData = uicontrol('Parent',hParameterPanel,...
                'Unit','Normalized', ...
                'Position',[0 1-6*paramsHeight 1 paramsHeight], ...
                'Style','togglebutton',...
                'String','Normalize Data across sessions',...
                'FontSize',fontSizeMedium);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% Timing panel %%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            axesLimitsTextWidth = 0.5; axesLimitsBoxWidth = 0.25;
            hAxesLimitsPanel = uipanel('Title','X and Y Limits','titleposition','centertop',...
                'fontSize', fontSizeLarge,'Unit','Normalized',...
                'Position',[0.5 panelStartHeight 0.225 panelHeight]);
            axesLimitsHeight = 1/6;
            
            signalRange = [-0.1 0.5];
            %         erpPeriod = [0.05 0.2];
            fftRange = [0 100];
            
            % Signal Range
            uicontrol('Parent',hAxesLimitsPanel,'Unit','Normalized', ...
                'Position',[0 1-axesLimitsHeight axesLimitsTextWidth axesLimitsHeight],...
                'Style','text','String','Parameter','FontSize',fontSizeMedium);
            
            uicontrol('Parent',hAxesLimitsPanel,'Unit','Normalized', ...
                'Position',[axesLimitsTextWidth 1-axesLimitsHeight axesLimitsBoxWidth...
                axesLimitsHeight], 'Style','text','String','Min',...
                'FontSize',fontSizeMedium);
            
            uicontrol('Parent',hAxesLimitsPanel,'Unit','Normalized', ...
                'Position',[axesLimitsTextWidth+axesLimitsBoxWidth 1-axesLimitsHeight ...
                axesLimitsBoxWidth axesLimitsHeight], ...
                'Style','text','String','Max','FontSize',fontSizeMedium);
            
            % Stim Range
            uicontrol('Parent',hAxesLimitsPanel,'Unit','Normalized', ...
                'Position',[0 1-2*axesLimitsHeight axesLimitsTextWidth axesLimitsHeight]...
                ,'Style','text','String','Stim Range (s)',...
                'FontSize',fontSizeSmall);
            hStimMin = uicontrol('Parent',hAxesLimitsPanel,'Unit','Normalized', ...
                'BackgroundColor', backgroundColor, ...
                'Position',[axesLimitsTextWidth 1-2*axesLimitsHeight axesLimitsBoxWidth...
                axesLimitsHeight], ...
                'Style','edit','String',num2str(signalRange(1)),...
                'FontSize',fontSizeSmall);
            hStimMax = uicontrol('Parent',hAxesLimitsPanel,'Unit','Normalized',...
                'BackgroundColor', backgroundColor, ...
                'Position',[axesLimitsTextWidth+axesLimitsBoxWidth 1-2*axesLimitsHeight...
                axesLimitsBoxWidth axesLimitsHeight],'Style','edit',...
                'String',num2str(signalRange(2)),'FontSize',fontSizeSmall);
            
            
            % Frequency Range
            uicontrol('Parent',hAxesLimitsPanel,'Unit','Normalized',...
                'Position',...
                [0 1-3*axesLimitsHeight axesLimitsTextWidth axesLimitsHeight]...
                ,'Style','text','String','Frequency Range (Hz)',...
                'FontSize',fontSizeSmall);
            hFFTMin = uicontrol('Parent',hAxesLimitsPanel,...
                'Unit','Normalized', ...
                'BackgroundColor', backgroundColor, ...
                'Position',[axesLimitsTextWidth 1-3*axesLimitsHeight...
                axesLimitsBoxWidth axesLimitsHeight], ...
                'Style','edit','String',num2str(fftRange(1)),...
                'FontSize',fontSizeSmall);
            hFFTMax = uicontrol('Parent',hAxesLimitsPanel,...
                'Unit','Normalized',...
                'BackgroundColor', backgroundColor, ...
                'Position',...
                [axesLimitsTextWidth+axesLimitsBoxWidth 1-3*axesLimitsHeight...
                axesLimitsBoxWidth axesLimitsHeight],'Style','edit',...
                'String',num2str(fftRange(2)),'FontSize',fontSizeSmall);
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot Options %%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            hPlotOptionsPanel = uipanel('Title','Plotting Options',...
                'titleposition','centertop','fontSize', fontSizeLarge,...
                'Unit','Normalized',...
                'Position',[0.725 panelStartHeight 0.225 panelHeight]);
            plotOptionsHeight = 1/6;
            
            % Button for Plotting
            [colorString, colorNames] = getColorString;
            uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized',...
                'Position',...
                [0 5*plotOptionsHeight 0.6 plotOptionsHeight],...
                'Style','text','String','Color','FontSize',fontSizeSmall)
            hChooseColor = uicontrol('Parent',hPlotOptionsPanel,...
                'Unit','Normalized','BackgroundColor', backgroundColor,...
                'Position',...
                [0.6 5*plotOptionsHeight 0.4 plotOptionsHeight],...
                'Style','popup','String',colorString,...
                'FontSize',fontSizeSmall);
            
            uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized',...
                'Position',...
                [0 3*plotOptionsHeight 0.5 plotOptionsHeight],...
                'Style','pushbutton','String','clear Plot',...
                'FontSize',fontSizeMedium,'Callback',{@cla_Callback});
            
            uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized',...
                'Position',...
                [0.5 3*plotOptionsHeight 0.5 plotOptionsHeight],...
                'Style','pushbutton','String','Select New Session',...
                'BackgroundColor','w','ForegroundColor','r','FontSize',...
                fontSizeMedium,'Callback',{@ChooseNewSession_Callback});
            
            hHoldOn = uicontrol('Parent',hPlotOptionsPanel,...
                'Unit','Normalized','Position',[0 2*plotOptionsHeight ...
                1 plotOptionsHeight],'Style','togglebutton',...
                'String','hold on','FontSize',fontSizeMedium, ...
                'Callback',{@holdOn_Callback});
            
            uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized', ...
                'Position',[0 plotOptionsHeight 1 plotOptionsHeight], ...
                'Style','pushbutton','String','Rescale',...
                'FontSize',fontSizeMedium,'Callback',{@rescaleXY_Callback})
            
            uicontrol('Parent',hPlotOptionsPanel,'Unit','Normalized',...
                'Position',[0 0 1 plotOptionsHeight],...
                'Style','pushbutton','String','plot',...
                'FontSize',fontSizeMedium,'Callback',{@plotData_Callback})
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Plots
            % Main Plot showing Neural mesaures in a 5 x 5 contrast conditions
            staticStartPos = 0.05;
            startXPos = staticStartPos; startYPos = 0.05; mainTabHeight = 0.55;
            mainTabWidth = 0.4;
            
            cValsUnique = [0 12.5 25 50 100]./2;
            cValsUnique2 = [0 12.5 25 50 100]./2;
            numRows = length(cValsUnique); numCols = length(cValsUnique2);
            gridPos=[0.02+startXPos startYPos mainTabWidth mainTabHeight];
            gap = 0.002;
            
            figure(1);
            plotHandles = getPlotHandles(numRows,numCols,gridPos,gap); linkaxes(plotHandles);
            
            % Orientation Tuning for electrodes of single session
            hOriTuning = ...
                getPlotHandles(1,1,[0.52 0.38 0.14 0.22],0.05,0.05,1);
            
            % Color Matrix of Neural measures in a 5x5 contrast conditions
            hNeuralMeasureColorMatrix = ...
                getPlotHandles(1,1,[0.52 0.05 0.14 0.25],0.001,0.001,1);
            
            % CRF plots for preferred Orientation (Row-wise)
            plotHandles2= getPlotHandles(1,5,[0.7 0.5 0.25 0.1],0.001,0.001,1); linkaxes(plotHandles2);
            
            % CRF plots for null Orientation (column-wise)
            plotHandles3= getPlotHandles(1,5,[0.7 0.35 0.25 0.1],0.001,0.001,1); linkaxes(plotHandles3);
            
            % CRF plots for preferred Orientation (Overlaid)
            hRowCRF = getPlotHandles(1,1,[0.85 0.2 0.1 0.1],0.001,0.001,1);
            
            % CRF plots for null Orientation (Overlaid)
            hColumnCRF = getPlotHandles(1,1,[0.85 0.05 0.1 0.1],0.001,0.001,1);
            
            % Population histogram of Normalization Index
            hNormIndex = getPlotHandles(1,1,[0.7 0.05 0.12 0.25],0.001,0.001,1);
            
            % Defining text in new axes for Orientation Type (pref/null) [0/90; 22.5/112.5; 45/135; 67.5/157.5]
            textH1 = getPlotHandles(1,1,[0.2 0.65 0.01 0.01]); set(textH1,'Visible','Off');
            textH2 = getPlotHandles(1,1,[0.02 0.25 0.01 0.01]); set(textH2,'Visible','Off');
            
            % plots for 2nd annual Work Presentation (3rd Year)
            hFigure2 = figure(2); hFigure3 = figure(3);
            set(hFigure2,'units','normalized','outerposition',[0 0 1 1])
            set(hFigure3,'units','normalized','outerposition',[0 0 1 1])
            figure(2);
            hPlotPreferred = getPlotHandles(1,5,[0.1 0.7 0.5 0.15],0.01,0.01,1); linkaxes(hPlotPreferred);
            hOtherMeaures = getPlotHandles(1,3,[0.1 0.3 0.5 0.25],0.05,0.05,0);
            
            % Defining Text  in new axes for Figure 2
            textH3 = getPlotHandles(1,1,[0.2 0.9 0.01 0.01]); set(textH3,'Visible','Off');
            
            % more plots for AWP
            figure(3);
            hEnergyPlots = getPlotHandles(1,2,[0.1 0.55 0.5 0.35],0.03,0.05,0); linkaxes(hEnergyPlots);
            hOtherPanels = getPlotHandles(1,3,[0.1 0.15 0.5 0.25],0.05,0.05,0);
            
        catch ErrorInDataProcessing
            % We turn back on the interface
            set(InterfaceObj_DataProcessing,'Enable','on');
            rethrow(ErrorInDataProcessing)
        end
        
        % Plotting Functions
        function plotData_Callback(~,~)
            
            try
                % We turn the interface off for processing.
                InterfaceObj_DataPlotting = findobj(hFigure,'Enable','on');
                set(InterfaceObj_DataPlotting,'Enable','off');
                
                %%%%%%%%%%%%%%%%%%%%%%%% Read values %%%%%%%%%%%%%%%%%%%%%%%%%%
                electrodeString = get(hElectrode,'val');
                if length(ElectrodeArrayListAll)==1
                    if electrodeString == length(ElectrodeArrayListAll{1})+1
                        disp('performing analysis on all electrodes for the selected single session')
                        electrodeNum = 'all';
                        
                    elseif length(ElectrodeArrayListAll{1}{electrodeString})==1
                        electrodeNum = electrodeString;
                        disp('performing analysis on the selected single electrode');
                        
                    elseif isempty(ElectrodeArrayListAll{1}{electrodeString})
                        error('No electrode found for analysis! Pease try another session!')
                    end
                else
                    disp('performing analysis on all electrodes across sessions');
                    electrodeNum = 'all';
                end
                
                
                analysisMethod = get(hAnalysisMethod,'val');
                analysisMeasure = get(hAnalysisType,'val');
                NormalizeDataFlag = get(hNormalizeData,'val');
                relativeMeasuresFlag = get(hRelativeMeasures,'val');
                
                plotColor = colorNames(get(hChooseColor,'val'));
                holdOnState = get(hHoldOn,'val');
                
                %             ColorNeuralMeasures = jet(5);
                
                hPlots_Fig1.hPlot1 = plotHandles;
                hPlots_Fig1.hPlot2 = hNeuralMeasureColorMatrix;
                hPlots_Fig1.hPlot3 = plotHandles2;
                hPlots_Fig1.hPlot4 = plotHandles3;
                hPlots_Fig1.hPlot5 = hRowCRF;
                hPlots_Fig1.hPlot6 = hColumnCRF;
                hPlots_Fig1.hPlot7 = hNormIndex;
                hPlots_Fig1.hPlot8 = hOriTuning;
                
                hPlots_Fig2.hPlot1 = hPlotPreferred;
                hPlots_Fig2.hPlot2 = hOtherMeaures;
                
                hPlots_Fig3.hPlot1 = hEnergyPlots;
                hPlots_Fig3.hPlot2 = hOtherPanels;
                
                
                if analysisMeasure == 1 % computing ERP
                    plotData(hPlots_Fig1,hPlots_Fig2,hPlots_Fig3,sessionNum,erpData.timeVals,erpData,oriTuningData,plotColor,analysisMethod,analysisMeasure,LFPdataProcessingMethod,relativeMeasuresFlag,NormalizeDataFlag,electrodeNum)
                elseif analysisMeasure == 2 % computing Firing rate
                    plotData(hPlots_Fig1,hPlots_Fig2,hPlots_Fig3,sessionNum,firingRateData.timeVals,firingRateData,oriTuningData,plotColor,analysisMethod,analysisMeasure,LFPdataProcessingMethod,relativeMeasuresFlag,NormalizeDataFlag,electrodeNum)
                elseif analysisMeasure == 3 % computing Raster Plot from spike data
                    error('Still working on raster data!')
                elseif analysisMeasure == 4 || analysisMeasure == 5 || analysisMeasure == 6|| analysisMeasure == 7% computing alpha
                    if analysisMethod == 1
                        plotData(hPlots_Fig1,hPlots_Fig2,hPlots_Fig3,sessionNum,fftData.freqVals,fftData,oriTuningData,plotColor,analysisMethod,analysisMeasure,LFPdataProcessingMethod,relativeMeasuresFlag,NormalizeDataFlag,electrodeNum)
                    elseif analysisMethod ==2
                        plotData(hPlots_Fig1,hPlots_Fig2,hPlots_Fig3,sessionNum,energyData.freqVals,energyData,oriTuningData,plotColor,analysisMethod,analysisMeasure,LFPdataProcessingMethod,relativeMeasuresFlag,NormalizeDataFlag,electrodeNum)
                    end
                elseif analysisMeasure == 8 % need to work on STA!
                    error('STA computation method not found')
                end
                
                showElectrodeLocations(electrodeGridPos,electrodeArray, ...
                    plotColor,hElectrodesonGrid,holdOnState,0,gridType,'alpaH');% Electrode grid Layout are similar for both alpaH and kesariH hybrid grid
                
                figure(1);
                % Text for Orientation for main 5x5 Neural measure matrix
                textH1 = getPlotHandles(1,1,[0.2 0.65 0.01 0.01]);
                set(textH1,'Visible','Off');
                textH2 = getPlotHandles(1,1,[0.02 0.25 0.01 0.01]);
                set(textH2,'Visible','Off');
                
                %             if length(fileNameStringTMP) ==1 && length(ElectrodeListTMP{1})==1
                %                 text(0.35,1.15,['Null Orientation: ' num2str(oValsUnique)],'unit','normalized','fontsize',20,'fontweight','bold','rotation',90,'parent',textH2);
                %                 text(0.35,1.15,['Preferred Orientation: ' num2str(oValsUnique2)],'unit','normalized','fontsize',20,'fontweight','bold','parent',textH1);
                %             else
                %                 text(0.35,1.15,'Null Orientation','unit','normalized','fontsize',20,'fontweight','bold','rotation',90,'parent',textH2);
                %                 text(0.35,1.15,'Preferred Orientation' ,'unit','normalized','fontsize',20,'fontweight','bold','parent',textH1);
                %             end
                
                % Setting Plot Ranges
                if analysisMeasure<=3 %ERP or spikes
                    xMin = str2double(get(hStimMin,'String'));
                    xMax = str2double(get(hStimMax,'String'));
                elseif analysisMeasure <=7  % LFP fft analysis
                    xMin = str2double(get(hFFTMin,'String'));
                    xMax = str2double(get(hFFTMax,'String'));
                else
                    xMin = str2double(get(hSTAMin,'String'));
                    xMax = str2double(get(hSTAMax,'String'));
                end
                
                figure(2)
                % Text for Orientation for main 5x5 Neural measure matrix
                text(0.35,1.15,'Contrast along Orientation 1','unit','normalized','fontsize',20,'fontweight','bold','parent',textH3);
                
                rescaleData(plotHandles,xMin,xMax,getYLims(plotHandles));
                rescaleData(plotHandles2,0,50,getYLims(plotHandles2));
                rescaleData(plotHandles3,0,50,getYLims(plotHandles3));
                rescaleData(hRowCRF,0,50,getYLims(hRowCRF));
                rescaleData(hColumnCRF,0,50,getYLims(hColumnCRF));
                rescaleData(hPlotPreferred,xMin,xMax,getYLims(hPlotPreferred));
                rescaleData(hOtherMeaures(1),0,50,getYLims(hOtherMeaures(1)));
                rescaleData(hEnergyPlots,xMin,xMax,getYLims(hEnergyPlots));
                rescaleData(hOtherPanels(1),0,50,getYLims(hOtherPanels(1)));
                
                % We turn back on the Plotting interface
                set(InterfaceObj_DataPlotting,'Enable','on');
                
            catch ErrorinDataPlotting
                % We turn back on the entire interface (plotting and data
                % processing)
                %                 fprintf(1,'The identifier was:\n%s',e.identifier);
                %                 fprintf(1,'There was an error! The message was:\n%s',e.message);
                set(InterfaceObj_DataPlotting,'Enable','on');
                rethrow(ErrorinDataPlotting)
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function rescaleXY_Callback(~,~)
            
            analysisType = get(hAnalysisType,'val');
            
            if analysisType<=3 % ERP or spikes
                xMin = str2double(get(hStimMin,'String'));
                xMax = str2double(get(hStimMax,'String'));
            elseif analysisType==8
                xMin = str2double(get(hSTAMin,'String'));
                xMax = str2double(get(hSTAMax,'String'));
            else
                xMin = str2double(get(hFFTMin,'String'));
                xMax = str2double(get(hFFTMax,'String'));
            end
            
            rescaleData(plotHandles,xMin,xMax,getYLims(plotHandles));
            rescaleData(hPlotPreferred,xMin,xMax,getYLims(hPlotPreferred));
            rescaleData(hEnergyPlots,xMin,xMax,getYLims(hEnergyPlots));
            
            %         rescaleData(plotHandles2,0,50,getYLims(plotHandles2));
            %         rescaleData(plotHandles3,0,50,getYLims(plotHandles3));
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function holdOn_Callback(source,~)
            holdOnState = get(source,'Value');
            
            holdOnGivenPlotHandle(plotHandles,holdOnState);
            holdOnGivenPlotHandle(plotHandles2,holdOnState);
            holdOnGivenPlotHandle(plotHandles3,holdOnState);
            
            if holdOnState
                set(hElectrodes,'Nextplot','add');
            else
                set(hElectrodes,'Nextplot','replace');
            end
            
            function holdOnGivenPlotHandle(plotHandles,holdOnState)
                
                [numRows,numCols] = size(plotHandles);
                if holdOnState
                    for i=1:numRows
                        for j=1:numCols
                            set(plotHandles(i,j),'Nextplot','add');
                            
                        end
                    end
                else
                    for i=1:numRows
                        for j=1:numCols
                            set(plotHandles(i,j),'Nextplot','replace');
                        end
                    end
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function cla_Callback(~,~)
            
            claGivenPlotHandle(plotHandles);
            claGivenPlotHandle(plotHandles2);
            claGivenPlotHandle(plotHandles3);
            claGivenPlotHandle(hRowCRF);
            claGivenPlotHandle(hColumnCRF);
            claGivenPlotHandle(hNeuralMeasureColorMatrix);
            claGivenPlotHandle(hOriTuning);
            claGivenPlotHandle(hNormIndex);
            
            delete(findobj(textH1,'type','text'));
            delete(findobj(textH2,'type','text'));
            delete(findobj(textH3,'type','text'));
            
            
            claGivenPlotHandle(hPlotPreferred);
            claGivenPlotHandle(hOtherMeaures);
            
            claGivenPlotHandle(hEnergyPlots);
            claGivenPlotHandle(hOtherPanels);
            
            claGivenPlotHandle(hElectrodesonGrid)
            showElectrodeLocations(electrodeGridPos,[], ...
                [],[],1,0,gridType,'alpaH');% Electrode grid Layout are similar for both alpaH and kesariH hybrid grid
            
            function claGivenPlotHandle(plotHandles)
                [numRows,numCols] = size(plotHandles);
                for i=1:numRows
                    for j=1:numCols
                        cla(plotHandles(i,j));
                    end
                end
            end
        end
        
        function ChooseNewSession_Callback(~,~)
            % We turn back on the interface
            set(InterfaceObj_DataProcessing,'Enable','on');
            delete(findobj(hElectrodesonGrid));
            delete(findobj(hParameterPanel));
            delete(findobj(hAxesLimitsPanel));
            delete(findobj(hPlotOptionsPanel));
            delete(findobj(plotHandles));
            delete(findobj(plotHandles2));
            delete(findobj(plotHandles3));
            delete(findobj(hOriTuning));
            delete(findobj(hNeuralMeasureColorMatrix));
            delete(findobj(hRowCRF));
            delete(findobj(hColumnCRF));
            delete(findobj(hNormIndex));
            close(hFigure2)
            close(hFigure3)
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotData(hPlots_Fig1,hPlots_Fig2,hPlots_Fig3,sessionNum,xs,data,oriTuningData,colorName,analysisMethod,analysisMeasure,LFPdataProcessingMethod,relativeMeasuresFlag,NormalizeDataFlag,electrodeNum)

if strcmp(strtok(LFPdataProcessingMethod),'Induced') && analysisMeasure == 7
    error('SSVEP is a time locked Signal. Subtracting ERP from each trials will wipe out the SSVEP signal at 2nd Harmonic. Please use evoked SSVEP response')
end

cValsUnique = [0 12.5 25 50 100]./2;
cValsUnique2 = [0 12.5 25 50 100]./2;

if isnumeric(electrodeNum)
    data = getDataSingleElec(data,electrodeNum,analysisMeasure);
elseif strcmp(electrodeNum,'all')
%     mData = getMeanDataAcrossElectrodes(data,analysisMeasure);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%    Processing data accoring to selected neural measure    %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Main 5x5 plot for Neural Measure
if analysisMeasure == 1 || analysisMeasure == 2
    if NormalizeDataFlag
        % Normalize ERP and spike Data
        %(fft or energy data need not be normalized because of log conversion
        data = normalizeData(data);
    end
    dataPlot = squeeze(mean(data.data(:,1,:,:,:),1)); % Handles single electrode or multi-electrode data similarly
    
elseif analysisMeasure == 4 || analysisMeasure == 5 || analysisMeasure == 6 || analysisMeasure == 7
    if size(data.dataBL) ~= size(data.dataST)
        error('Size of fftDataBL and fftDataST do not match!')
    end
    
    % Absolute BL & ST neural measure
    dataPlotBL = squeeze(mean(data.data_cBL(:,1,:,:,:),1));
    dataPlotST = squeeze(mean(data.dataST(:,1,:,:,:),1));
    if analysisMeasure == 7
        dataPlotBL = squeeze(mean(data.data_cBL(:,2,:,:,:),1));
        dataPlotST = squeeze(mean(data.dataST(:,2,:,:,:),1));
    end
    
    % When Change in neural measures are to be plotted
    if relativeMeasuresFlag
        dataPlotdiffSTvsBL = dataPlotST-dataPlotBL;
        if analysisMeasure == 4 || analysisMeasure == 5 || analysisMeasure == 6 || analysisMeasure == 7
            if analysisMethod == 2
                dataPlotdiffSTvsBL = 10*(dataPlotST-dataPlotBL);  % Change in Power expressed in deciBel for MT method
            end
        end
    end
end

% Color coded 5x5 Matrix of raw Neural Measures
if analysisMeasure == 1 || analysisMeasure == 2
    analysisData = squeeze(mean(data.analysisDataST(:,1,:,:),1));
    sem_analysisData = squeeze(std(squeeze(data.analysisDataST(:,1,:,:)),[],1)./sqrt(size(data.analysisDataST,1)));
    analysisDataBL = squeeze(mean(data.analysisData_cBL(:,1,:,:),1));
    for iElec= 1:size(data.analysisDataST,1)
        clear electrodeVals
        if ~relativeMeasuresFlag
            electrodeVals =  squeeze(data.analysisDataST(iElec,1,:,:));
        else
            electrodeVals =  squeeze(data.analysisDataST(iElec,1,:,:))-squeeze(data.analysisData_cBL(iElec,1,:,:));
        end
        NI_population(iElec) = electrodeVals(1,5)/(((electrodeVals(1,1)+electrodeVals(5,5)))/2)-1;
    end
    
    %     OutlierVals = [-15 15];
    %     NI_population_outlier = find(NI_population<OutlierVals(1) | NI_population>OutlierVals(2));
    %     NI_population_outlierVals = NI_population(NI_population_outlier);
    %     NI_population = NI_population(setdiff(1:length(NI_population),NI_population_outlier));
    %     fprintf(['Deleting Electrode number: ',num2str(NI_population_outlier) ' \nfor NI calculation because NI value(s) '...
    %         num2str(NI_population_outlierVals) '\nfalls outside range ' num2str(OutlierVals(1)) ' < NI values < ' num2str(OutlierVals(2)) '\n'] )
    %
elseif analysisMeasure == 4
    analysisData = squeeze(mean(data.analysisDataST{1},1));
    sem_analysisData = squeeze(std(squeeze(data.analysisDataST{1}),[],1)./sqrt(size(data.analysisDataST{1},1)));
    analysisDataBL = squeeze(mean(data.analysisData_cBL{1},1));
    for iElec= 1:size(data.analysisDataST{1},1)
        clear electrodeVals
        if ~relativeMeasuresFlag
            electrodeVals =  squeeze(data.analysisDataST{1}(iElec,:,:));
        else
            electrodeVals =  squeeze(data.analysisDataST{1}(iElec,:,:))-squeeze(data.analysisData_cBL{1}(iElec,:,:));
        end
        NI_population(iElec) = electrodeVals(1,5)/(((electrodeVals(1,1)+electrodeVals(5,5)))/2)-1;
    end
elseif analysisMeasure == 5
    analysisData = squeeze(mean(data.analysisDataST{2},1));
    sem_analysisData = squeeze(std(squeeze(data.analysisDataST{2}),[],1)./sqrt(size(data.analysisDataST{2},1)));
    analysisDataBL = squeeze(mean(data.analysisData_cBL{2},1));
    for iElec= 1:size(data.analysisDataST{2},1)
        clear electrodeVals
        if ~relativeMeasuresFlag
            electrodeVals =  squeeze(data.analysisDataST{2}(iElec,:,:));
        else
            electrodeVals =  squeeze(data.analysisDataST{2}(iElec,:,:))-squeeze(data.analysisData_cBL{2}(iElec,:,:));
        end
        NI_population(iElec) = electrodeVals(1,5)/(((electrodeVals(1,1)+electrodeVals(5,5)))/2)-1;
    end
elseif analysisMeasure == 6
    analysisData = squeeze(mean(data.analysisDataST{3},1));
    sem_analysisData = squeeze(std(squeeze(data.analysisDataST{3}),[],1)./sqrt(size(data.analysisDataST{3},1)));
    analysisDataBL = squeeze(mean(data.analysisData_cBL{3},1));
    for iElec= 1:size(data.analysisDataST{3},1)
        clear electrodeVals
        if ~relativeMeasuresFlag
            electrodeVals =  squeeze(data.analysisDataST{3}(iElec,:,:));
            NI_population(iElec) = abs(electrodeVals(1,5)/(((electrodeVals(1,1)+electrodeVals(5,5)))/2)-1); % log of low power values are negative!
        else
            electrodeVals =  squeeze(data.analysisDataST{3}(iElec,:,:))-squeeze(data.analysisData_cBL{3}(iElec,:,:));
            NI_population(iElec) = electrodeVals(1,5)/(((electrodeVals(1,1)+electrodeVals(5,5)))/2)-1;
        end
    end
elseif analysisMeasure == 7
    analysisData = squeeze(mean(data.analysisDataST{4},1));
    sem_analysisData = squeeze(std(squeeze(data.analysisDataST{4}),[],1)./sqrt(size(data.analysisDataST{4},1)));
    analysisDataBL = squeeze(mean(data.analysisData_cBL{4},1));
    for iElec= 1:size(data.analysisDataST{4},1)
        clear electrodeVals
        if ~relativeMeasuresFlag
            electrodeVals =  squeeze(data.analysisDataST{4}(iElec,:,:));
        else
            electrodeVals =  squeeze(data.analysisDataST{4}(iElec,:,:))-squeeze(data.analysisData_cBL{4}(iElec,:,:));
        end
        NI_population(iElec) = electrodeVals(1,5)/(((electrodeVals(1,1)+electrodeVals(5,5)))/2)-1;
    end
end

if relativeMeasuresFlag
    if analysisMeasure == 1||analysisMeasure == 2
        analysisData = analysisData-analysisDataBL;
        sem_analysisData =  squeeze(std((data.analysisDataST-data.analysisData_cBL),[],1)./sqrt(size(data.analysisDataST,1)));
    elseif analysisMeasure == 4||analysisMeasure == 5||analysisMeasure == 6||analysisMeasure == 7
        if analysisMethod == 2
            analysisData = 10*(analysisData-analysisDataBL);% Change in power expressed in deciBel
        else
            analysisData = (analysisData-analysisDataBL);
        end
        
        if analysisMeasure == 4
            sem_analysisData =  squeeze(std((data.analysisDataST{1}-data.analysisDataBL{1}),[],1)./sqrt(size(data.analysisDataST{1},1)));
        elseif analysisMeasure == 5
            sem_analysisData = squeeze(std((data.analysisDataST{2}-data.analysisDataBL{2}),[],1)./sqrt(size(data.analysisDataST{2},1)));
        elseif analysisMeasure == 6
            sem_analysisData = squeeze(std((data.analysisDataST{3}-data.analysisDataBL{3}),[],1)./sqrt(size(data.analysisDataST{3},1)));
        elseif analysisMeasure == 7
            sem_analysisData = squeeze(std((data.analysisDataST{4}-data.analysisDataBL{4}),[],1)./sqrt(size(data.analysisDataST{4},1)));
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 1   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ori Tuning data shown only for single session (single or all electrodes)
if analysisMeasure == 1||analysisMeasure == 2
    num_Electrodes = size(data.data,1);
else
    num_Electrodes = size(data.dataST,1);
end
colorNamesOriTuning = hsv(num_Electrodes);
oValsUnique_Tuning = [0 22.5 45 67.5 90 112.5 135 157.5];

if sessionNum <=22 % Single Session
    if num_Electrodes == 1
        plot(hPlots_Fig1.hPlot8,oValsUnique_Tuning,oriTuningData.data{1}(electrodeNum,:),'Marker','o','color',colorNamesOriTuning);
        text(0.7,0.5,['PO: ' num2str(oriTuningData.PO{1}(electrodeNum)) ',OS: ' num2str(round(oriTuningData.OS{1}(electrodeNum),2))],'color',colorNamesOriTuning,'unit','normalized','fontSize',6,'parent',hPlots_Fig1.hPlot8);
    else
        for iElec = 1:num_Electrodes
            plot(hPlots_Fig1.hPlot8,oValsUnique_Tuning,oriTuningData.data{1}(iElec,:),'Marker','o','color',colorNamesOriTuning(iElec,:,:));
            text(0.7,iElec*0.05+0.1,['PO: ' num2str(oriTuningData.PO{1}(iElec)) ',OS: ' num2str(round(oriTuningData.OS{1}(iElec),2))],'color',colorNamesOriTuning(iElec,:,:),'unit','normalized','fontSize',6,'parent',hPlots_Fig1.hPlot8);
            hold(hPlots_Fig1.hPlot8,'on');
        end
        hold(hPlots_Fig1.hPlot8,'off');
    end
else
    text(0.5,0.5,{'Orientation Tuning data' 'not shown for' 'multiple sessions'},'unit','normalized','HorizontalAlignment','center','fontSize',10,'parent',hPlots_Fig1.hPlot8);
end
title(hPlots_Fig1.hPlot8,'Ori Tuning for Single Session (Spike Data)','fontSize',10);
xlim(hPlots_Fig1.hPlot8,[0 250]);
set(hPlots_Fig1.hPlot8,'XTick',oValsUnique_Tuning); set(hPlots_Fig1.hPlot8,'XTickLabelRotation',90);

% Plotting 5x5 plots for raw Neural Measures
conFlipped = 5:-1:1;
for c1 = 1:5
    for c2 = 1:5
        if analysisMeasure == 1 || analysisMeasure == 2
            plot(hPlots_Fig1.hPlot1(c1,c2),xs,squeeze(dataPlot(c1,c2,:)),'color',colorName);
        elseif analysisMeasure == 4 || analysisMeasure == 5||analysisMeasure == 6||analysisMeasure == 7
            if ~relativeMeasuresFlag
                plot(hPlots_Fig1.hPlot1(c1,c2),xs,squeeze(dataPlotBL(c1,c2,:)),'g');
                hold(hPlots_Fig1.hPlot1(c1,c2),'on')
                plot(hPlots_Fig1.hPlot1(c1,c2),xs,squeeze(dataPlotST(c1,c2,:)),'k');
                hold(hPlots_Fig1.hPlot1(c1,c2),'off')
            else
                plot(hPlots_Fig1.hPlot1(c1,c2),xs,squeeze(dataPlotdiffSTvsBL(c1,c2,:)),'b');
            end
        end
    end
end

for c = 1:5
    title(hPlots_Fig1.hPlot1(1,c),[num2str(cValsUnique(c)) ' %']);
    ylabel(hPlots_Fig1.hPlot1(c,1),[num2str(cValsUnique(conFlipped(c))) ' %'],'fontWeight','bold');
end

% Plotting of analysisData as 5x5 color matrix
imagesc(analysisData,'parent',hPlots_Fig1.hPlot2);colorbar(hPlots_Fig1.hPlot2);set(hPlots_Fig1.hPlot2,'Position',[0.52 0.05 0.12 0.25]);
title(hPlots_Fig1.hPlot2,['Mean NI: ',num2str(round(mean(NI_population),2))],'fontWeight','bold');
set(hPlots_Fig1.hPlot2,'XTickLabel',cValsUnique);
set(hPlots_Fig1.hPlot2,'YTickLabel',flip(cValsUnique2));

% NI population histogram
if num_Electrodes>1
    histogram(hPlots_Fig1.hPlot7,NI_population,-2:0.2:2);
end

% Contrast Response curves Row-Wise & Column-wise
CRFColors = jet(length(cValsUnique));
for iCon = 1:5
    plot(hPlots_Fig1.hPlot3(1,iCon),cValsUnique,analysisData(conFlipped(iCon),:),...
        'Marker','o','LineWidth',2,'color',CRFColors(iCon,:,:))
    plot(hPlots_Fig1.hPlot4(1,iCon),cValsUnique2,flip(analysisData(:,iCon),1),...
        'Marker','o','LineWidth',2,'color',CRFColors(iCon,:,:))
    plot(hPlots_Fig1.hPlot5(1,1),cValsUnique,analysisData(conFlipped(iCon),:),...
        'Marker','o','LineWidth',2,'color',CRFColors(iCon,:,:))
    hold(hPlots_Fig1.hPlot5(1,1),'on')
    plot(hPlots_Fig1.hPlot6(1,1),cValsUnique2,flip(analysisData(:,iCon),1),...
        'Marker','o','LineWidth',2,'color',CRFColors(iCon,:,:))
    hold(hPlots_Fig1.hPlot6(1,1),'on')
end
hold(hPlots_Fig1.hPlot5(1,1),'off'); hold(hPlots_Fig1.hPlot6(1,1),'off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 2   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colors = jet(5);
% Plot Figure 2 neural response plots
for c1 = 1:5
    for c2 = 1:5
        if analysisMeasure == 1 || analysisMeasure == 2
            plot(hPlots_Fig2.hPlot1(1,c2),xs,squeeze(dataPlot(conFlipped(c1),c2,:)),'color',colors(c1,:,:),'LineWidth',2);
            hold(hPlots_Fig2.hPlot1(1,c2),'on');
        elseif analysisMeasure == 4 || analysisMeasure == 5||analysisMeasure == 6||analysisMeasure == 7
            if ~relativeMeasuresFlag
                plot(hPlots_Fig2.hPlot1(1,c2),xs,squeeze(dataPlotBL(conFlipped(c1),c2,:)),'k');
                hold(hPlots_Fig2.hPlot1(1,c2),'on')
                plot(hPlots_Fig2.hPlot1(1,c2),xs,squeeze(dataPlotST(conFlipped(c1),c2,:)),'color',colors(c1,:,:),'LineWidth',2);
            else
                plot(hPlots_Fig2.hPlot1(1,c2),xs,squeeze(dataPlotBL(conFlipped(c1),c2,:))-squeeze(dataPlotBL(conFlipped(c1),c2,:)),'k');
                hold(hPlots_Fig2.hPlot1(1,c2),'on')
                plot(hPlots_Fig2.hPlot1(1,c2),xs,squeeze(dataPlotdiffSTvsBL(conFlipped(c1),c2,:)),'color',colors(c1,:,:),'LineWidth',2);
            end
        end
        title(hPlots_Fig2.hPlot1(1,c2),[num2str(cValsUnique(c2)) ' %'])
    end
end

% Figure 2 5x5 color-coded analysisData matrix
imagesc(analysisData,'parent',hPlots_Fig2.hPlot2(3));
color_Bar = colorbar(hPlots_Fig2.hPlot2(3));
colorYlabelHandle = get(color_Bar,'Ylabel');
if analysisMeasure==1
    YlabelString = 'Potential';
elseif analysisMeasure==2
    YlabelString = 'Spikes/s';
elseif analysisMeasure == 4||analysisMeasure == 5||analysisMeasure == 6||analysisMeasure == 7
    if ~relativeMeasuresFlag
        YlabelString = 'log_1_0(FFT Amplitude)';
    else
        YlabelString = 'log_1_0(\Delta FFT Amplitude)';
        if analysisMethod == 2
            YlabelString = 'Change in Power (dB)';
        end
    end
end

set(colorYlabelHandle,'String',YlabelString,'fontSize',14);
plotPos = get(hPlots_Fig2.hPlot2(3),'Position');
set(hPlots_Fig2.hPlot2(3),'Position',[plotPos(1) plotPos(2) 0.12 plotPos(4)]);
title(hPlots_Fig2.hPlot2(3),['Mean NI: ',num2str(round(mean(NI_population),2))],'fontWeight','bold');

if num_Electrodes>1
    % NI population histogram
    histogram(hPlots_Fig2.hPlot2(2),NI_population,-2:0.2:2);
end
tickLengthPlot = 2*get(hPlots_Fig2.hPlot2(1),'TickLength');
set(hPlots_Fig2.hPlot2(2),'fontSize',14,'TickDir','out','Ticklength',tickLengthPlot,'box','off')
xlabel(hPlots_Fig2.hPlot2(2),'Normalization Index'); ylabel(hPlots_Fig2.hPlot2(2),'No. of Electrodes');
title(hPlots_Fig2.hPlot2(2),'Population NI Histogram')

set(hPlots_Fig2.hPlot2(3),'fontSize',14,'TickDir','out','Ticklength',tickLengthPlot,'box','off')
set(hPlots_Fig2.hPlot2(3),'XTick',1:5,'XTickLabelRotation',90,'XTickLabel',cValsUnique,'YTickLabel',flip(cValsUnique));
xlabel(hPlots_Fig2.hPlot2(3),'Contrast (%)');ylabel(hPlots_Fig2.hPlot2(3),'Contrast (%)');

% Figure 2 CRF plot
CRFColors = jet(length(cValsUnique));
for iCon = 1:5
    plot(hPlots_Fig2.hPlot2(1),cValsUnique,analysisData(conFlipped(iCon),:),...
        'Marker','o','LineWidth',2,'color',CRFColors(iCon,:,:))
    hold(hPlots_Fig2.hPlot2(1),'on')
end
hold(hPlots_Fig2.hPlot2(1),'off');

if analysisMeasure == 1||analysisMeasure == 2
    displayRange(hPlots_Fig2.hPlot1,[0.2 0.4],getYLims(hPlots_Fig2.hPlot1),'k');
elseif analysisMeasure ==4
    displayRange(hPlots_Fig2.hPlot1,[8 12],getYLims(hPlots_Fig2.hPlot1),'k');
elseif analysisMeasure == 5
    displayRange(hPlots_Fig2.hPlot1,[30 80],getYLims(hPlots_Fig2.hPlot1),'k');
elseif analysisMeasure == 6
    displayRange(hPlots_Fig2.hPlot1,[16 16],getYLims(hPlots_Fig2.hPlot1),'k');
end

tickLengthPlot = 2*get(hPlots_Fig2.hPlot2(1),'TickLength');

for idx =1:5
    set(hPlots_Fig2.hPlot1(idx),'fontSize',14,'TickDir','out','Ticklength',tickLengthPlot,'box','off')
end
if analysisMeasure == 1||analysisMeasure == 2
    xlabel(hPlots_Fig2.hPlot1(1),'Time(ms)');
elseif analysisMeasure == 4||analysisMeasure == 5|| analysisMeasure == 6 ||analysisMeasure == 7
    xlabel(hPlots_Fig2.hPlot1(1),'Frequency(Hz)');
end

if analysisMeasure == 1
    ylabel(hPlots_Fig2.hPlot1(1),'ERP (\mu V)');ylabel(hPlots_Fig2.hPlot2(1),'RMS value of ERP');
elseif analysisMeasure == 2
    ylabel(hPlots_Fig2.hPlot1(1),'Spikes/s');ylabel(hPlots_Fig2.hPlot2(1),'spikes/s');
elseif analysisMeasure == 4 || analysisMeasure == 5 || analysisMeasure == 6||analysisMeasure == 7
    if analysisMethod ==1
        ylabel(hPlots_Fig2.hPlot1(1),'log_1_0 (FFT Amplitude)'); ylabel(hPlots_Fig2.hPlot2(1),'log_1_0 (FFT Amplitude)');
        if relativeMeasuresFlag
            ylabel(hPlots_Fig2.hPlot1(1),'log_1_0 (\Delta FFT Amplitude)'); ylabel(hPlots_Fig2.hPlot2(1),'log_1_0 (\Delta FFT Amplitude)')
        end
        
    elseif analysisMethod ==2
        ylabel(hPlots_Fig2.hPlot1(1),'log_1_0 (Power)');ylabel(hPlots_Fig2.hPlot2(1),'log_1_0 (Power)')
        if relativeMeasuresFlag
            ylabel(hPlots_Fig2.hPlot1(1),'Change in Power (dB)');  ylabel(hPlots_Fig2.hPlot2(1),'Change in Power (dB)');
        end
    end
    
end

text(0.5,0.3,['N = ' num2str(num_Electrodes)],'color','k','unit','normalized','fontSize',14,'fontWeight','bold','parent',hPlots_Fig2.hPlot2(1))
set(hPlots_Fig2.hPlot2(1),'fontSize',14,'TickDir','out','Ticklength',tickLengthPlot,'box','off')
set(hPlots_Fig2.hPlot2(1),'XTick',cValsUnique,'XTickLabelRotation',90,'XTickLabel',cValsUnique);
xlabel(hPlots_Fig2.hPlot2(1),'Contrast (%)');
title(hPlots_Fig2.hPlot2(1),'CRF along Orientation 1')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 3   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Norm_colorNames(1,:) = colors(5,:);
Norm_colorNames(2:5,:) = flip(parula(4),1);
% Plot Figure 3 neural response plots
for c = 1:5
    if analysisMeasure == 1 || analysisMeasure == 2
        plot(hPlots_Fig3.hPlot1(1),xs,squeeze(dataPlot(conFlipped(1),c,:)),'color',colors(c,:,:),'LineWidth',2);
        hold(hPlots_Fig3.hPlot1(1),'on');
        plot(hPlots_Fig3.hPlot1(2),xs,squeeze(dataPlot(c,conFlipped(1),:)),'color',Norm_colorNames(conFlipped(c),:,:),'LineWidth',2);
        hold(hPlots_Fig3.hPlot1(2),'on');
    elseif analysisMeasure == 4 || analysisMeasure == 5||analysisMeasure == 6||analysisMeasure == 7
        if ~relativeMeasuresFlag
            plot(hPlots_Fig3.hPlot1(1),xs,squeeze(dataPlotBL(conFlipped(1),c,:)),'k');
            hold(hPlots_Fig3.hPlot1(1),'on')
            plot(hPlots_Fig3.hPlot1(1),xs,squeeze(dataPlotST(conFlipped(1),c,:)),'color',colors(c,:,:),'LineWidth',2);
            
            plot(hPlots_Fig3.hPlot1(2),xs,squeeze(dataPlotBL(conFlipped(c),conFlipped(1),:)),'k');
            hold(hPlots_Fig3.hPlot1(2),'on')
            plot(hPlots_Fig3.hPlot1(2),xs,squeeze(dataPlotST(conFlipped(c),conFlipped(1),:)),'color',Norm_colorNames(c,:,:),'LineWidth',2);
        else
            plot(hPlots_Fig3.hPlot1(1),xs,squeeze(dataPlotBL(conFlipped(1),c,:))-squeeze(dataPlotBL(conFlipped(1),c,:)),'k');
            hold(hPlots_Fig3.hPlot1(1),'on')
            plot(hPlots_Fig3.hPlot1(1),xs,squeeze(dataPlotdiffSTvsBL(conFlipped(1),c,:)),'color',colors(c,:,:),'LineWidth',2);
            
            plot(hPlots_Fig3.hPlot1(2),xs,squeeze(dataPlotBL(conFlipped(c),conFlipped(1),:))-squeeze(dataPlotBL(conFlipped(c),conFlipped(1),:)),'k');
            hold(hPlots_Fig3.hPlot1(2),'on')
            if analysisMeasure == 4||analysisMeasure ==5||analysisMeasure ==6
                plot(hPlots_Fig3.hPlot1(2),xs,squeeze(dataPlotdiffSTvsBL(conFlipped(c),conFlipped(1),:)),'color',Norm_colorNames(c,:,:),'LineWidth',2);
            elseif analysisMeasure == 7
                plot(hPlots_Fig3.hPlot1(2),xs,squeeze(dataPlotdiffSTvsBL(c,conFlipped(1),:)),'color',Norm_colorNames(conFlipped(c),:,:),'LineWidth',2);
            end
        end
    end
    
    if analysisMeasure == 2
        text(0.55,0.45+c*0.08,[num2str(cValsUnique(c)) ' %'],'color',colors(c,:,:),'fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(1))
        text(0.55,0.45+c*0.08,[num2str(cValsUnique(c)) ' %'],'color',Norm_colorNames(c,:,:),'fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(2))
        text(0.55,0.45+6*0.08,'Ori:1','color','k','fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(1))
        text(0.55,0.45+6*0.08,'Ori:2','color','k','fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(2))
        
    elseif analysisMeasure == 5
        text(0.05,0.45+c*0.08,[num2str(cValsUnique(c)) ' %'],'color',colors(c,:,:),'fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(1))
        text(0.05,0.45+6*0.08,'Ori:1','color','k','fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(1))
        
        text(0.05,0.45+c*0.08,[num2str(cValsUnique(conFlipped(c))) ' %'],'color',Norm_colorNames(conFlipped(c),:,:),'fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(2))
        text(0.05,0.45+6*0.08,'Ori:2','color','k','fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(2))
    elseif analysisMeasure == 6||analysisMeasure == 7
        text(0.1+c*0.15,0.15,[num2str(cValsUnique(c)) ' %'],'color',colors(c,:,:),'fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(1))
        if c==1
            text(0.1,0.15,'Ori 1:','color','k','fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(1))
        end
        
        text(0.1+c*0.15,0.15,[num2str(cValsUnique(c)) ' %'],'color',Norm_colorNames(c,:,:),'fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(2))
        if c==1
            text(0.1,0.15,'Ori 2:','color','k','fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot1(2))
        end
    end
    
end
if analysisMeasure == 2
    title(hPlots_Fig3.hPlot1(1),'Spike Response for Orientation 1')
    title(hPlots_Fig3.hPlot1(2),{'Spike Response at 50% contrast of Ori 1','when Ori 2 is added'},'HorizontalAlignment','Center')
else
    title(hPlots_Fig3.hPlot1(1),'Change in PSD for Orientation 1')
    title(hPlots_Fig3.hPlot1(2),{'Change in PSD at 50% contrast of Ori 1','when Ori 2 is added'},'HorizontalAlignment','Center')
end
hold(hPlots_Fig3.hPlot1(1),'off');
hold(hPlots_Fig3.hPlot1(2),'off');

imagesc(analysisData,'parent',hPlots_Fig3.hPlot2(3));
color_Bar = colorbar(hPlots_Fig3.hPlot2(3));%
colorYlabelHandle = get(color_Bar,'Ylabel');
if analysisMeasure==1
    YlabelString = 'Potential';
elseif analysisMeasure==2
    YlabelString = 'Spikes/s';
elseif analysisMeasure == 4||analysisMeasure == 5||analysisMeasure == 6
    if ~relativeMeasuresFlag
        YlabelString = 'log_1_0(FFT Amplitude)';
    else
        YlabelString = 'log_1_0(\Delta FFT Amplitude)';
        if analysisMethod == 2
            YlabelString = 'Change in Power (dB)';
        end
    end
end

set(colorYlabelHandle,'String',YlabelString,'fontSize',14);
plotPos = get(hPlots_Fig3.hPlot2(3),'Position');
set(hPlots_Fig3.hPlot2(3),'Position',[plotPos(1) plotPos(2) 0.12 plotPos(4)]);
title(hPlots_Fig3.hPlot2(3),['Mean NI: ',num2str(round(mean(NI_population),2))],'fontWeight','bold');

if num_Electrodes>1
    % NI population histogram
    histogram(hPlots_Fig3.hPlot2(2),NI_population,-2:0.2:2);
end

set(hPlots_Fig3.hPlot2(2),'fontSize',14,'TickDir','out','Ticklength',tickLengthPlot,'box','off')
xlabel(hPlots_Fig3.hPlot2(2),'Normalization Index'); ylabel(hPlots_Fig3.hPlot2(2),'No. of Electrodes');
title(hPlots_Fig3.hPlot2(2),{'Population NI Histogram,' ,['Median NI: ' num2str(round(median(NI_population),2))]})
line([round(median(NI_population),2) round(median(NI_population),2)],getYLims(hPlots_Fig3.hPlot2(2)),'color','k','lineWidth',2,'parent',hPlots_Fig3.hPlot2(2))

set(hPlots_Fig3.hPlot2(3),'fontSize',14,'TickDir','out','Ticklength',tickLengthPlot,'box','off')
set(hPlots_Fig3.hPlot2(3),'XTick',1:5,'XTickLabelRotation',90,'XTickLabel',cValsUnique,'YTickLabel',flip(cValsUnique));
xlabel(hPlots_Fig3.hPlot2(3),'Ori 1 Contrast (%)');ylabel(hPlots_Fig3.hPlot2(3),'Ori 2 Contrast (%)');

if num_Electrodes>1
    errorbar(cValsUnique,analysisData(conFlipped(1),:),sem_analysisData(conFlipped(1),:),...
        'Marker','o','LineWidth',2,'color',Norm_colorNames(1,:,:),'parent',hPlots_Fig3.hPlot2(1))
    hold(hPlots_Fig3.hPlot2(1),'on');
    
    errorbar(cValsUnique,diag(flipud(analysisData)),diag(flipud(sem_analysisData)),'Marker','o','LineWidth',2,'color','k','parent',hPlots_Fig3.hPlot2(1));
else
    plot(cValsUnique,analysisData(conFlipped(1),:),...
        'Marker','o','LineWidth',2,'color',Norm_colorNames(1,:,:),'parent',hPlots_Fig3.hPlot2(1))
    hold(hPlots_Fig3.hPlot2(1),'on');
    
    plot(cValsUnique,diag(flipud(analysisData)),'Marker','o','LineWidth',2,'color','k','parent',hPlots_Fig3.hPlot2(1));
end
% for iCon = 1:5
%     errorbar(cValsUnique,analysisData(conFlipped(iCon),:),sem_analysisData(conFlipped(iCon),:),...
%         'Marker','o','LineWidth',2,'color',Norm_colorNames(iCon,:,:),'parent',hPlots_Fig3.hPlot2(1))
%     hold(hPlots_Fig3.hPlot2(1),'on')
%     text(0.5,iCon*0.07+0.05,['Ori 2: ' num2str(cValsUnique(iCon)) ' %'],'color',Norm_colorNames(iCon,:,:),'fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot2(1))
% end
hold(hPlots_Fig3.hPlot2(1),'off');
text(0.5,0.2,'Ori 2: 0%','color',colors(5,:,:),'fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot2(1))
text(0.5,0.1,'Ori 1 = Ori 2','color','k','fontWeight','bold','fontSize',14,'unit','normalized','parent',hPlots_Fig3.hPlot2(1))


if analysisMeasure == 1||analysisMeasure == 2
    displayRange(hPlots_Fig3.hPlot1,[0.2 0.4],getYLims(hPlots_Fig3.hPlot1),'k');
elseif analysisMeasure ==4
    displayRange(hPlots_Fig3.hPlot1,[8 12],getYLims(hPlots_Fig3.hPlot1),'k');
elseif analysisMeasure == 5
    displayRange(hPlots_Fig3.hPlot1,[30 80],getYLims(hPlots_Fig3.hPlot1),'k');
elseif analysisMeasure == 6
    displayRange(hPlots_Fig3.hPlot1,[104 250],getYLims(hPlots_Fig3.hPlot1),'k');
elseif analysisMeasure == 7
    displayRange(hPlots_Fig3.hPlot1,[16 16],getYLims(hPlots_Fig3.hPlot1),'k');
end

tickLengthPlot = 2*get(hPlots_Fig3.hPlot2(1),'TickLength');

for idx =1:2
    set(hPlots_Fig3.hPlot1(idx),'fontSize',14,'TickDir','out','Ticklength',tickLengthPlot,'box','off')
end
if analysisMeasure == 1||analysisMeasure == 2
    xlabel(hPlots_Fig3.hPlot1(1),'Time(ms)');
elseif analysisMeasure == 4||analysisMeasure == 5|| analysisMeasure == 6|| analysisMeasure == 7
    xlabel(hPlots_Fig3.hPlot1(1),'Frequency(Hz)');
end

if analysisMeasure == 1
    ylabel(hPlots_Fig3.hPlot1(1),'ERP (\mu V)');ylabel(hPlots_Fig3.hPlot2(1),'RMS value of ERP');
elseif analysisMeasure == 2
    ylabel(hPlots_Fig3.hPlot1(1),'Spikes/s');ylabel(hPlots_Fig3.hPlot2(1),'spikes/s');
elseif analysisMeasure == 4 || analysisMeasure == 5 || analysisMeasure == 6|| analysisMeasure == 7
    if analysisMethod ==1
        ylabel(hPlots_Fig3.hPlot1(1),'log_1_0 (FFT Amplitude)'); ylabel(hPlots_Fig3.hPlot2(1),'log_1_0 (FFT Amplitude)');
        if relativeMeasuresFlag
            ylabel(hPlots_Fig3.hPlot1(1),'log_1_0 (\Delta FFT Amplitude)'); ylabel(hPlots_Fig3.hPlot2(1),'log_1_0 (\Delta FFT Amplitude)')
        end
        
    elseif analysisMethod ==2
        ylabel(hPlots_Fig3.hPlot1(1),'log_1_0 (Power)');ylabel(hPlots_Fig3.hPlot2(1),'log_1_0 (Power)')
        if relativeMeasuresFlag
            ylabel(hPlots_Fig3.hPlot1(1),'Change in Power (dB)');  ylabel(hPlots_Fig3.hPlot2(1),'Change in Power (dB)');
        end
    end
    
end

% set(hOtherMeaures(1),'XScale','linear')
% text(0.5,0.3,['N = ' num2str(dataSize(1))],'color','k','unit','normalized','fontSize',14,'fontWeight','bold','parent',hPlots_Fig3.hPlot2(1))
set(hPlots_Fig3.hPlot2(1),'fontSize',14,'TickDir','out','Ticklength',tickLengthPlot,'box','off')
set(hPlots_Fig3.hPlot2(1),'XTick',cValsUnique,'XTickLabelRotation',90,'XTickLabel',cValsUnique);
xlabel(hPlots_Fig3.hPlot2(1),'Ori 1 Contrast (%)');
title(hPlots_Fig3.hPlot2(1),'CRF along Ori 1')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Accessory Functions  %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get Color String
function [colorString, colorNames] = getColorString

colorNames = 'brkgcmy';
colorString = 'blue|red|black|green|cyan|magenta|yellow';

end

% Get FileNamesList
function [fileNameStringAll,fileNameStringListAll,fileNameStringListArray] = getFileNameStringList

[tmpFileNameStringList,monkeyNameList] = getNormalizationExperimentDetails;

fileNameStringAll = ''; pos=1;
clear fileNameStringListArray

for i=1:length(monkeyNameList)
    for j=1:length(tmpFileNameStringList{i})
        fileNameStringAll = [cat(2,fileNameStringAll,tmpFileNameStringList{i}{j}) '|'];
        fileNameStringListAll{pos} = tmpFileNameStringList{i}(j);
        fileNameStringListArray{pos} = tmpFileNameStringList{i}(j); %#ok<*AGROW>
        pos=pos+1;
    end
end

allNames = [];
for i=1:length(monkeyNameList)
    fileNameStringAll = [cat(2,fileNameStringAll,monkeyNameList{i}) ' (N=' num2str(length(tmpFileNameStringList{i})) ')|'];
    fileNameStringListAll{pos} = {[monkeyNameList{i} ' (N=' num2str(length(tmpFileNameStringList{i})) ')']};
    fileNameStringListArray{pos} = tmpFileNameStringList{i};
    allNames = cat(2,allNames,tmpFileNameStringList{i});
    pos=pos+1;
end

fileNameStringAll = cat(2,fileNameStringAll,['all (N=' num2str(length(allNames)) ')']);
fileNameStringListAll{pos} = {['all (N=' num2str(length(allNames)) ')']};
fileNameStringListArray{pos} = allNames;
end

% Get ElectrodesList
% function [ElectrodeArrayListAll,allGoodElectrodesStrArray,ElectrodeStringListAll,allGoodNs,allGoodSNRs,alld_elecs,numElecs] = getElectrodesList(fileNameStringTMP,elecParams,timeRangeForComputation,folderSourceString)
% 
% % [~,tmpElectrodeArrayList,~] = getGoodElectrodesDetails(fileNameStringTMP,oriSelectiveFlag,folderSourceString);
% 
% gridType = 'microelectrode';
% 
% numSessions = length(fileNameStringTMP);
% tmpElectrodeStringList = cell(1,numSessions);
% tmpElectrodeArrayList = cell(1,numSessions);
% numElecs = 0;
% 
% Monkey1_ExpDates = dataInformationPlaidNorm('alpaH',gridType,0);
% Monkey1_SessionNum = length(Monkey1_ExpDates);
% % Monkey2_ExpDates = dataInformationPlaidNorm('kesariH',gridType,0);
% % Monkey2_SessionNum = length(Monkey2_ExpDates);
% allGoodNs = [];
% allGoodSNRs = [];
% alld_elecs = [];
% 
% for i = 1:numSessions
%     clear monkeyName
%     if strcmp(fileNameStringTMP{i}(1:5),'alpaH')
%         monkeyName = 'alpaH';
%         expDate = fileNameStringTMP{i}(6:11);
%         protocolName = fileNameStringTMP{i}(12:end);
%     elseif strcmp(fileNameStringTMP{i}(1:7),'kesariH')
%         monkeyName = 'kesariH';
%         expDate = fileNameStringTMP{i}(8:13);
%         protocolName = fileNameStringTMP{i}(14:end);
%     end
%     if i == 1
%         disp(['MonkeyName: ' ,monkeyName])
%     elseif i == Monkey1_SessionNum+1 % 13 Sessions are from alpaH; 9 Sessions from kesariH;
%         disp(['MonkeyName: ' ,monkeyName])
%     end
%     versionNum = 2;
%     [tmpElectrodeStringList{i},tmpElectrodeStringArrayList{i},tmpElectrodeArrayList{i},goodNs,goodSNRs,d_elecs,goodElectrodes] = getGoodElectrodesSingleSession(monkeyName,expDate,protocolName,gridType,elecParams,timeRangeForComputation,folderSourceString,versionNum);
%     allGoodNs = cat(2,allGoodNs,goodNs);
%     allGoodSNRs = cat(2,allGoodSNRs,goodSNRs);
%     alld_elecs = cat(2,alld_elecs,d_elecs);
%     numElecs = numElecs+length(goodElectrodes);
% end
% allGoodElectrodesStrArray = tmpElectrodeStringArrayList;
% ElectrodeStringListAll = tmpElectrodeStringList;
% ElectrodeArrayListAll = tmpElectrodeArrayList;
% end

function [ElectrodeStringListAll,ElectrodeArrayListAll,ElectrodeList] = getElectrodesList(fileNameStringTMP,elecParams,timeRangeForComputation,folderSourceString)

versionNum = 2;
[tmpElectrodeStringList,tmpElectrodeArrayList,goodElectrodes,allElecs] = getGoodElectrodesDetails(fileNameStringTMP,elecParams,timeRangeForComputation,folderSourceString,versionNum);

if length(tmpElectrodeStringList)> 1
    clear tmpElectrodeStringList
    tmpElectrodeStringList = {['all (N=' num2str(allElecs) ')']};
end

ElectrodeStringListAll = tmpElectrodeStringList;
ElectrodeArrayListAll = tmpElectrodeArrayList;
ElectrodeList = goodElectrodes;
end

% Normalize data for ERP and Spike data
function normData = normalizeData(x)
for iElec = 1:size(x.data,1)
    for t = 1:size(x.data,2)
        normData.data(iElec,t,:,:,:) = x.data(iElec,t,:,:,:)./max(max(max(abs(x.data(iElec,t,:,:,:)))));
        normData.analysisDataBL(iElec,t,:,:) = x.analysisDataBL(iElec,t,:,:)./max(max(abs(x.analysisDataBL(iElec,t,:,:))));
        normData.analysisData_cBL(iElec,t,:,:) = x.analysisData_cBL(iElec,t,:,:)./max(max(abs(x.analysisData_cBL(iElec,t,:,:))));
        normData.analysisDataST(iElec,t,:,:) = x.analysisDataST(iElec,t,:,:)./max(max(abs(x.analysisDataST(iElec,t,:,:))));
        normData.timeVals = x.timeVals;
        normData.N = x.N;
    end
end
end

% Get data for a single electrode in a selected session
function data = getDataSingleElec(data,electrodeNum,analysisMeasure)
if analysisMeasure == 1 || analysisMeasure ==2
    data.data = data.data(electrodeNum,:,:,:,:);
    data.analysisDataBL = data.analysisDataBL(electrodeNum,:,:,:);
    data.analysisData_cBL = data.analysisData_cBL(electrodeNum,:,:,:);
    data.analysisDataST = data.analysisDataST(electrodeNum,:,:,:);
    data.N = data.N(electrodeNum,:,:,:);
    
elseif analysisMeasure == 4 || analysisMeasure == 5 || analysisMeasure == 6||analysisMeasure == 7
    data.dataBL = data.dataBL(electrodeNum,:,:,:,:);
    data.dataST = data.dataST(electrodeNum,:,:,:,:);
    for i = 1:length(data.analysisDataST)
        data.analysisDataBL{i} = data.analysisDataBL{i}(electrodeNum,:,:,:);
        data.analysisData_cBL{i} = data.analysisData_cBL{i}(electrodeNum,:,:,:);
        data.analysisDataST{i} = data.analysisDataST{i}(electrodeNum,:,:,:);
    end
end
end

% Get mean data for all electrode in a single session
function data2 = getMeanDataAcrossElectrodes(data,analysisMeasure)
if analysisMeasure == 1 || analysisMeasure ==2
    data2.data = mean(data.data,1);
    data2.analysisDataBL = mean(data.analysisDataBL,1);
    data2.analysisData_cBL = mean(data.analysisData_cBL,1);
    data2.analysisDataST = mean(data.analysisDataST,1);
    data2.N = data.N(1,:,:,:);
    
elseif analysisMeasure == 4 || analysisMeasure == 5 || analysisMeasure == 6||analysisMeasure == 7
    data2.dataBL = mean(data.dataBL,1);
    data2.data_cBL = mean(data.data_cBL,1);
    data2.dataST = mean(data.dataST,1);
    for i = 1:length(data.analysisDataST)
        data2.analysisDataBL{i} = mean(data.analysisDataBL{i},1);
        data2.analysisData_cBL{i} = mean(data.analysisData_cBL{i},1);
        data2.analysisDataST{i} = mean(data.analysisDataST{i},1);
    end
end
end


% Draw lines for timeTange or FreqRange
function displayRange(plotHandles,range,yLims,colorName)
[nX,nY] = size(plotHandles);

yVals = yLims(1):(yLims(2)-yLims(1))/100:yLims(2);
xVals1 = range(1) + zeros(1,length(yVals));
xVals2 = range(2) + zeros(1,length(yVals));

for i=1:nX
    for j=1:nY
        hold(plotHandles(i,j),'on');
        plot(plotHandles(i,j),xVals1,yVals,'color',colorName);
        plot(plotHandles(i,j),xVals2,yVals,'color',colorName);
    end
end

end

% get Y limits for an axis
function yLims = getYLims(plotHandles)

[numRows,numCols] = size(plotHandles);
% Initialize
yMin = inf;
yMax = -inf;

for row=1:numRows
    for column=1:numCols
        % get positions
        axis(plotHandles(row,column),'tight');
        tmpAxisVals = axis(plotHandles(row,column));
        if tmpAxisVals(3) < yMin
            yMin = tmpAxisVals(3);
        end
        if tmpAxisVals(4) > yMax
            yMax = tmpAxisVals(4);
        end
    end
end

yLims=[yMin yMax];
end

% Rescale data
function rescaleData(plotHandles,xMin,xMax,yLims)

[numRows,numCols] = size(plotHandles);
labelSize=14;
for i=1:numRows
    for j=1:numCols
        axis(plotHandles(i,j),[xMin xMax yLims]);
        if (i==numRows && rem(j,2)==1)
            if j==1
                set(plotHandles(i,j),'fontSize',labelSize);
            elseif j~=1
                set(plotHandles(i,j),'YTickLabel',[],'fontSize',labelSize);
            end
        elseif (rem(i,2)==0 && j==1)
            set(plotHandles(i,j),'XTickLabel',[],'YTickLabel',[],'fontSize',labelSize);
            
        else
            set(plotHandles(i,j),'XTickLabel',[],'YTickLabel',[],'fontSize',labelSize);
        end
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



