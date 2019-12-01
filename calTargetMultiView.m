function calImages = calTargetMultiView(varargin)

    % Input parser
    p = inputParser;

    % Add optional inputs
    addParameter(p, 'plot', true, @islogical); % SHOW IMAGES 
    addParameter(p, 'cameras', defaultCameraArrangement(), @isstruct); % Load the cameras % DONT TOUCH
    addParameter(p, 'targetOrigin', [0,0,0], @isnumeric); % ORIGIN % DONT TOUCH 
    addParameter(p, 'cal_dir', 'test/cal', @isstr); % Directory to Save files
    addParameter(p, 'save', false, @islogical); % Save files 
    addParameter(p, 'outbase', 'cam', @isstr); % File name 'Cam1.tif'
    addParameter(p, 'zeros', 1, @isnumeric); % filenames Best untouched 
    addParameter(p, 'extension', 'tif', @isstr); % File extension
    addParameter(p, 'TargetFile', false, @islogical); % Save Target file?
    addParameter(p, 'target_3D', false, @islogical); % WANT A 3D Target? %BETA 
    addParameter(p, 'plot_camera', false, @islogical); %SHOW CAMERA PLACMENT
    addParameter(p, 'make_axis', false ,@islogical); % DEBUG DIRECTION %DEV 
    addParameter(p, 'generate_ori', false, @islogical); % Generate ORI FILES FOR PTV
    % DONT TOUCH BELOW ----------------------------------------------%%%%
    % Parse the arguments
    parse(p, varargin{:});
    % cal image save
    cal_out = p.Results.cal_dir;
    saveImages = p.Results.save;
    out_base = p.Results.outbase;
    nZeros = p.Results.zeros;
    out_ext = p.Results.extension;
    % target file 
    MakeTargetFile = p.Results.TargetFile;
    target3D = p.Results.target_3D;
    Plot_camera = p.Results.plot_camera;
    % Generate ORI 
    Generate_ori = p.Results.generate_ori;
    % Make axis for debug 
    MakeAxis = p.Results.make_axis;
    % Results structure
    makePlots = p.Results.plot;

    % Get the cameras
    Cameras = p.Results.cameras;
    
    % Target origin
    targetOrigin = p.Results.targetOrigin;
   
    % Number of targets to render per camera
    nTargs = size(targetOrigin, 1);
    
    % Generate Ori 
    if Generate_ori
        Generate_ORI_files()
    end
    
    % Open a new figure
    if makePlots
        figure;
    end
    
    for k = 1 : length(Cameras)

        % Ger the current camera
        Camera = Cameras(k);
        
        % Create array for images
        imgArr = zeros(Camera.PixelRows, Camera.PixelColumns, nTargs, 'uint16');
        
        for n = 1 : nTargs

            % Get particle coordinates to render a calibration target
            [x,y,z, xc, yc, zc] = calibrationTarget('origin', targetOrigin(n, :),'target_3D',target3D,'make_axis',MakeAxis);

            % Create a normal distribution of particle diameters
            particleDiameters = sqrt(8) * ones(numel(x), 1);

            % Calculate particle max intensities from beam profile
            particleMaxIntensities = ones(numel(x), 1);
            
             % Calculate image coordinates
            [x_cam, y_cam] = pinholeTransform(x(:), y(:), z(:), getCameraMatrix(Camera));

            % Render the image and add noise
            particle_image = (...
                generateParticleImage(Camera.PixelRows, Camera.PixelColumns, ...
                  x_cam, y_cam, particleDiameters, particleMaxIntensities)) ...
                  + getSensorNoise(Camera);

            % Apply sensor gain and convert to uint16
            particle_image_uint16 = uint16(Camera.SensorGain * double(intmax('uint16')) * particle_image);

            % Save the image to the array of images
            imgArr(:, :, n) = particle_image_uint16;
            
        end

        % Save results to the output structure
        % calImages{k} = flipud(imgArr);
        % RAW OUT PUT NO FLIP FLIP
        calImages{k} = imgArr;

        % Plot the images
        if makePlots
            subtightplot(2, 2, k, [0.1, 0.1]);
            imagesc(imgArr(:, :, 1));
            axis image;
            set(gca, 'fontsize', 16);
            title(sprintf('Camera %d', k), 'interpreter', 'latex', 'fontsize', 20);
            colormap gray;
            caxis([0, intmax('uint16')]);
%             set(gca, 'ydir', 'normal');
            set(gca, 'xdir', 'Reverse');
            set(gcf, 'color', 'white');
        end
        
        
        out_dir = cal_out; %fullfile(cal_out, sprintf('Cam%d', k));
        if(~exist(out_dir, 'dir'))
            mkdir(out_dir);
        end
        fmtStr = sprintf('%%0%dd', nZeros);
        outNameFmt = sprintf('%s%s.%s', out_base, fmtStr, out_ext);
        
        % Where to save the image
        out_path = fullfile(out_dir, sprintf(outNameFmt, k));
        
        % Save the image
        if saveImages
            Eight_BIT = im2uint8(particle_image_uint16);%uint8(particle_image_uint16/256);
%             flip_image = flipud(Eight_BIT);
            flip_image = fliplr(Eight_BIT);
            imwrite(flip_image, out_path);
          
        end
        
    end
    % IF YOU DONT HAVE THE PACKAGES SET THESE TO FALSE
    if Plot_camera
        % adding if statment to check for package
        if exist('plotCamera')
            figure;
            plotCameraArrangement('Cameras', Cameras, 'points', [xc(:), yc(:), zc(:)]);
        else 
            % If plot camera function not found use free version
            figure;
            plotCameraArrangement2('Cameras', Cameras, 'points', [xc(:), yc(:), zc(:)]);
    end
    
    if MakeTargetFile
        [x,y,z, xc, yc, zc] = calibrationTarget('origin', targetOrigin(n, :),'target_3D',target3D,'make_axis',MakeAxis);
        %[x,y,z, xc, yc, zc] = calibrationTarget('origin', targetOrigin(n, :));
        count = 1:length(xc);
        M = [count',xc*1000,yc*1000,zc*1000];
%         dlmwrite('test2/cal/target_file.txt',M,'delimiter','\t');
        fil_name = [cal_out,'/target_file.txt'];
        dlmwrite(fil_name,M,'delimiter','\t');
    end
    % Draw the frame
    drawnow();


end




