% It is recommend to compile your own mex c function. To do this 
% Delete:      generateParticleImage.mexw64

% Then run compile_generateParticleImage() 
% This will compile the C code
% only need to do this once

% add paths 
addpath('plotting_camera');
addpath('ptvcodes');
addpath('test');

% SPECIFY INPUT REQUIRED
% Working folder
work_dir = 'test';

% Working calibration folder 
% 'working_folder_name/cal'
cal_dir = [work_dir,'/cal]';
% Generate the calibration Images  
% Same for all data 
calTargetMultiView('save',true,'cal_dir',cal_dir,'TargetFile', true,'target_3D',true,'generate_ori', true)
% This code will save the images to the specified directory, create a
% target file, generate the ori files for a 3D calibration plate


% Generate the ORI Files for initial guess (exact) Manually with 
% Generate_ORI_files()
% NOTE: CalTartMultiView Takes care of this

% Make the images
%--------------% For analytical case Burgers vortex use: %-------------%
% img_dir  = [work_dir,'/img'];
% if exist(img_dir)
% % Remove the exiting img folder
%     disp('exist')
%     rmdir(img_dir,'s')
%     disp('Removed')
% end
% makeImages2('outdir',img_dir,'save',true,'plot',true);

%----------------------% For turbulent data USE: %------------------------%
% WORKING folder followed by directory  
img_dir  = [work_dir,'/img'];
if exist(img_dir)
% Remove the exiting img folder
    disp('exist')
    rmdir(img_dir,'s')
    disp('Removed')
end

makeImages3('outdir',img_dir,'save',true,'plot',true);

% REMOVE TIFF HEADER WITHT HIS FUNCTION
remove_tif_M(img_dir)

% RUN PTV
% Perform Calibration 
% Note: In the calibration process you will notice that you will not be able to click �Fine tuning� after selecting �Raw orientation�. 
% In order to overcome this bug you will need to perform these steps after selecting � Raw Orientation� :
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
