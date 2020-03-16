
% It is recommend to compile your own mex c function. To do this 
% Delete:      generateParticleImage.mexw64

% Then run compile_generateParticleImage() 
% This will compile the C code
% only need to do this once

% add paths 
addpath('plotting_camera');
addpath('ptvcodes');
addpath('test');


% Generate the calibration Images  
% Same for all data 
calTargetMultiView('save',true,'cal_dir','test/cal','TargetFile', true,'target_3D',true,'generate_ori', true)
% This code will save the images to the specified directory, create a
% target file, generate the ori files for a 3D calibration plate


% Generate the ORI Files for initial guess (exact) Manually with 
% Generate_ORI_files()
% NOTE: CalTartMultiView Takes care of this

% Make the images
% For analytical case Burgers vortex use:
% makeImages2('outdir','test/img','save',true,'plot',true);
% For turbulent data USE:
makeImages3('outdir','test/img','save',true,'plot',true);


% Remove the tiff heading using python
system('py remove_tif.py test/img/Cam1');
system('py remove_tif.py test/img/Cam2');
system('py remove_tif.py test/img/Cam3');
system('py remove_tif.py test/img/Cam4');
% or matlab
remove_tif_M

% RUN PTV
% Perform Calibration 
% Note: In the calibration process you will notice that you will not be able to click “Fine tuning” after selecting “Raw orientation”. 
% In order to overcome this bug you will need to perform these steps after selecting “ Raw Orientation” :
% 1.	Click: Select Orient. With file
% 2.	Click: Show initial guess
% 3.	Click: Sortgrid
% 4.	Click: Raw orientation % after this the finetuning button will activate
% 5.	Click: Fine tuning 
% It should work after this.


% Perform Tracking 

% Post Processsing 
% In the PTVCODES run the code run_this.m to inspect the tracks

% -------------- % 
% PARAMS.g = 5;
% PARAMS.a = 1;
% PARAMS.m = 1e-6;
% makeImages2('outdir','test2/img','save',true,'plot',true,'velocityFunctionParams',PARAMS,'velocityFunction', @burgersVortex,'zrange', [-.1,.1],'particleDiameterMean', 1.5*sqrt(8),'particleConcentration', 1.5e4)
