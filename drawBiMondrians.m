function drawBiMondrians(initSetting, experimentPars, cfsPars)
	xCenterVariation = - cfsPars.xrangeMond/2 + rand(1, cfsPars.mondrianNumber).*(cfsPars.xrangeMond); %location
	xCenterDominate = cfsPars.centerDomin(1) + xCenterVariation;
	xCenterNDominate = cfsPars.centerNDomin(1) + xCenterVariation;
	yCenter = cfsPars.centerDomin(2) - cfsPars.yrangeMond/2 + rand(1, cfsPars.mondrianNumber).*(cfsPars.yrangeMond);

	X = ones(1, cfsPars.mondrianNumber).*cfsPars.minMond + rand(1, cfsPars.mondrianNumber).*cfsPars.sizeMond; %size
	Y = ones(1, cfsPars.mondrianNumber).*cfsPars.minMond + rand(1, cfsPars.mondrianNumber).*cfsPars.sizeMond;
	object = cat(1, zeros(1, cfsPars.mondrianNumber), zeros(1, cfsPars.mondrianNumber), X, Y);
	color = 255*rand(3, cfsPars.mondrianNumber); % colorful Mondrian
	%color = 255*repmat(rand(1, cfsPars.mondrianNumber),3,1); % gray scale Mondrian
	% support binocular Mondrian set, with same size and color in the two dispatch
	object = repmat(object, 1, 2);
	color = repmat(color, 1, 2);
	yCenter = repmat(yCenter, 1, 2);
	xCenter = [xCenterDominate, xCenterNDominate];

	Screen('FillRect', initSetting.windowPtr, color, CenterRectOnPoint(object,xCenter, yCenter));
	Screen('FillOval', initSetting.windowPtr, color, CenterRectOnPoint(object,xCenter, yCenter));
	%drawHolderFrame;

