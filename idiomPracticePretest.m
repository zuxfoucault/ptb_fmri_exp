function idiomPracticePretest(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont)

	% Inherit from regularSession.m

	global resp g
	resp.iBlock = 1; % Regular session index
	
	experimentPars.runs = 1; % For pretest

	g.session = 4;

	[dump characterSeq] = latsq(experimentPars.nCondition);
	% Column: sequence of list in which condition. #1 in the list refer to 1:40 idioms; 2 to 41:80 ... Row: each run.
	resp.characterSeq = characterSeq;

	for iRun = 1:experimentPars.runs, %runs; experimentPars.runs
		resp.iRun = iRun;
		[dump blockSeq] = latsq(experimentPars.nCondition);
		% Column: sequence of condition in each repetition. List number same as switch-case number. Row: each repetition.
		resp.blockSeq{iRun} = blockSeq;
		resp.blockSeqRegular{iRun} = blockSeq; % For record


		% Switch for in-block idiom or out-block idiom in regular session
		idiomSeq = Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2));
		idiomSaladSeq = Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2));
		idiomImpoSeq = Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2));
		idiomSaladImpoSeq = Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2));
		g.testIdiomCondition{iRun} = {idiomSeq idiomSaladSeq idiomImpoSeq idiomSaladImpoSeq};
		resp.testIdiomCondition{iRun} = g.testIdiomCondition{iRun};


		for iBlockRepe = 1:experimentPars.nBolckRepetitionInRun,

			resp.iBlockRepe = iBlockRepe;

			while resp.iBlock <= iBlockRepe*experimentPars.nCondition*resp.iRun
				switch blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)),
					%switch 1 %test contrast degrading
					case 1,
						%blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)); %for check
						%characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)))
						idiomL = idiomListShuffled.idiom((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);

						idiomBlock(initSetting, experimentPars, cfsPars, idiomL, experimentFont);

					case 2,
						idiomS = idiomListShuffled.saladList((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomBlock(initSetting, experimentPars, cfsPars, idiomS, experimentFont);%salad

					case 3,
						idiomL = idiomListShuffled.idiom((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomImposeBlock(initSetting, experimentPars, cfsPars, idiomL, experimentFont);

					case 4,
						idiomS = idiomListShuffled.saladList((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomImposeBlock(initSetting, experimentPars, cfsPars, idiomS, experimentFont);

					otherwise,
						disp('Switch-case error in regular session!');
				end;
			end;
		end;


		% How long to rest 
		%restStart = GetSecs;
		%tmp = 0;
		%restDuration = 60; % Resting duration
		%while GetSecs <= restStart + restDuration,
		%	%tmp = GetSecs; %here
		%	pause(1)
		%end;
		Screen('Flip', initSetting.windowPtr);
		%Screen('DrawText', initSetting.windowPtr, 'Ready?', cfsPars.centerNDomin(1) - experimentFont.toCenter, cfsPars.centerNDomin(2) - experimentFont.toCenter, experimentFont.textColor);
		%if iRun < experimentPars.runs
		%	Screen('TextSize', initSetting.windowPtr, experimentFont.textSizeIBI);
		%	DrawFormattedText(initSetting.windowPtr, 'Ready?', cfsPars.centerDomin(1) - ...
		%		experimentFont.textIBIOffSet, cfsPars.centerNDomin(2) - experimentFont.textIBIOffSet + ...
		%		experimentFont.testIdiomOffSet, 0, 40, [], [], 1.5, []);
		%	Screen('Flip', initSetting.windowPtr);
		%	KbQueueWait; %here for formal experiment IRI
		%end;
		Screen('TextSize', initSetting.windowPtr, experimentFont.textSizeIBI);
		DrawFormattedText(initSetting.windowPtr, 'End, Thank you for participating!', cfsPars.centerDomin(1) - ...
		experimentFont.textIBIOffSet, cfsPars.centerNDomin(2) - experimentFont.textIBIOffSet + ...
		experimentFont.testIdiomOffSet, 0, 40, [], [], 1.5, []);
		Screen('Flip', initSetting.windowPtr);
		KbQueueWait; %here for formal experiment IRI
	end;

	% Then prepare for functional ROI
%
%
%
%
%
%
%
%
%
%
%
%
%	global resp g
%
%	resp.iblock = 1; % regular session index
%
%	g.session = 2;
%
%	[dump characterseq] = latsq(experimentpars.ncondition);
%	% column: sequence of list in which condition. #1 in the list refer to 1:40 idioms; 2 to 41:80 ... row: each run.
%	resp.characterseq = characterseq;
%	
%	experimentpars.runs = experimentpars.runspretest; % just for practice trial
%
%
%	for irun = 1:experimentpars.runs, %runs; experimentpars.runs
%		resp.irun = irun;
%		[dump blockseq] = latsq(experimentpars.ncondition);
%		% column: sequence of condition in each repetition. list number same as switch-case number. row: each repetition.
%		resp.blockseq{irun} = blockseq;
%		resp.blockseqregular{irun} = blockseq; % for record
%
%
%		% switch for in-block idiom or out-block idiom in regular session
%		idiomseq = shuffle(repmat([0,1],1,experimentpars.nbolckrepetitioninrun/2));
%		idiomsaladseq = shuffle(repmat([0,1],1,experimentpars.nbolckrepetitioninrun/2));
%		idiomimposeq = shuffle(repmat([0,1],1,experimentpars.nbolckrepetitioninrun/2));
%		idiomsaladimposeq = shuffle(repmat([0,1],1,experimentpars.nbolckrepetitioninrun/2));
%		g.testidiomcondition{irun} = {idiomseq idiomsaladseq idiomimposeq idiomsaladimposeq};
%		resp.testidiomcondition{irun} = g.testidiomcondition{irun};
%
%
%		for iblockrepe = 1:experimentpars.nbolckrepetitioninrun,
%
%			resp.iblockrepe = iblockrepe;
%
%			while resp.iblock <= iblockrepe*experimentpars.ncondition*resp.irun
%				switch blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition)),
%					%switch 1 %test contrast degrading
%					case 1,
%						%blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition)); %for check
%						%characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition)))
%						idioml = idiomlistshuffled.idiom((characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition))) - 1)*experimentpars.nbolckrepetitioninrun*experimentpars.ntrialinbolck + 1 + (iblockrepe - 1)*experimentpars.ntrialinbolck:(characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition))) - 1)*experimentpars.nbolckrepetitioninrun*experimentpars.ntrialinbolck + iblockrepe*experimentpars.ntrialinbolck,:);
%
%						%idiomnomaskpretest(initsetting, experimentpars, cfspars, idioml, experimentfont);
%						idiomblockpretest(initsetting, experimentpars, cfspars, idioml, experimentfont);
%
%					case 2,
%						idioms = idiomlistshuffled.saladlist((characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition))) - 1)*experimentpars.nbolckrepetitioninrun*experimentpars.ntrialinbolck + 1 + (iblockrepe - 1)*experimentpars.ntrialinbolck:(characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition))) - 1)*experimentpars.nbolckrepetitioninrun*experimentpars.ntrialinbolck + iblockrepe*experimentpars.ntrialinbolck,:);
%						idiomblockpretest(initsetting, experimentpars, cfspars, idioms, experimentfont);%salad
%
%					case 3,
%						idioml = idiomlistshuffled.idiom((characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition))) - 1)*experimentpars.nbolckrepetitioninrun*experimentpars.ntrialinbolck + 1 + (iblockrepe - 1)*experimentpars.ntrialinbolck:(characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition))) - 1)*experimentpars.nbolckrepetitioninrun*experimentpars.ntrialinbolck + iblockrepe*experimentpars.ntrialinbolck,:);
%						idiomimposepretest(initsetting, experimentpars, cfspars, idioml, experimentfont);
%
%					case 4,
%						idioms = idiomlistshuffled.saladlist((characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition))) - 1)*experimentpars.nbolckrepetitioninrun*experimentpars.ntrialinbolck + 1 + (iblockrepe - 1)*experimentpars.ntrialinbolck:(characterseq(irun, blockseq(iblockrepe, 1 + rem((resp.iblock - 1), experimentpars.ncondition))) - 1)*experimentpars.nbolckrepetitioninrun*experimentpars.ntrialinbolck + iblockrepe*experimentpars.ntrialinbolck,:);
%						idiomimposepretest(initsetting, experimentpars, cfspars, idioms, experimentfont);
%
%					otherwise,
%						disp('switch-case error in regular session!');
%				end;
%			end;
%		end;
%
%
%		% how long to rest 
%		%reststart = getsecs;
%		%tmp = 0;
%		%restduration = 60; % resting duration
%		%while getsecs <= reststart + restduration,
%		%	%tmp = getsecs; %here
%		%	pause(1)
%		%end;
%		screen('flip', initsetting.windowptr);
%		%screen('drawtext', initsetting.windowptr, 'ready?', cfspars.centerndomin(1) - experimentfont.tocenter, cfspars.centerndomin(2) - experimentfont.tocenter, experimentfont.textcolor);
%		screen('textsize', initsetting.windowptr, experimentfont.textsizeibi);
%		drawformattedtext(initsetting.windowptr, 'end, thank you for participating!', cfspars.centerdomin(1) - ...
%		experimentfont.textibioffset, cfspars.centerndomin(2) - experimentfont.textibioffset + ...
%		experimentfont.testidiomoffset, 0, 40, [], [], 1.5, []);
%		screen('flip', initsetting.windowptr);
%		kbqueuewait; %here for formal experiment iri
%	end;
%
%	% then prepare for functional roi
