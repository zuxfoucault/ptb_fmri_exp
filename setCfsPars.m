function cfsPars = setCfsPars(initSetting, experimentPars)
	cfsPars.dominatingEye = experimentPars.dominatingEye;
	if cfsPars.dominatingEye == 0,
		cfsPars.centerDomin = [initSetting.resx/4*1, initSetting.resy/2];
		cfsPars.centerNDomin = [initSetting.resx/4*3, initSetting.resy/2];
	elseif cfsPars.dominatingEye == 1,
		cfsPars.centerDomin = [initSetting.resx/4*3, initSetting.resy/2];
		cfsPars.centerNDomin = [initSetting.resx/4*1, initSetting.resy/2];
	end;

	% setting Mondrian parameter
	cfsPars.minMond = .15*experimentPars.degToPix;
	cfsPars.sizeMond = 2*experimentPars.degToPix;
	cfsPars.mondrianPatchDisplaySize = 4; % More about Frame size
	cfsPars.xrangeMond = (cfsPars.mondrianPatchDisplaySize + 1.5)*experimentPars.degToPix;
	cfsPars.yrangeMond = (cfsPars.mondrianPatchDisplaySize + 1.5)*experimentPars.degToPix;
	cfsPars.mondrianNumber = 500; %Mondrian number per frame

	% setting Mondrian flash rate
	cfsPars.mondFlashDur = 1/10; % seconds/hz; tvbl + mondDuration - 0.5*ifi
	cfsPars.durFramesMond = round(cfsPars.mondFlashDur/initSetting.ifi);

	% number of mondrian patches
	cfsPars.nMondrianPatch = 10;

	%use fix Mondrian Pattern or not
	cfsPars.fixMondrianPattern = 1;
	%cfsPars.MondrianPattern = 1; % May be deleted
