function [x_cam, y_cam] = pinholeTransform(x_world, y_world, z_world, camera_matrix)
% INPUTS
%	x_world = x location of object in world coordinates
%	y_world = '';
%	z_world = '';	
%	camera_matrix = Camera matrix (4 columns x 3 rows)

% OUTPUTS
%	xc = x coordinate of the image in camera coordinate system
%	yc = ''

% Size of position array
array_length = numel(x_world);

% World coordinate matrix
world_coordinates = [(x_world(:))'; (y_world(:))'; (z_world(:))'; ones(1, array_length)];

%% Try to add distortion 


%%


% Homogeneous camera coordinates
camera_coordinates = (camera_matrix * world_coordinates)';

% Camera coordinates
x_cam = camera_coordinates(:, 1) ./ camera_coordinates(:, 3);
y_cam = camera_coordinates(:, 2) ./ camera_coordinates(:, 3);


% ADD SIMPLE DISTORT NOW THAT IM SMARTER 
off_set = 512;
x = x_cam-off_set;
y = y_cam-off_set;
rold = sqrt(x.*x + y.*y);
distort =  true ;
if distort 
    distortion_coeff = 10e-7;
    disp('YES DISTORT')
else 
    distortion_coeff = 0 ;
end

x_new = x.*(1+distortion_coeff.*rold.^2) ; 
y_new = y.*(1+distortion_coeff.*rold.^2) ; 
% z_new = zc.*(1+distortion_coeff.*rold.^2) ; 
x_cam = x_new + off_set ;
y_cam = y_new + off_set;

%

% 
% 
% %% Try to add distortion 
% points = [(x_world(:))'; (y_world(:))'; (z_world(:))'; ones(1, array_length)];
% 
% r2 = x_cam.^2 + y_cam.^2;
% % distort values
% % D = [0,0,0,0,0];
%     %k1 k2 p1 p2 k3 % 
% D = [1,0.5,0,0,0];
% k = [D(1),D(2),D(5)];
% p = [D(3),D(4)];
% 
% %find tangential distortion
% xTD = 2*p(1)*x_cam.*y_cam + p(2).*(r2 + 2*x_cam.^2);
% yTD = p(1)*(r2 + 2*y_cam.^2) + 2*p(2)*x_cam.*y_cam;
% 
% %find radial distortion
% xRD = x_cam.*(1 + k(1)*r2 + k(2)*r2.^2 + k(3)*r2.^3); 
% yRD = y_cam.*(1 + k(1)*r2 + k(2)*r2.^2 + k(3)*r2.^3); 
% 
% %combine distorted points
% x = xRD + xTD;
% y = yRD + yTD;
% 
% %project distorted points back into 3D
% points = [x,y,ones(size(x,1),1)].*repmat(points(:,3),1,3);
% 
% %project using camera matrix
% points = (camera_matrix*[points, ones(size(points,1),1)]')';
% points = points(:,1:2)./repmat(points(:,3),1,2);



%%

end