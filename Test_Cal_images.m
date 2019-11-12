
% Run the test script
calImages = calTargetMultiView_3('plot', true)
calImages = calTargetMultiView_3('plot', true,'save',false)

% check original 
calImages = calTargetMultiView('plot', true,'cal_dir', 'test/cal')

%changed it to night flipud
calImages = calTargetMultiView('plot', true,'save',true,'TargetFile', true)
% Generate ORI
Generate_ORI_files()

PARAMS.g = 5;
PARAMS.a = .5;
PARAMS.m = 1e-6;

makeImages('velocityFunction', @burgersVortex,'xrange', [-1, 1],'yrange', [-1, 1],'zrange', [-1, 1],'outdir','test/img','save',true,'plot',true,'velocityFunctionParams',PARAMS)

makeImages2('outdir','test/img','save',true,'plot',true,'velocityFunctionParams',PARAMS,'velocityFunction', @burgersVortex,'zrange', [-.1,.1],'particleDiameterMean', 3.5*sqrt(8),'particleConcentration', 3.5e4)
makeImages('velocityFunction', @burgersVortex,'xrange', [-1, 1],'yrange', [-1, 1],'zrange', [-0.1, 0.1],'save', false,'plot',true,'velocityFunctionParams',PARAMS)


system('py remove_tif.py test/img/Cam1');
system('py remove_tif.py test/img/Cam2');
system('py remove_tif.py test/img/Cam3');
system('py remove_tif.py test/img/Cam4');
