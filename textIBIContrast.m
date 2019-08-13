function textIBIContrast(initSetting, experimentPars, experimentFont, cfsPars)

	experimentFont.textSize = experimentFont.textSizeIBI;
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSizeIBI);
	c_text = textInstructionList;
	DrawFormattedText(initSetting.windowPtr, c_text.contrast{1}, cfsPars.centerDomin(1) - experimentFont.textIBIOffSet, cfsPars.centerNDomin(2) - experimentFont.textIBIOffSet + experimentFont.textIBIOffSetVertical, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
	Screen('DrawingFinished', initSetting.windowPtr);
	Screen('Flip', initSetting.windowPtr);
