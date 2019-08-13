% Save Mondrian pattern as CenterRectOnPoint object (makeCase=1), or
% as rand matrices (makeCase=0)
function makeMondrians(initSetting, experimentPars, cfsPars)

	makeCase = 0;

	if makeCase == 1,

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

		%Screen('FillRect', initSetting.windowPtr, color, CenterRectOnPoint(object,xCenter, yCenter));

		for i = 1:cfsPars.nMondrianPatch,
			mondrianMatrices{i} = CenterRectOnPoint(object,xCenter, yCenter); %4x500
		end;

		% Save Mondrian Patch as CenterRectOnPoint
		save('mondrianMatrices.mat', 'mondrianMatrices'); % Loss color matrix

	elseif makeCase == 0,

		mondrianRandMatrices = cell(1,cfsPars.nMondrianPatch);
		for i = 1:cfsPars.nMondrianPatch,
			% Gray scale
			%mondrianRandMatrices{i} = rand(5, cfsPars.mondrianNumber);
			% Colorful
			mondrianRandMatrices{i} = rand(7, cfsPars.mondrianNumber);
		end;

		save('mondrianRandMatrices.mat', 'mondrianRandMatrices');
	end
