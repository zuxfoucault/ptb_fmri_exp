function drawMondrians(initSetting, experimentPars, cfsPars)
	xCenter = cfsPars.centerDomin(1) - cfsPars.xrangeMond/2 + ...
		rand(1, cfsPars.mondrianNumber).*(cfsPars.xrangeMond); %location
	yCenter = cfsPars.centerDomin(2) - cfsPars.yrangeMond/2 + ...
		rand(1, cfsPars.mondrianNumber).*(cfsPars.yrangeMond);

	X = ones(1, cfsPars.mondrianNumber).*cfsPars.minMond + ...
		rand(1, cfsPars.mondrianNumber).*cfsPars.sizeMond; %size
	Y = ones(1, cfsPars.mondrianNumber).*cfsPars.minMond + ...
		rand(1, cfsPars.mondrianNumber).*cfsPars.sizeMond;

	object = cat(1, zeros(1, cfsPars.mondrianNumber), zeros(1, cfsPars.mondrianNumber), X, Y);

	%color = 255*rand(3, mondrianNumber); % colorful Mondrian
	color = 255*repmat(rand(1, cfsPars.mondrianNumber),3,1); % gray scale Mondrian

	%Screen('FillRect', window ,color, CenterRectOnPoint(object,xcenter, ycenter));
	Screen('FillRect', initSetting.windowPtr, color, CenterRectOnPoint(object,xCenter, yCenter));
	%drawHolderFrame;

