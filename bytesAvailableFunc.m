function triggerRecCallBack(obj, event)

% This is set to initiate Serial callback function
%s.BytesAvailableFcnCount = 3; % Supposes to be 3, for example, '53' contains two bytes and one bytes for terminal signal
%s.BytesAvailableFcnMode = 'byte';
%s.BytesAvailableFcn = @instrcallback;
%

% Recording trigger in each trigger time stamp
global g
g.timeStampMx(1, g.triggerCounter) = GetSecs;
g.triggerCounter = g.triggerCounter + 1;

% Use handle, link Serial BytesAvailable to listener handle
