function drawFixPoint(initSetting, experimentPars)
	% Draw fixation point
	if iscell(experimentPars.center),
		% Multiple fix point
		rectHorizontal = reshape([(experimentPars.center{1} - experimentPars.fixSize/2), (experimentPars.center{2} - experimentPars.penWid/2), (experimentPars.center{1} + experimentPars.fixSize/2), (experimentPars.center{2} + experimentPars.penWid/2)], length(experimentPars.center{1}), 4);
		Screen(initSetting.windowPtr, 'FillRect', initSetting.black, rectHorizontal');
		rectVertical = reshape([(experimentPars.center{1} - experimentPars.penWid/2), (experimentPars.center{2} - experimentPars.fixSize/2), (experimentPars.center{1} + experimentPars.penWid/2),(experimentPars.center{2} + experimentPars.fixSize/2)], length(experimentPars.center{1}), 4);
		Screen(initSetting.windowPtr, 'FillRect', initSetting.black, rectVertical');
	else % original fix point Center
		Screen(initSetting.windowPtr, 'FillRect', initSetting.black, [(experimentPars.center(1) - experimentPars.fixSize/2), (experimentPars.center(2) - experimentPars.penWid/2), (experimentPars.center(1) + experimentPars.fixSize/2), (experimentPars.center(2) + experimentPars.penWid/2)]);
		Screen(initSetting.windowPtr, 'FillRect', initSetting.black, [(experimentPars.center(1) - experimentPars.penWid/2), (experimentPars.center(2) - experimentPars.fixSize/2), (experimentPars.center(1) + experimentPars.penWid/2),(experimentPars.center(2) + experimentPars.fixSize/2)]);
	end;
