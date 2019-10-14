function camera_pos(base_name,start,last)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% This is a function that reads the ori files and plots the cameras
% positions

% ex camera_pos('test/cal/cam,1,4)


% clean this code up really ugly 
k=1;
for i =start:last
    if i ==0
        k=k+1;
    else
    end
    cam(:,:,:,k)=dlmread([base_name,num2str(i),'.tif.ori'])
    k=k+1;
end
cam1 = cam(:,:,:,1);
cam2 = cam(:,:,:,2);
cam3 = cam(:,:,:,3);
cam4 = cam(:,:,:,4);
%%
% projective center X,Y,Z, [mm]
pos(1,:,:,:)=cam1(1,:);
pos(2,:,:,:)=cam2(1,:);
pos(3,:,:,:)=cam3(1,:);
pos(4,:,:,:)=cam4(1,:);
%%
% omega, phi, kappa [rad]
angle(1,:,:,:)=cam1(2,:);
angle(2,:,:,:)=cam2(2,:);
angle(3,:,:,:)=cam3(2,:);
angle(4,:,:,:)=cam4(2,:);
%%

% Rotation Matrix
rotationmatrix(:,:,:,1) = cam1(3:5,1:3);
rotationmatrix(:,:,:,2) = cam2(3:5,1:3);
rotationmatrix(:,:,:,3) = cam3(3:5,1:3);
rotationmatrix(:,:,:,4) = cam4(3:5,1:3);
%%
for i=1:4
    orientation(:,:,:,i) = eul2rotm(angle(i,:,:,:),'XYZ')%rotationmatrix(:,:,1,i)';
    %orientation(:,:,:,i) = rotationmatrix(:,:,1,i)';
    location(:,:,:,i) = pos(i,:,:,:);%*orientation(:,:,:,i) ;%* orientation(:,:,:,i);
    %location(:,:,:,i) = pos(i,:,:,:) ;%* orientation(:,:,:,i);
end
%%
%cal_points = dlmread('calblock_85_vertical.txt')
cal_points = dlmread('target_file.txt')
%%
hold on
plot3(cal_points(:,2),cal_points(:,3),cal_points(:,4),'.') % calibration plate
center = mean([cal_points(:,2),cal_points(:,3),cal_points(:,4)])
plot3(pos(:,1),pos(:,2),pos(:,3),'*')% plot the camera
plot3(0,0,0,'g*') 
for i=1:4
    hold on
    plotCamera('Location',location(:,:,:,i),'Orientation',orientation(:,:,:,i),'Size',10);
    plot3([center(1,1),pos(i,1)] ,[center(1,2),pos(i,2)], [center(1,3),pos(i,3)]);
end
hold off
grid on
title('Couldnt get cameras to flip')
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
view([1 1 1])



end

