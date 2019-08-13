function experimentFont = setExperimentFont(initSetting, experimentPars)
	oldLocaleNameString = Screen('Preference','TextEncodingLocale','UTF-8');
	Screen('Preference', 'TextRenderer', 1);

	% Disable font setting, because windows can't use BiauKai
	%[oldFontName,oldFontNumber]=Screen('TextFont', initSetting.windowPtr ,'BiauKai');

	%Set Font Size Here is easier to implement center latter
	% Value of PTB textSize have to be integer
	experimentFont.textSizeMinorTune = 0; % Unit: pixel; This is used to micro-adjust size
	experimentFont.textSize = round(3*experimentPars.degToPix) - experimentFont.textSizeMinorTune; %default = 5; while on goggle
	experimentFont.textSizeSti = round(3*experimentPars.degToPix) - experimentFont.textSizeMinorTune; %default
	experimentFont.textOffSet = 20; % Unit: pixel
	experimentFont.toCenter = experimentFont.textSize/2 + experimentFont.textOffSet;
	experimentFont.toCenterX = -8;
	experimentFont.toCenterY = -0; % up -; down +

	experimentFont.textSizeIBI = round(0.5*experimentPars.degToPix);
	experimentFont.textSizeInstruction = round(0.5*experimentPars.degToPix);

	experimentFont.textIBIOffSet = 2*experimentPars.degToPix;
	experimentFont.textIBIOffSetVertical = -1.8*experimentPars.degToPix;
	experimentFont.textInstructionOffSet = 7*experimentPars.degToPix;
	experimentFont.testIdiomOffSet = 4*experimentPars.degToPix; % This is for recheck idiom in IBI

	% Text color
	experimentFont.textContrast = 1; % Default setting
	%initSetting.white = initSetting.white - 200; %change word brightness
	experimentFont.textColor = [repmat(initSetting.black, 1, 3), 255*experimentFont.textContrast];
	%experimentFont.textColor = [repmat(initSetting.white, 1, 3), 0.9];


	% Superimposed stimuli contrast
	experimentFont.imposeContrast = 1; % Default setting

