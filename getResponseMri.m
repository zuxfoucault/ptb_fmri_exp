function resp = getResponseMri(experimentPars)

	KbQueueFlush;
	startTime = GetSecs; %or previous vbl
	stopTime = startTime + experimentPars.durIbi; %need set predefine variable in setExperimentPars.IBI
	%while ~pressed,
	i = 1; % Key sequence
	j = 1;

	while GetSecs <= stopTime, % Fixed response duration

		if experimentPars.responsetype,
			[pressed, firstPressT] = mriButtonCheck(experimentPars);
			escapeKey(firstPressT);

			if pressed,
				firstPressT(find(firstPressT==0)) = NaN; %little trick to get rid of 0s
				[pressTime keyCode] = min(firstPressT); % gets the RT of the first key-press and its ID
				resp.keyCodeMri(1,j) = keyCode;
				resp.respTimeMri(1,j) = pressTime - startTime;
				j = j + 1;
			end;
		end;

		[pressed, firstPressT] = KbQueueCheck; %check if any key was pressed.
		escapeKey(firstPressT);

		if pressed,
			firstPressT(find(firstPressT==0)) = NaN; %little trick to get rid of 0s
			[pressTime keyCode] = min(firstPressT); % gets the RT of the first key-press and its ID
			resp.keyCode(1,i) = keyCode;
			resp.respTime(1,i) = pressTime - startTime;
			i = i + 1;
		end;

		%WaitSecs(0.01); % It is a good habit not to poll as fast as possible
	end;

	if i == 1, % validate keys does not have been touched
		resp.keyCode = 999;
		resp.respTime = 999;
	end;

	if j == 1, % validate keys does not have been touched
		resp.keyCodeMri = 999;
		resp.respTimeMri = 999;
	end;
