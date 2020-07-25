function makeImages(varargin)

% Seed the number generator
rng(1);

% Input parser
p = inputParser;

% Add optional inputs
addParameter(p, 'cameras', defaultCameraArrangement(), @isstruct);
addParameter(p, 'outdir', '.', @isstr);
addParameter(p, 'outbase', 'frame_1', @isstr);
addParameter(p, 'extension', 'tiff', @isstr);
addParameter(p, 'zeros', 4, @isnumeric);
addParameter(p, 'velocityFunction', @burgersVortex, @isFunctionHandle);
addParameter(p, 'xrange', [-0.006, 0.006]);
addParameter(p, 'yrange', [-0.006, 0.006]);
addParameter(p, 'zrange', [0.000, 0.003]);
addParameter(p, 'particleConcentration', 1.5e5, @isnumeric);
addParameter(p, 'tspan', linspace(0,0.01, 20), @isnumeric);
addParameter(p, 'particleDiameterMean', 1.5*sqrt(8), @isnumeric); % 1.5
addParameter(p, 'particleDiameterStdDev', 0.10 * sqrt(8), @isnumeric);
addParameter(p, 'beamStdDev', 0.05, @isnumeric);
addParameter(p, 'BeamPlaneZ', 0, @isnumeric);
addParameter(p, 'velocityFunctionParams', [], @isstruct);
addParameter(p, 'save', false, @islogical);
addParameter(p, 'plot', false, @islogical);
addParameter(p, 'write_to_work', false, @islogical);
addParameter(p, 'save_positions', true, @islogical);
addParameter(p, 'Use_Data_set', false, @islogical); % using existing data set 
addParameter(p, 'Data_set', [], @isstruct); % using exisiting data set pass in structure
% Parse the arguments
parse(p, varargin{:});

Data_set_use = p.Results.Data_set;
Existing_pos = p.Results.Use_Data_set;
Save_particle_trajectories = p.Results.save_positions;
Cameras = p.Results.cameras;
out_root = p.Results.outdir;
out_base = p.Results.outbase;
out_ext = p.Results.extension;
nZeros = p.Results.zeros;
velocityFunction = p.Results.velocityFunction;
xrange = p.Results.xrange;
yrange = p.Results.yrange;
zrange = p.Results.zrange;
particle_concentration = p.Results.particleConcentration;
tSpan = p.Results.tspan;
particle_diameter_mean = p.Results.particleDiameterMean;
particle_diameter_std = p.Results.particleDiameterStdDev;
beam_plane_std_dev = p.Results.beamStdDev;
beam_plane_z = p.Results.BeamPlaneZ;
velFnParams = p.Results.velocityFunctionParams;
saveImages = p.Results.save;
makePlots = p.Results.plot;
write_to_work = p.Results.write_to_work;

% Format string
fmtStr = sprintf('%%0%dd', nZeros);
outNameFmt = sprintf('%s%s.%s', out_base, fmtStr, out_ext);

testVolume = diff(xrange) * diff(yrange) * diff(zrange);
% disp the test volume 
disp(["test volume = ",num2str(testVolume),'m^3']) 
    
% This was giving me an error saying the value needed to be an interger
% which is was but it return e+03. Used int64 and all fixed. So SILLY
n_particles = int64(particle_concentration * testVolume);

% Disp the number of particles 
disp(['number of particles = ',num2str(n_particles)]);
if n_particles <= 10
    disp("number of particles to low. Increase Particle concentration");
    disp(['number of particles = ',num2str(n_particles)]);
end
% Create a normal distribution of particle diameters
particleDiameters = abs(particle_diameter_std * randn(n_particles, 1) ...
    + particle_diameter_mean);

% Discrete positions
xo = xrange(1) + (xrange(2) - xrange(1)) * rand(n_particles, 1);
yo = yrange(1) + (yrange(2) - yrange(1)) * rand(n_particles, 1);
zo = zrange(1) + (zrange(2) - zrange(1)) * rand(n_particles, 1);

% % Calculate the particle trajectories
% [X, Y, Z] = velocityFunction(xo, yo, zo, tSpan, velFnParams);



if Existing_pos
    X = Data_set_use.x ;
    Y = Data_set_use.y ;
    Z = Data_set_use.z ; 
    [ndim,mdim ] = size(X)
