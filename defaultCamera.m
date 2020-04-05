function CAMERA = defaultCamera()

    % Instantiate an empty structure to
    % hold the camera parameters
    CAMERA = struct();
        
    % Populate  Camera parameters
    CAMERA.FocalLength      = 0.205;   % Meters Usually .105
    CAMERA.PixelHeight      = 1.7E-5;  % Meters 0.0065 mm
    CAMERA.PixelWidth       = 1.7E-5;  % Meters
    CAMERA.PixelRows        = 1024;    % Pixels
    CAMERA.PixelColumns     = 1024;    % Pixels
    CAMERA.SensorNoiseStd   = 0.05;    % Fraction of saturation intensity 0.05
    CAMERA.SensorNoiseMean  = 0.05;    % Fraction of saturation intensity 0.15
    CAMERA.SensorGain       = 0.6;     % Unitless 0.6
 %--% DO NOT TOUCH THESE UNLESS YOU KNOW WHAT YOU ARE DOING %--%
    CAMERA.Eye              = [0,0,1]; % Meters
    CAMERA.Center           = [0,0,0]; % Meters
    CAMERA.Up               = [0,1,0]; % Unit vector    
end



