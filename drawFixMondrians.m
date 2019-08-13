% Support fix Mondrian pattern
function drawFixMondrians(initSetting, experimentPars, cfsPars)

	global g

	if cfsPars.fixMondrianPattern == 0,
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

		%Screen('FillRect', initSetting.windowPtr ,color, CenterRectOnPoint(object,xcenter, ycenter));
		Screen('FillOval', initSetting.windowPtr, color, CenterRectOnPoint(object,xCenter, yCenter));


	elseif cfsPars.fixMondrianPattern == 1,

		i = mod(g.mondCount, 10) + 1;
		g.mondCount = g.mondCount + 1;
		%disp(i) % For testing

		xCenter = cfsPars.centerDomin(1) - cfsPars.xrangeMond/2 + ...
			cfsPars.mondrianRandMatrices{i}(1,1:cfsPars.mondrianNumber) ...
			.*(cfsPars.xrangeMond); %location
		yCenter = cfsPars.centerDomin(2) - cfsPars.yrangeMond/2 + ...
			cfsPars.mondrianRandMatrices{i}(2,1:cfsPars.mondrianNumber) ...
			.*(cfsPars.yrangeMond);

		X = ones(1, cfsPars.mondrianNumber).*cfsPars.minMond + ...
			cfsPars.mondrianRandMatrices{i}(3,1:cfsPars.mondrianNumber) ...
			.*cfsPars.sizeMond; %size
		Y = ones(1, cfsPars.mondrianNumber).*cfsPars.minMond + ...
			cfsPars.mondrianRandMatrices{i}(4,1:cfsPars.mondrianNumber) ...
			.*cfsPars.sizeMond;

		object = cat(1, zeros(1, cfsPars.mondrianNumber), zeros(1, cfsPars.mondrianNumber), X, Y);

		%color = 255*rand(3, cfsPars.mondrianNumber); % colorful Mondrian
		color = 255*cfsPars.mondrianRandMatrices{i}(5:7,:);

		% Gray scale
		%color = 255*repmat(...
			%cfsPars.mondrianRandMatrices{i}(5,1:cfsPars.mondrianNumber),3,1); % gray scale Mondrian

		%Screen('FillRect', window ,color, CenterRectOnPoint(object,xcenter, ycenter));
		%Screen('FillRect', initSetting.windowPtr, color, CenterRectOnPoint(object,xCenter, yCenter));
		% Oval pattern
		Screen('FillOval', initSetting.windowPtr, color, CenterRectOnPoint(object,xCenter, yCenter));
	end;

