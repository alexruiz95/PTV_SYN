
% clear all

% Generate the calibration Images     
% 
calTargetMultiView('save',true,'cal_dir','test2/cal','TargetFile', true,'target_3D',true,'generate_ori', true)
% This code will save the images to the specified directory, create a
% target file, generate the ori files for a 3D calibration plate


% Generate the ORI Files for initial guess (exact) Manually with 
% Generate_ORI_files()

% Make the images
makeImages2('outdir','test2/img','save',true,'plot',true);


% Remove the tiff heading 
system('py remove_tif.py test2/img/Cam1');
system('py remove_tif.py test2/img/Cam2');
system('py remove_tif.py test2/img/Cam3');
system('py remove_tif.py test2/img/Cam4');

% RUN PTV
% Perform Calibration 
% Perform Tracking 

% Post Processsing 
% In the PTVCODES run the code run_this.m to inspect the tracks


% PARAMS.g = 5;
% PARAMS.a = 1;
% PARAMS.m = 1e-6;
% makeImages2('outdir','test2/img','save',true,'plot',true,'velocityFunctionParams',PARAMS,'velocityFunction', @burgersVortex,'zrange', [-.1,.1],'particleDiameterMean', 1.5*sqrt(8),'particleConcentration', 1.5e4)
