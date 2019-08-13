function response = setResponseKeys
	%http://ftp.tuebingen.mpg.de/pub/pub_dahl/stmdev10_D/Matlab6/Toolboxes/Psychtoolbox/PsychDocumentation/KbQueue.html
	%http://catlab.psy.vanderbilt.edu/palmeri/psy319/wp-content/uploads/Week11/Week11.pdf
	%[id,name] = GetKeyboardIndices;% get a list of all devices connected 
	%response.validResponseKeys  = [KbName('LeftArrow') KbName('RightArrow') KbName('Space') KbName('Escape')];
	response.validResponseKeys  = KbName({'LeftArrow', 'RightArrow', 'Space', 'Escape'});
	% interesting matrix, dig deeper
	response.validResponseKeyName = {'LeftArrow', 'RightArrow', 'Space', 'Escape'};
	response.keyList = zeros(1,256);
	response.keyList(response.validResponseKeys) = 1;
	KbQueueCreate([], response.keyList); %creates queue using defaults
	%PsychHID('KbQueueCreate', [],  response.keyList); % bug
	KbQueueStart; %starts the queue
	%KbQueueWait;
