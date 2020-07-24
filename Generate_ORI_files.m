function Generate_ORI_files(varargin)
% Generate the ori FILES 
% This code will generate the ORI file for OpenPTV. This serves as a really
% good initial guess. The file that is produce is in the form: 
% X Y Z 
% theta_x theta_y theta_z 
% [3x3] Orientation Matrix 
% xp yp camera sensor offsets
% Back Focal Distance (still some uncertainity here) 
% interface postion x y z 

% Note: When the focal distance defined in defaultcamera.m is .105 the back
% focal of 40 works. & for value of .205 80 works. 

% Input parser
p = inputParser;

% Add optional inputs
addParameter(p, 'cameras', defaultCameraArrangement(), @isstruct);
addParameter(p, 'points', [], @isnumeric);
addParameter(p, 'xp_offset', 0, @isnumeric);
addParameter(p, 'yp_offset', 0, @isnumeric);
addParameter(p, 'focal', 80, @isnumeric);
addParameter(p, 'interface', [0.0001 0.0001 0.0001], @isnumeric);
addParameter(p, 'ori_dir', 'test/cal', @isstr); % Directory to Save files
% Parse the arguments
parse(p, varargin{:});

% Results structure
Cameras = p.Results.cameras;
calPoints = p.Results.points;
Focal_dist = p.Results.focal;
Xp_offset = p.Results.xp_offset;
Yp_offset = p.Results.yp_offset;
Interface_pos = p.Results.interface;
Ori_dir = p.Results.ori_dir;


for n = 1 : length(Cameras)
   
   % Get the camera info
   Camera = Cameras(n);
   [~, R, t] = getCameraMatrix(Camera);
   
   % Convert from camera matrix to orentation matrix
   C = -1 * R\t;
   Rc = inv(R)';
   
   
   % using matlab tool boxes (not free)
   % Check to see if user has package
   if exist('rotm2eul')
       euler_angle = rotm2eul(R','XYZ');
   else 
   % If not use free code
   % Added a free RotationAngles code 
        euler_angle = -RotationAngles(R)';
   end
   
   file_name = [Ori_dir,'/cam',num2str(n),'.tif.ori']; % FileName 
   dlmwrite(file_name,1000.*C','delimiter','\t','precision','%.5f') % X Y Z of cameras % first line of ORI
   dlmwrite(file_name,euler_angle,'delimiter','\t','-append','precision','%.5f') % ANGLES Second Line
   dlmwrite(file_name,' ','delimiter','\t','-append') % Add a space
   dlmwrite(file_name,R','delimiter','\t','-append','precision','%.5f') % Write the matrix
   dlmwrite(file_name,' ','delimiter','\t','-append') % Add a space 
   dlmwrite(file_name,[Xp_offset Yp_offset],'-append','delimiter','\t','precision','%.5f') % Xp Yp
   dlmwrite(file_name,Focal_dist,'-append','precision','%.5f') % BACK Focal distance should be in
   dlmwrite(file_name,Interface_pos,'-append','delimiter','\t','precision','%.5f') % Last line
%    
 
    
end

end


   % AR % This is where I made Chanages 
%    euler_angle = rotm2eul(R');  % calculates the angles 
%    euler_angle = RotationAngles(Rc)';euler_angle = rotm2eul(Rc,'XYZ');


  
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