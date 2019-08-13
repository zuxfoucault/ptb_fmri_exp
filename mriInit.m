function mri = mriInit(experimentPars)

	global g
	%% Hardware parameters
	mri.triggertype = experimentPars.triggertype;  % 0 = keyboard; 1 = Serial Port/Lumina

	% In terms of getResponse, try to open channels from both keyboard and response box
	mri.responsetype = experimentPars.responsetype;
	mri.boxport = 'COM6';
	mri.triggerCode = 53;
	mri.ansCode = [49 50 51 52]; % button 1..4

	% How to detect loss volumes ?


	g.timeStampMx = zeros(1,2); % Initial value for time stamp collecting message
	g.triggerCounter = 1; % Initial value


	% BytesAvailable code is still untested
	if mri.triggertype == 1 || mri.responsetype == 1,
		mri.s2=serial(mri.boxport, 'BaudRate', 19200, 'Databits', 8, 'StopBits', 1);
		%mri.s2.ReadAsyncMode = 'manual'; % Set if-gate or not?
		% This is set to initiate Serial callback function

		%readasync(experimentPars.mri.s2); % readasync mode; no purpose here
		s2.BytesAvailableFcnCount = 3; % Supposes to be 3, for example, '53' contains two bytes and one bytes for terminal signal
		s2.BytesAvailableFcnMode = 'byte';
		s2.BytesAvailableFcn = @triggerRecCallBack;
		fopen(mri.s2);


		g.timeStampMx = ones(1,2); % Initial value for time stamp collecting message
	end;




	%  %reference code
	%switch getResponse
	%    case {1} % luminar
	%        if(triggertype==4)
	%		else
	%            s2=serial(boxport,'BaudRate',19200,'Databits',8,'StopBits',1);
	%            fopen(s2);
	%		end
	%            AnsCode=[49 50 51 52]; % button 1..4
	%    case {2} % keyboard
	%        AnsCode=[49 50 51 52]; % key 1 2 3 4
	%end %switch
	%
	%switch GetResponse
	%    case {1} % luminar
	%        s2=serial(boxport,'BaudRate',19200,'Databits',8,'StopBits',1);
	%        fopen(s2);
	%        AnsCode=[49 50 51 52]; % button 1..4
	%    case {2} % keyboard
	%        AnsCode=[49 50 51 52]; % key 1 2 3 4
	%end %switch

	% Installing a USB Serial Adapter on Mac OS X
	%http://plugable.com/2011/07/12/installing-a-usb-serial-adapter-on-mac-os-x
