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
work_dir = 'JHU';

% Working calibration folder 
% 'working_folder_name/cal'
cal_dir = [work_dir,'/cal'];
% Generate the calibration Images  
% Same for all data 
calTargetMultiView('save',true,'cal_dir',cal_dir,'TargetFile', true,'target_3D',true,'generate_ori', true)

% This code will save the images to the specified directory, create a
% target file, generate the ori files for a 3D calibration plate


% Generate the ORI Files for initial guess (exact) Manually with 
Generate_ORI_files('ori_dir',cal_dir)
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

%---------------% REMOVE TIFF HEADER WITHT HIS FUNCTION %---------------%
remove_tif_M(img_dir)

%---------------------------% RUN PTV %-----------------------------------%
% Perform Calibration 
% Note: In the calibration process you will notice that you will not be able to click “Fine tuning” after selecting “Raw orientation”. 
% In order to overcome this bug you will need to perform these steps after selecting “ Raw Orientation” :
% 1.	Click: Select Orient. With file
% 2.	Click: Show initial guess
% 3.	Click: Sortgrid
% 4.	Click: Raw orientation % after this the finetuning button will activate
% 5.	Click: Fine tuning 
% It should work after this.



%----------------------% Perform Tracking %-------------------------------%

%----------------------% Post Processsing %-------------------------------%
% In the PTVCODES run the code run_this.m to inspect the tracks

test=['C:\Users\alex\Desktop\og\PTV_SYN\',work_dir,'\res'];
% test='C:\Users\alex\Desktop\og\PTV_SYN\test\Copy_of_res';
start = 10001;
last = 10075;
dt=1/100;
min_len = 5;
%------

% main = 'C:\Users\alex\OneDrive - Knights - University of Central Florida\Documents\research_xray\CODE_MAIN\TEST DATA FOR PTV\';
% folder = fullfile(main,test,'res0');

traj_RC=ptv_is_to_traj(test,start,last,min_len,dt);
plot_long_trajectories(traj_RC,min_len);
v = [10 -8 2];
[caz,cel] = view(v)
title('Turbulent Flow- Reconstruction')
% saveas(gcf,'figure\turb_flow_reconstruct.png')

% Ground TRUTH DATA
% Load the data 
% clear all
% close all
load('test.mat')
N_TRAJ = 100 ;
dt=1/100;
min_len = 2;
for time = 1:75
        X(time,:) = x(time,1:N_TRAJ,1);
        Y(time,:) = x(time,1:N_TRAJ,2);
        Z(time,:) = x(time,1:N_TRAJ,3);
end

% FIRST MULT BY .01 to scale from [cm] to [m]
X=.01*X;
Y=.01*Y;
Z=.01*Z;
% SHIFT POINTS 
X1 = (X - mean(mean(X)));
Y1 = (Y - mean(mean(Y)));
Z1 = (Z - min(min(Z)));
% PLOT
% plot3(X1,Y1,Z1,'.')
% xlabel('x');ylabel('y');zlabel('z')
traj_GT = pos_to_traj(X1,Y1,Z1,dt);
% % traj_GT_mm = pos_to_traj(X1./1000,Y1./1000,Z1./1000,dt)
% plot_long(traj_GT,min_len)
% plot_long_trajectories(traj_GT,min_len)
set(gca,'xdir','reverse')
set(gca, 'ydir', 'reverse')
set(gca, 'zdir', 'normal')
title('Turbulent Flow-Ground Truth')
% saveas(gcf,'turb_flow_GT.png')


% COMPARE THE TWO PLOTS 
plot_long_traject_COP(traj_GT,'Ground Truth [m]',traj_RC,'Reconstruction [mm]',min_len)

%------------------------------------------------

% [Image] = makeImages3;
% implay(Image(:,:,:,:,1))

%-dep-%
% -------------- % 
% PARAMS.g = 5;
% PARAMS.a = 1;
% PARAMS.m = 1e-6;
% makeImages2('outdir','test2/img','save',true,'plot',true,'velocityFunctionParams',PARAMS,'velocityFunction', @burgersVortex,'zrange', [-.1,.1],'particleDiameterMean', 1.5*sqrt(8),'particleConcentration', 1.5e4)

%
%text_2_disp = ['X-Range:',num2str([min(X1(:)),max(X1(:))]),'; Y-Range:',num2str([min(Y1(:)),max(Y1(:))]),'; Z-Range:',num2str([min(Z1(:)),max(Z1(:))])];
%disp(text_2_disp)