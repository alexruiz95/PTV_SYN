% compile the C function. Only need to do this once so comment out
% otherwise
%compile_generateParticleImage();

% Make an handle for save images 

% cal images will be stored into the cell
calImages = calTargetMultiView('plot', true)
% can easily save them using im save.
% probably add a save condition to the generate calibration make a folder 

direct = 'cal';
if(~exist(direct, 'dir'))
    mkdir(direct);
end

% save the images
for i=1:length(calImages)
    direct = ['test\cal\cam',num2str(i),'.tif'];
    imwrite(calImages{i}, direct);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lets try to get the data from CalibrationTarget.m
[x,y,z, xc, yc, zc] = calibrationTarget_3('dotSpacing', 0.0254,'dotDiameter', 0.0005,'rows', 8,'columns', 8,'origin', [0,0,0],'particlesPerDot', 1e3)
plot3(xc,yc,zc,'.')
% plot3(x,y,z,'*')  % These dont give a 3D points 
% Save the target file for calibration :

% reshape vectors:
xs=reshape(xc,[8,8])';
ys=reshape(yc,[8,8])';
xs=xs(:);
ys=flip(ys(:));

count = 1:length(xc);
M = [count',xc*1000,yc*1000,zc*1000];
% dlmwrite('target_file.txt',M,'delimiter',' ');

% Target file is not in world cordinates. 
dlmwrite('test\cal\target_file.txt',M,'delimiter','\t');

%hmm Idk 
% wait its probably jusy a 2D calibration plate then he did a 2D
% transformaton. Likely the same thing, 3D plate would be better but it
% should stilll be fine HMM. 

% it would be good to auto generate the test folder, change the out_dir 
% okay so the function handle you can just pass non default args to it 
% that is really cool. Need to up my game. p. 
makeImages('plot', true, 'outdir' , 'test\img');


% Need to get the Caltarg point for calibration

% Target file is not in world cordinates. ?
% 
% compile_generateParticleImage();
% calImages = calTargetMultiView('plot', true)
% makeImages('plot', true);