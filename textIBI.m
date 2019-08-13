function textIBI(initSetting, experimentPars, experimentFont, cfsPars)

	global g

	experimentFont.textSize = experimentFont.textSizeIBI;
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	c_text = textInstructionList;
	DrawFormattedText(initSetting.windowPtr, c_text.IBI, cfsPars.centerDomin(1) - ...
		experimentFont.textIBIOffSet, cfsPars.centerNDomin(2) - experimentFont.textIBIOffSet + experimentFont.textIBIOffSetVertical, ...
		0, 40, [], [], 1.5, []);
	%[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
	
	DrawFormattedText(initSetting.windowPtr, g.testIdiom, cfsPars.centerDomin(1) - ...
		experimentFont.textIBIOffSet, cfsPars.centerNDomin(2) - experimentFont.textIBIOffSet + ...
		experimentFont.testIdiomOffSet + ...
		experimentFont.textIBIOffSetVertical, 0, 40, [], [], 1.5, []);
	Screen('DrawingFinished', initSetting.windowPtr);
	Screen('Flip', initSetting.windowPtr);
