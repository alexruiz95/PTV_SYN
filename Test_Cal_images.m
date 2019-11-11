
% Run the test script
calImages = calTargetMultiView_3('plot', true)

% check original 
calImages = calTargetMultiView('plot', true)



makeImages('velocityFunction', @burgersVortex_3,'xrange', [0, 1],'yrange', [0, 1],'zrange', [-0.1, 0.1])