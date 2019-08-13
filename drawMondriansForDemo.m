clear all;
sca;
PsychJavaTrouble;
fclose all;
Screen('Preference', 'SkipSyncTests', 3);
screenNumber = max(Screen('Screens'));
[resx, resy] = Screen('WindowSize',screenNumber);
[mmx, mmy] = Screen('DisplaySize', screenNumber); cmx = mmx/10; cmy = mmy/10;
hz = Screen('FrameRate', screenNumber, []);
viewdist = 65;
cmToPix = (resx/cmx);
degToPix = ceil(tan(2*pi/360)*(viewdist*cmToPix));

[window, screenRect] = Screen('OpenWindow',screenNumber,0,[],[],2);
ifi = Screen('GetFlipInterval', window); %The returned monitorRefreshInterval is in seconds. ifi == fPeriod.
black = BlackIndex(window);
white = WhiteIndex(window);
mondrianContrast = 0.1;
mondrianPatchDisplaySize = 25;
backgroundEntry = (black+white)/2;
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen(window,'FillRect', backgroundEntry);

% Mondrians 
minMond = .3*degToPix; %minimal size
sizeMond = 3.5*degToPix; %variating range of a single mondrian
mondrianPatchDisplaySize = 40; %mondrian path display size
xrangeMon = mondrianPatchDisplaySize*degToPix/2;
yrangeMon = mondrianPatchDisplaySize*degToPix/2;
tmpNumber = 600; %Mondrian number per frame
center = screenRect(3:4)/2

for i = 1:10,
	xCenter = center(1) - xrangeMon/2 + rand(1, tmpNumber).*(xrangeMon); %location
	yCenter = center(2) - yrangeMon/2 + rand(1, tmpNumber).*(yrangeMon);
	X = ones(1, tmpNumber).*minMond + rand(1, tmpNumber).*sizeMond; %size
	Y = ones(1, tmpNumber).*minMond + rand(1, tmpNumber).*sizeMond;
	object = cat(1, zeros(1, tmpNumber), zeros(1, tmpNumber), X, Y);
	%color = 255*rand(3, tmpNumber); % colorful Mondrian
	color = 255*repmat(rand(1, tmpNumber),3,1); % gray scale Mondrian
	Screen('FillRect', window ,color, CenterRectOnPoint(object,xCenter, yCenter));

	tvbl = Screen('Flip', window);

	capture = 0; %screen capture or not
	if capture,
		captureFrame = captureFrame+1;
		monfilename = ['mondrian',num2str(captureFrame),'.png'];
		imageArray=Screen('GetImage', window);
		imwrite(imageArray,monfilename,'png');
	end;

	WaitSecs(.1);
end;
Screen('CloseAll');
clear mex;
