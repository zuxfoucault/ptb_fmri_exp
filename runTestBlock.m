function runTestBlock(initSetting, experimentPars, idiomList)
	for i=1:experimentPars.nImages,
		Screen(initSetting.windowPtr, 'FillRect', 255*rand(1,3));
		Screen('DrawText', initSetting.windowPtr, [idiomList(1,1) idiomList(1,2)], initSetting.resx/3, initSetting.resy/2, 255);
		
		%Screen(initSetting.windowPtr,'FillRect', 255*rand*ones(1,3));
		initSetting.tvbl = Screen('Flip', initSetting.windowPtr, initSetting.tvbl + initSetting.ifi*(experimentPars.durFrames - 0.5)); %duration - 0.5*initSetting.ifi
	end;
