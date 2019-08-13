%function idiomPretest
% Inherit from idiomMain
try
	clear all; fclose all;
	sca; FlushEvents;
	PsychJavaTrouble;
	%Screen('Preference', 'SkipSyncTests', 3); % normally to 1, 2 is just for demo
	%ListenChar(2); %generate some problem with KbQueueXXX; Cause problem in Windows

	timeCheck(1) = GetSecs
	global debug baseName resp g


	debug = 0; % Set debug level for developing; set to 0 for formal experiment
	mriHook = 0; % If running in Yuling


	% Basic input
	if debug == 1,
		experimentTitle = 'idiomPretest';
		subjectTitle = 0;
		dominatingEye = 0;

	elseif debug == 0,
		experimentTitle = 'idiomPretest';
		prompt = {'dominatingEye', 'subjectTitle', 'constrastStiInit'};
		default = {'0', '0', '0.5'}; % input should be numbers
		dlgTitle = 'Parameters';
		numLines = 1;
		tmp = inputdlg(prompt, dlgTitle, numLines, default);
		%[bigCondition, dominatingEye] = deal(inputdlg(prompt, dlgTitle, numLines, default));
		%[bigCondition, dominatingEye] = deal(tmp{:});
		for i = 1:length(tmp),
			eval(sprintf('%s = %d;', cell2mat(prompt(i)), str2num(cell2mat(tmp(i)))));
		end;
	end;


	HideCursor;

	initSetting = init;
	initSetting.mriHook = mriHook;
	if debug == 0,
		initSetting.contrastStiInit = constrastStiInit;
	else,
		initSetting.contrastStiInit = 0.5; % Default
	end;
	experimentPars = setExperimentPars(initSetting);
	experimentPars.dominatingEye = dominatingEye;
	cfsPars = setCfsPars(initSetting, experimentPars);
	experimentFont = setExperimentFont(initSetting, experimentPars);
	maxPriorityLevel = MaxPriority(initSetting.windowPtr);
	Priority(maxPriorityLevel);

	experimentPars.mriHook = 0; % if connect to MRI machine


	mri = mriInit(experimentPars); % Mri setting initiation
	experimentPars.mri = mri;


	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);


	responsePars = setResponseKeys; % Keyboard setting


	c = clock; % Current date and time as date vector. [year month day hour minute seconds]
	baseName = [experimentTitle '_' num2str(subjectTitle) 'D' num2str(dominatingEye) '_Exp_' num2str(c(1)) '_' num2str(c(2)) '_' num2str(c(3)) '_' num2str(c(4)) '_' num2str(c(5))]; % Makes unique filename
	baseNameDebug = [baseName '_debug'];
	saveVariablesStr = {'resp'};
	saveVariablesStrToGlobal = {'responsePars', 'idiomListShuffled', 'dominatingEye'};


	%idiomList = idiomUtf8; % Idiom list
	idiomList = textOutSourcePretestII; % Idiom list for Pretest
	idiomListShuffled = setIdiomListShuffled(idiomList, experimentPars);
	makeIdiomNovelPretest(experimentPars);


	for iVariable = 1:length(saveVariablesStrToGlobal),
		eval(sprintf('resp.%s = %s;', char(saveVariablesStrToGlobal(iVariable)), char(saveVariablesStrToGlobal(iVariable)))); % Field name match variable name
	end;


	% If fix pattern needed
	cfsPars.fixMondrianPattern = 1;
	if cfsPars.fixMondrianPattern == 1,
		if exist('mondrianRandMatrices.mat'),
			load('mondrianRandMatrices.mat', 'mondrianRandMatrices');
			cfsPars.mondrianRandMatrices = mondrianRandMatrices;
		else,
			error('mondrianRandMatrices.mat not found')
			makeMondrians(initSetting, experimentPars, cfsPars);
			load('mondrianRandMatrices.mat', 'mondrianRandMatrices');
			cfsPars.mondrianRandMatrices = mondrianRandMatrices;
		end;
	end;


	% Open parallel job for recording MRI trigger receiving time stamp
	%recJob = batch(receiveMriTrigger or recordMriTrigger(ex...
	%recJob = batch('recordMriTrigger', 1, 'experimentPars')


	resp.downContrastSignalCount = 0; % Initiate contrast feedback loop; set [] to disable; This feedback is to diminish the contrast

	resp.upContrastSignalCount = []; % Initiate contrast feedback loop; set [] to disable; This feedback is to increase the contrast

	resp.textContrastState = experimentFont.textContrast;

	[experimentPars cfsPars] = adjustMondrianFrame(initSetting, experimentPars, experimentFont, cfsPars);


	%textInstruction(initSetting, experimentPars, experimentFont, cfsPars);
	%practiceTrial(initSetting, experimentPars, experimentFont, cfsPars);
	%setContrastLevel(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont);
	%idiomPracticePretest(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont);
	%regularSession(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont);
	%endInstruction(initSetting, experimentPars, cfsPars, experimentFont);
	%functionalROI(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont);

	if debug == 0, % 0
		textInstruction(initSetting, experimentPars, experimentFont, cfsPars);

		practiceTrial(initSetting, experimentPars, experimentFont, cfsPars);

		setContrastLevelPretest(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont);
		idiomPracticePretest(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont);

		%regularSession(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont);

		%functionalROI(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont);

		%endInstruction(initSetting, experimentPars, cfsPars, experimentFont);

		%runTestBlock(initSetting, experimentPars, idiomList);

		%global lTiming llTiming;%for timing test

	end;

	disp('Trial count:')
	disp(resp.iBlock)
	disp('Contrast value:')
	if length(resp.contrastStateRecording) < 6,
		disp(mean(resp.contrastCeaseRecording(end - 5 : end)))
	else
		disp(mean(resp.contrastStateRecording)*0.8)
	end
	interData = statIntermediatePretest(resp, experimentPars)


	if debug == 0,
		save(baseName, saveVariablesStr{:});
		save(baseNameDebug);
	end;

	if mri.triggertype == 1 || mri.responsetype == 1, % mri expel
		fclose(mri.s2);
	end


	timeCheck(2) = GetSecs
	(timeCheck(2)-timeCheck(1))/60

	WaitSecs(.1);
	Screen('CloseAll');
	clear mex;
	Priority(0);
	ListenChar(0);
	ShowCursor;

catch err,
	Screen('CloseAll');
	clear mex;
	Priority(0);
	ListenChar(0);
	if mri.triggertype == 1 || mri.responsetype == 1, % mri expel
		fclose(mri.s2);
	end;
	ShowCursor;
	err.stack
	err.message
end
