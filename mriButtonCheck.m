function [pressed, pressT] = mriButtonCheck(experimentPars)
	% Receive Port input
	% Applying to Lumina response pad for response collection

	global resp g


	keyPress = 0;
	pressed = 0;
	pressT = zeros(1,255);
	if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
		keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
		if keyPress,
			tmp = GetSecs;

			% Recoding trigger time stamp in response period, reflecting synchronizing lag between trial and trigger
			if keyPress == experimentPars.mri.triggerCode,

				% Will induce problems while loops into functional ROI session %head
				%resp.main{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
				g.tStampTmp = tmp;
				%g.tCount = g.tCount + 1;
			else,

				pressT(keyPress) = tmp;
				pressed = 1;
			end;
		end;
	end;
