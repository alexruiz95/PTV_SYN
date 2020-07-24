function plotCameraArrangement2(varargin)
% Plots the current camera arrangement
% Modified version using an extra package for those who do not have 
% the plot camera code 

% JUST FOR visualization

% THIS IS VERY UGLY 

addpath('plotting_camera');

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
   C = -1 * R\t;
   Rc = inv(R)';
   % for visual direction
%    Rc = roty(180)*Rc;
   % world origin 
   hold on 
   sX = .03;
   f_3Dwf('w',sX*5);
   
%    Rcc = roty(180)*Rc*rotx(-90);
%    Rcc2 = roty(180)*Rc*rotx(-90)*roty(180);
%     Rc=R;
%    Rcc = roty(180)*Rc*rotx(-90)*rotz(1);
%    Rcc2 = roty(180)*Rc*rotx(-90)*roty(180);
   
   % REWRITE USING FREE 
   Rcc = rotoy(deg2rad(180))*Rc*rotox(deg2rad(-90))*rotoz(deg2rad(1));
   Rcc2 = rotoy(deg2rad(180))*Rc*rotox(deg2rad(-90))*rotoy(deg2rad(180));
   
   
   Hd=f_Rt2H(Rcc,C);
   Hd1=f_Rt2H(Rcc2,C);
%    Hd=f_Rt2H(R,-t);
%    Hd1=f_Rt2H(R*rotx(-90)*roty(180),C);
   f_3Dcamera(Hd,'r',sX) 
 %  name = ['_{cam ',num2str(n),'}'];
%    name = ['_{',num2str(n),'}'];
    name = ['_{cam}'];
   f_3Dframe(Hd1,'w',sX*4,name);
%    % Plot the camera
%    plotCamera('location', C, 'orientation', ...
%        Rc, 'label', sprintf('%d', n), 'color', 'w', 'size', 0.05, 'axesvisible', false);
   hold on;
   view([-33,45])
    
end

% Plot the cal target points
if isempty(calPoints)
    [~, ~, ~, x,y,z] = calibrationTarget();
else
    x = calPoints(:, 1);
    y = calPoints(:, 2);
    z = calPoints(:, 3);
end

plot3(x(:),y(:),z(:), '.w', 'markersize', 15, 'markerfacecolor', 'w');
% Title
title('ESTIMATE, NOT ACCURATE, JUST AN IDEA, ROTATIONS ARE slightly off',"Color",'white')
hold off;
axis image;
axis vis3d;
grid on;
box on;

set(gca, 'fontsize', 16);

% Axis labels
xlabel('x (m)', 'fontsize', 16, 'interpreter', 'latex');
ylabel('y (m)', 'fontsize', 16, 'interpreter', 'latex');
zlabel('z (m)', 'fontsize', 16, 'interpreter', 'latex');

% Plot formatting stuff
set(gcf, 'color', 'white');
set(gcf, 'color', 'black');
set(gca, 'color', 'black');
set(gca, 'xcolor', 'white');
set(gca, 'ycolor', 'white');
set(gca, 'zcolor', 'white');



end