function Generate_ORI_files(varargin)
% % AR % I modified this code to output the ORI files but it doesnt work yet
% Reference Plot Camera

% Input parser
p = inputParser;

% Add optional inputs
addParameter(p, 'cameras', defaultCameraArrangement(), @isstruct);
addParameter(p, 'points', [], @isnumeric);

% Parse the arguments
parse(p, varargin{:});

% Results structure
Cameras = p.Results.cameras;
calPoints = p.Results.points;

for n = 1 : length(Cameras)
   
   % Get the camera info
   Camera = Cameras(n);
   [~, R, t] = getCameraMatrix(Camera);
   
   % Convert from camera matrix to orentation matrix
   C = 1 * R\t;
   Rc = inv(R)';
   % AR % This is where I made Chanages 
   euler_angle = rotm2eul(R');  % calculates the angles 
   file_name = ['test\cal\cam',num2str(n),'.tif.ori']; % FileName 
   dlmwrite(file_name,1000.*C','delimiter','\t','precision','%.3f') % X Y Z of cameras % first line of ORI
   dlmwrite(file_name,euler_angle,'delimiter','\t','-append','precision','%.4f') % ANGLES Second Line
   dlmwrite(file_name,' ','delimiter','\t','-append') % Add a space
   dlmwrite(file_name,Rc,'delimiter','\t','-append','precision','%.3f') % Write the matrix
   dlmwrite(file_name,' ','delimiter','\t','-append') % Add a space 
   dlmwrite(file_name,[0.0000 0.0000],'-append','delimiter','\t','precision','%.3f') % Xp Yp
   dlmwrite(file_name,0.100*100,'-append','precision','%.3f') % Focal distance should be in cm ? 
   dlmwrite(file_name,[0.00001 0.00001 0.0000001],'-append','delimiter','\t','precision','%.3f') % Last line
   
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

