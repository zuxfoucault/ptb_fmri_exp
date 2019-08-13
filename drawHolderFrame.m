function drawHolderFrame(initSetting, experimentPars, cfsPars)

	frameRange = repmat((cfsPars.mondrianPatchDisplaySize + experimentPars.increamentFrameSize)*experimentPars.degToPix, 1, 2); %shape: square
	frameObject = [0, 0, frameRange];

	if iscell(experimentPars.center),
	frameObject = repmat(frameObject',1 ,length(experimentPars.center{1}));
		Screen(initSetting.windowPtr, 'FrameRect', 50, CenterRectOnPoint(frameObject, experimentPars.center{1}, experimentPars.center{2}), experimentPars.penWidFrame); % placeholder frame
	else
		Screen(initSetting.windowPtr, 'FrameRect', 50, CenterRectOnPoint(frameObject, experimentPars.center(1), experimentPars.center(2)), experimentPars.penWidFrame); % placeholder frame
	end;
