function calImages = calTargetMultiView_3(varargin)

    % Input parser
    p = inputParser;

    % Add optional inputs
    addParameter(p, 'plot', true, @islogical);
    addParameter(p, 'cameras', defaultCameraArrangement(), @isstruct);
    addParameter(p, 'targetOrigin', [0,0,0], @isnumeric);
    addParameter(p, 'cal_dir', 'test/cal', @isstr);
    addParameter(p, 'save', true, @islogical);
    addParameter(p, 'outbase', 'cam', @isstr);
    addParameter(p, 'zeros', 1, @isnumeric);
    addParameter(p, 'extension', 'tif', @isstr);
    % Parse the arguments
    parse(p, varargin{:});
    
    % cal image save
    cal_out = p.Results.cal_dir;
    saveImages = p.Results.save;
    out_base = p.Results.outbase;
    nZeros = p.Results.zeros;
    out_ext = p.Results.extension;
    % Results structure
    makePlots = p.Results.plot;

    % Get the cameras
    Cameras = p.Results.cameras;
    
    % Target origin
    targetOrigin = p.Results.targetOrigin;
   
    % Number of targets to render per camera
    nTargs = size(targetOrigin, 1);
    
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
            [x,y,z, xc, yc, zc] = calibrationTarget_3('origin', targetOrigin(n, :));

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
            set(gca, 'ydir', 'normal');
            set(gcf, 'color', 'white');
           
%             direct = ['test\cal\cam',num2str(k),'.tif'];
%             imwrite(calImages{k}, direct);

            
        end
        % Output path
        %fullfile(cal_out, sprintf('Cam%d', k));
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
            Eight_BIT = uint8(particle_image_uint16);
            flip_image = flipud(Eight_BIT);
            imwrite(flip_image, out_path);
        end
    
    end

%     if makePlots
%         figure;
%         plotCameraArrangement('Cameras', Cameras, 'points', [xc(:), yc(:), zc(:)]);
%     end
    
    %Draw the frame
    drawnow();
    



end



