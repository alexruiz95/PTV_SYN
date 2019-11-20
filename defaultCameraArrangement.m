function CAMERAS = defaultCameraArrangement()
   
    % Camera positions  % 
    % AR Adding these x_p y_p z_p I think the defaults where to high 
    x_p = .3;
    y_p = .3;
    z_p = 1;
    
    tx = x_p * [-1, 1, -1, 1];
    ty = y_p * [1,  1, -1, -.75];
    tz = z_p * [1, 1, 1, .75];
    
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