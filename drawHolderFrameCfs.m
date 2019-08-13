function drawHolderFrameCfs(initSetting, experimentPars, cfsPars)

	experimentPars.center = {[cfsPars.centerDomin(1), cfsPars.centerNDomin(1)], [cfsPars.centerDomin(2), cfsPars.centerNDomin(2)]};
	drawHolderFrame(initSetting, experimentPars, cfsPars)
