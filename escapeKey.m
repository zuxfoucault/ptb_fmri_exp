function escapeKey(firstPress)
	% execute Escape and save temporary data
	global debug baseName resp
	if firstPress(KbName('Escape')), %Abort for emergency!
		%disp('Esc pressed! Abort!');
		%dataSheet = cat(2, lTestMeanSizesList, response, visibilityResp, trialSeqAll);
		if debug == 0,
			baseNameTmp = [baseName '_tmp' ];
			%save(baseNameTmp, 'resp');
			save(baseNameTmp);
		end;
		%sca;
		%%break;
		%return;
		error('Esc pressed! Abort!');
	end;
