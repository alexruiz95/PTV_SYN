
% clear all


% Generate the calibration Images                
calImages = calTargetMultiView('save',false,'cal_dir','test/cal','TargetFile', true,'target_3D',false)


% Generate the ORI Files for initial guess (exact) 
Generate_ORI_files()