%     tSpan = ndim;  % IDK YET
    n_particles = mdim ; 
    particleDiameters = abs(particle_diameter_std * randn(n_particles, 1) ...
        + particle_diameter_mean);
    disp('Using exisitng data')
else 
    % Calculate the particle trajectories
    [X, Y, Z] = velocityFunction(xo, yo, zo, tSpan, velFnParams);
    disp('Generating new data')
end

% Save Particle Positions
if Save_particle_trajectories
    Particle_pos.x=X;
    Particle_pos.y=Y;
    Particle_pos.z=Z;
    dir_for_save = out_root(1:end-4);
    ext = '.mat';
    kk=0;
    file_name = 'Particle_pos';
    filename = sprintf('%s\\%s_%s',dir_for_save,file_name,ext)
    while exist(filename)
        kk = kk + 1;
        filename = sprintf('%s\\%s_%d%s',dir_for_save,file_name,kk,ext)
    end
    save(filename,'Particle_pos');
    disp('Saving generated dataset')
end



% Count the number of cameras
num_cameras = length(Cameras);

% Open a new figure
if makePlots
    figure;
end

% Loop over all the time steps
for t = 1 : length(tSpan)

    % [x,y,z] positions at this time point
    % in world coordinates (lab frame, meters)
    x = X(t, :);
    y = Y(t, :);
    z = Z(t, :);
    
    % Calculate particle max intensities from beam profile
    particleMaxIntensities = exp(-(z - beam_plane_z).^2 ./ ...
    (2 * beam_plane_std_dev ^ 2));

    % Inform the user
    fprintf('On frame %d of %d\n', t, length(tSpan));
    
    % Loop over cameras
    for k = 1 : num_cameras

        % Ger the current camera
        Camera = Cameras(k);
        
        % Calculate image coordinates
        [x_cam, y_cam] = pinholeTransform(x, y, z, getCameraMatrix(Camera));
        
        % Render the image and add noise
        particle_image = (...
            generateParticleImage(Camera.PixelRows, Camera.PixelColumns, ...
              x_cam, y_cam, particleDiameters, particleMaxIntensities)) ...
              + getSensorNoise(Camera);
        
        % Apply sensor gain
        particle_image_uint16 = uint16(Camera.SensorGain * double(intmax('uint16')) * particle_image);
        
        if makePlots        
            % Make a plot
            subtightplot(2, 2, k, [0.1, 0.1]);
            imagesc(particle_image_uint16);
            axis image;
            set(gca, 'fontsize', 16);
            title(sprintf('Camera %d', k), 'interpreter', 'latex', 'fontsize', 20);
            colormap gray;
            caxis([0, intmax('uint16')]);
            set(gcf, 'color', 'white');
            % this was missing , you can either flip image of set ydir
            % reverse
            set(gca, 'ydir', 'normal');
        end
        
%         % Output path
%         out_dir = fullfile(out_root, sprintf('Cam%d', k));
%         if(~exist(out_dir, 'dir'))
%             mkdir(out_dir);
%         end
%         
%         % Where to save the image
%         out_path = fullfile(out_dir, sprintf(outNameFmt, t));
        
        % Save the image % we shouldnt make the folders if we dont want to
        % save
        if saveImages
            out_dir = fullfile(out_root, sprintf('Cam%d', k));
            if(~exist(out_dir, 'dir'))
                mkdir(out_dir);
            end
            % Where to save the image
            out_path = fullfile(out_dir, sprintf(outNameFmt, t));
            Eight_BIT = uint8(particle_image_uint16/256);
            flip_image = fliplr(Eight_BIT);
            imwrite(flip_image, out_path);
%             imwrite(uint8(particle_image_uint16/256), out_path);
        end
       
            
%         if write_to_work
%             if k ==1
%                 if t ==1
%                     g.seq=uint8(particle_image_uint16/256);
%                     %disp('starting')
%                 else
%                     %disp('Appending')
%                     seq2=uint8(particle_image_uint16/256);
%                     g.seq = [g.seq ; seq2];
%                 end
%             else
%             end
%         end
%         
%     end
%     
    %Draw the frame
    drawnow();
%     ff=getframe;
%     g(t).seq=ff;
end

% implay(g.seq)


end




