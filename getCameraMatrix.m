function [CAMERA_MATRIX, R, t] = getCameraMatrix(Camera)
		
    % Focal length in meters
    f = Camera.FocalLength;

    % Number of pixels
    image_rows = Camera.PixelRows;
    image_cols = Camera.PixelColumns;

    % Pixel sizes in meters
    pixel_width_m  = Camera.PixelWidth;
    pixel_height_m = Camera.PixelHeight;
    
    % Extrinsic matrix
    [extrinsic_matrix, R, t] = cameraLookAtToExtrinsic(Camera.Eye, Camera.Center, Camera.Up);

    % Sensor offsets
    xc = image_cols * pixel_width_m / 2;
    yc = image_rows * pixel_height_m / 2;

    % Pixel size
    % Just renaming so the code is legible
    pw = pixel_width_m;
    ph = pixel_height_m;

    % Form the intrinsic matrix
    % The sign on the focal length term
    % is positive to flip the image into
    % image coordinates
    intrinsic_matrix = [f / pw, 0, xc / pw, 0;  ...
                        0, f / ph ,yc / ph, 0;  ...
                        0, 0, 1, 0; ...
                        0, 0, 0, 1];
                    
    % Calculate the entire camera matrix
    % by multiplying the intrinsic and extrinsic
    % camera matrices.
    CAMERA_MATRIX = intrinsic_matrix * extrinsic_matrix;

end

    % Lets add lens distortion 
    % https://www.uio.no/studier/emner/matnat/its/nedlagte-emner/UNIK4690/v16/forelesninger/lecture_5_3_camera_calibration.pdf
    
%     radial_distort = false ;
%     barrel_distort = true ; 
%     if radial_distort
%         % What should these values be ?
%         % Radial Distortion Values 
%         k1 = -.000035 ; 
%         k2 = 1 ;
%         % Radial Distortion 
%         xc1 = xc*(1 + k1*(xc.^2 + yc.^2) + k2*(xc.^2 + yc.^2).^2)
%         yc1 = yc*(1 + k1*(xc.^2 + yc.^2) + k2*(xc.^2 + yc.^2).^2)
%         disp('YES Radial DISTORT')
%         end
%         % Barrel Distort 
%     if barrel_distort
%         % Eqns for barrel distortion 
%         distort_coeff1 = .5 ; 
%         distort_coeff2 = .5 ; 
%         r_old = sqrt(xc.^2 + yc.^2);
%         xc1 =  xc.*(1 + distort_coeff1 * r_old.^2);
%         yc1 = yc.*(1 + distort_coeff2 * r_old.^2);
%         disp('YES barrel DISTORT')
%     end
%     % Assign to OG coef 
%     xc = xc1 ; 
%     yc = yc1 ; 
% %         
%         if pincushion_distort
%             % Egns for pincushion distort 
%         end
        
   
%     end
%     
