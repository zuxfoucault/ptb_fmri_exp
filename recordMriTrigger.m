function recordMriTrigger(experimentPars)

	global resp g
	% Recording trigger time
	if experimentPars.mriHook,

		readasync(experimentPars.mri.s2); %  readasync mode
		if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
			keyPress = fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
			if keyPress == experimentPars.mri.triggerCode, %remember to set up ignore 53 in get response
				tmp = GetSecs;

				%  Switch to different recording cell
				%  Case 3: regular session, Case 4: functional ROI
				switch g.session,
					case 3,
						resp.main{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
						if g.tCount == 1,
							resp.main{resp.iBlock}.tbStamp = tmp; % Recording trigger time stamp (block-wise)
						end;

					case 4,
						resp.functional{resp.iBlock}.tStamp(g.tCount) = tmp;
						if g.tCount == 1,
							resp.functional{resp.iBlock}.tbStamp = tmp; 
						end;


				end;
				g.tCount = g.tCount + 1;
			end;
		end;

	end;
	%return 999


