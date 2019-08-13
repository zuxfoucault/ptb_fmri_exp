function initSetting = init

	AssertOpenGL;
	% PTB check
	Screen('Preference', 'SkipSyncTests', 1);

	% Screen initiation, parameters, background color
	initSetting.screenNumbers = max(Screen('Screens'));
	% use original monitor
	initSetting.screenNumbers = 0;
	[initSetting.resx, initSetting.resy] = Screen('WindowSize',initSetting.screenNumbers);
	[initSetting.mmx, initSetting.mmy] = Screen('displaySize', initSetting.screenNumbers);
	initSetting.hz = Screen('FrameRate', initSetting.screenNumbers, []);
	PsychImaging('PrepareConfiguration');
	PsychImaging('AddTask', 'General', 'UseVirtualFramebuffer');
	[initSetting.windowPtr, initSetting.screenRect] = PsychImaging('OpenWindow',initSetting.screenNumbers,0,[],[],2);
	Screen('BlendFunction', initSetting.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	initSetting.ifi = Screen('GetFlipInterval', initSetting.windowPtr); %The returned monitorRefreshInterval is in seconds. initSetting.ifi == fPeriod. % second
	initSetting.black = BlackIndex(initSetting.windowPtr);
	initSetting.white = WhiteIndex(initSetting.windowPtr);
	initSetting.backgroundColor = (initSetting.black+initSetting.white)/2;
	Screen(initSetting.windowPtr, 'FillRect', initSetting.backgroundColor);
	initSetting.tvbl = Screen('Flip', initSetting.windowPtr); %first tvbl anchor

	% Keyboard
	KbName('UnifyKeyNames');

