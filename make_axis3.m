function [xo,yo,zo] = make_axis3(varargin);


numx = linspace(0,.5,100)';
numy = linspace(0,.5,100)';
numz = linspace(0,.5,100)';

empty=numx*0;


x_dir = cat(1,numx,empty,empty);
y_dir = cat(1,empty,numy,empty);
z_dir = cat(1,empty,empty,numz);
% hold on 
% plot3(x_dir,y_dir,z_dir,'.')
scale=.5;
del = linspace(0,median(numy)*scale,15);
dx= median(numx)/4;
x=ones(size(del))*dx;
z=zeros(size(del));
% plot3(x,del,z)
x_dir = cat(1,x_dir,x');
y_dir = cat(1,y_dir,del');
z_dir = cat(1,z_dir,z');


x_dir = cat(1,x_dir,del');
y_dir = cat(1,y_dir,x');
z_dir = cat(1,z_dir,z');

x_dir = cat(1,x_dir,del');
y_dir = cat(1,y_dir,x'+ max(y_dir)*.7);
z_dir = cat(1,z_dir,z');


x_dir = cat(1,x_dir,del');
y_dir = cat(1,y_dir,x'+ max(y_dir)*.5);
z_dir = cat(1,z_dir,z');


x_dir =1* cat(1,x_dir,z');
y_dir = 1*cat(1,y_dir,del');
z_dir = 1*cat(1,z_dir,x'+ max(y_dir)*.8);

z_max = max(z_dir);
x_max = max(x_dir);
f=polyfit([0,z_max],[x_max,0],2);
xxx=linspace(0,x_max,40);
pp = polyval(f,xxx);
y = zeros(size(pp));


x_dir =1* cat(1,x_dir,xxx');
y_dir = 1*cat(1,y_dir,y');
z_dir = 1*cat(1,z_dir,pp');
% ax1 = subplot(1,1,1);

% plot3(x_dir,y_dir,z_dir,'.')


% v = [-5 -5 5];
% view(v)
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% axis equal 
% xlabel('x')
% ylabel('y')
% zlabel('z')
% hold off
xo = x_dir;
yo = y_dir;
zo = z_dir;
end
