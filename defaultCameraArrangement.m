function CAMERAS = defaultCameraArrangement()
   
%----  Camera positions  ----% 

    x_p = .05;  %METERS .2    % .2
    y_p = .05;  %METERS .2    % .2
    z_p = .2;   %METERS .8  % .95
%  Changed this up to have a little more random positions
%     tx = x_p * [-1, 1.01, -.95, .92];
%     ty = y_p * [1,  .99, -.99, -.85];
%     tz = z_p * [.98, .95, .92, 1];

    tx = x_p * [-1, 1, -1, 1];
    ty = y_p * [1,  1, -1, -1];
    tz = z_p * [1, 1, 1, 1];
    
%%% ---- DO NOT TOUCH BELOW ---- %%% 
    
    % Number of cameras
    nCameras = length(tx);
    
	 % Loop over cameras
    for k = 1 : nCameras 
        
        % Instantiate a camera 
        % with default parameters
        C = defaultCamera;
        
		% Populate Camera parameters
        C.Eye = [tx(k), ty(k), tz(k)];
		
        % Append to the structure
        CAMERAS(k) = C;
    end
end