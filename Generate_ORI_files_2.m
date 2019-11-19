function Generate_ORI_files_2(varargin)
% % AR % I modified this code to output the ORI files but it doesnt work yet
% Reference Plot Camera

% Input parser
p = inputParser;

% Add optional inputs
addParameter(p, 'cameras', defaultCameraArrangement(), @isstruct);
addParameter(p, 'points', [], @isnumeric);
addParameter(p, 'ori_dir', '.',@isstr);
% addParameter(p, 'Back_focal', [], @isnumeric);
% Parse the arguments
parse(p, varargin{:});

% Results structure
Cameras = p.Results.cameras;
calPoints = p.Results.points;
ori_dir = p.Results.ori_dir;
% Back_focal = p.Results.Back_focal;

% Introduce this rotation
% theta=pi;
% T = [cos(theta)  0  sin(theta);
%     0        1      0;
%  -sin(theta) 0  cos(theta)];
% T=1;
for n = 1 : length(Cameras)
   
   % Get the camera info
   Camera = Cameras(n);
   [~, R, t] = getCameraMatrix(Camera);
   
   % Convert from camera matrix to orentation matrix
   C = -1.* R\t;
   Rc = inv(R)';
%    R_PTV= T * Rc;
   % AR % This is where I made Chanages 
%    euler_angle = rotm2eul(R');  % calculates the angles 
   %euler_angle = RotationAngles(R_PTV);
%    euler_angle = rotm2eul(R_PTV','XYZ');
   euler_angle = rotm2eul(R','XYZ');
   file_name = [ori_dir,'\cam',num2str(n),'.tif.ori']; % FileName 
   dlmwrite(file_name,1000.*C','delimiter','\t','precision','%.3f') % X Y Z of cameras % first line of ORI
   % I noticed that the last angle is always half of the computed
   dlmwrite(file_name,euler_angle.*[1,1,.5],'delimiter','\t','-append','precision','%.4f') % ANGLES Second Line
   dlmwrite(file_name,' ','delimiter','\t','-append') % Add a space
   dlmwrite(file_name,Rc,'delimiter','\t','-append','precision','%.4f') % Write the matrix
   dlmwrite(file_name,' ','delimiter','\t','-append') % Add a space 
   dlmwrite(file_name,[0.0000 0.0000],'-append','delimiter','\t','precision','%.3f') % Xp Yp
   dlmwrite(file_name,105,'-append','precision','%.3f') % BACK Focal distance should be in
   dlmwrite(file_name,[0.001 0.001 -1],'-append','delimiter','\t','precision','%.3f') % Last line change to -1 10/26
   
   
%    ori_matrix{n} = Rc
%    location{n} = C
%    trans{n} = t
%    
%    
%    euler_angle = flip(rotm2eul(Rc').*-1);
%    file_name = ['test\cal\cam',num2str(n),'.tif.ori'];
%    dlmwrite(file_name,C','delimiter','\t','precision','%.3f')
%    dlmwrite(file_name,euler_angle,'delimiter','\t','-append','precision','%.4f')
%    dlmwrite(file_name,' ','delimiter','\t','-append')
%    dlmwrite(file_name,Rc,'delimiter','\t','-append','precision','%.3f')
%    dlmwrite(file_name,' ','delimiter','\t','-append')
%    dlmwrite(file_name,[0.0000 0.0000],'-append','delimiter','\t','precision','%.3f')
%    dlmwrite(file_name,0.105*1000,'-append','precision','%.3f')
%    dlmwrite(file_name,[0.00001 0.00001 100.0000],'-append','delimiter','\t','precision','%.3f')
%    ori_matrix{n} = Rc;
%    location{n} = C;
%    trans{n} = t;

%    % Plot the camera
%    plotCamera('location', C, 'orientation', ...
%        Rc, 'label', sprintf('%d', n), 'color', 'w', 'size', 0.05, 'axesvisible', false);
%    hold on;
    
end

end