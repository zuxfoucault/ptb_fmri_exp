function experimentPars = setExperimentPars(initSetting)
	% Collection of all main parameters

	experimentPars.nImages = 3; % For testBlock; not in formal experiment
	experimentPars.nCharacters = 4;
	experimentPars.nCondition = 4;
	experimentPars.nTrialInBolck = 10; % Default = 10; debug=2
	experimentPars.nBolckRepetitionInRun = 4; % At least 2, or buggy in g.functionIdiomCondition; Default = 4
	experimentPars.runs = 4; % Default = 4
	experimentPars.runsROI = 1;
	experimentPars.runsPretest = 1;


	% How many practice trials
	experimentPars.nTrialInBolckPrac = 2; % Default = 2

	% setConstrast; How many trials to acquire contrast level
	experimentPars.nContrastTrial = 60; % Default and maximum = 60

	% Contrast band filter
	experimentPars.contrastLowpass = 1;
	experimentPars.contrastHighpass = 0.15;

	% Percentage for adjusting the contrast
	experimentPars.contrastDegrading = 0.9;
	experimentPars.contrastUpgrading = 1.1;

	% Staircase turning point
	experimentPars.turningPoint = 12;

	% How many turning point to be included to find contrast level
	experimentPars.turningPointExcluding = experimentPars.turningPoint - 6; % Total - including

	experimentPars.nContrastTrialInBolck = 1;

	% Timing
	experimentPars.duration = 0.5; % Unit: seconds; This is default value; This maybe 
	experimentPars.durFrames = ceil(experimentPars.duration/initSetting.ifi);

	% fix point duration
	experimentPars.durationFixP = 1;
	experimentPars.durFramesFixP = ceil(experimentPars.durationFixP/initSetting.ifi);

	% Fixation baseline duration in localizer session
	experimentPars.fixationBaselineDur = 20; % Default = 20s;


	% each character
	experimentPars.durationCh = 0.25;
	experimentPars.durFramesCh = ceil(experimentPars.durationCh/initSetting.ifi);

	% inter block interval
	experimentPars.durIbi = 3; % Default=3, total IBI = 6; debug=1.5
	experimentPars.durIbiFroi = 6; % Default=6; debug=3


	[experimentPars.center(1) experimentPars.center(2)] = RectCenter(initSetting.screenRect);
	experimentPars.viewdist = 300; %unit: mm
	experimentPars.mmxToPix = initSetting.resx/initSetting.mmx;
	experimentPars.degToPix = ceil(tan(2*pi/360)*(experimentPars.viewdist*experimentPars.mmxToPix));

	% drawFixPoint
	experimentPars.fixSizeDeg = .9; % Fixation point
	experimentPars.fixSize = experimentPars.fixSizeDeg * experimentPars.degToPix;
	experimentPars.penWidDeg = .1; % Fixation pencil width
	experimentPars.penWid = experimentPars.penWidDeg * experimentPars.degToPix;

	% drawHolderFrame
	experimentPars.penWidFrame = 1*experimentPars.degToPix;
	experimentPars.increamentFrameSize = 4;

	% drawMondrians

	% text constract (MRI response box set in below)
	experimentPars.downContrastSignal = KbName('LeftArrow');
	experimentPars.upContrastSignal = KbName('RightArrow');

	% MRI setting
	experimentPars.mriHook = initSetting.mriHook; % if connect to MRI machine
	if experimentPars.mriHook == 0,
		experimentPars.triggertype = 0;  % 0 = keyboard; 1 = Serial Port/Lumina
		experimentPars.responsetype = 0;
	elseif experimentPars.mriHook == 1,
		experimentPars.triggertype = 1;  % 0 = keyboard; 1 = Serial Port/Lumina
		experimentPars.responsetype = 1;

		% Set moving contrast down keyCode
		experimentPars.downContrastSignal = 51; % Left key; This is for Yuling's setting
		experimentPars.upContrastSignal = 52; % Right key

		% Inter block interval; for correctness of lost trigger timer
		experimentPars.durIbi = 3 - 0.25; % Default=3, total IBI = 6; debug=1.5
		experimentPars.durIbiFroi = 6 - 0.25; % Default=6; debug=3
		experimentPars.fixationBaselineDur = 20 - 0.5; % Default = 20s;
		experimentPars.durationFixP = 1 - 0.015;

	end
