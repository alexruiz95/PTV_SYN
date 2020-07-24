% 
clear all
close all
clc

% Load the data 
load('test.mat')

% % should be 121 
% tt = length(t) ;
% % should be 8000
% trajects = length(x)

% x is [t] x [trajs] x [x,y,z]
%
%         X(time,:) = x(time,j,1);
%         Y(time,:) = x(time,j,2);
%         Z(time,:) = x(time,j,3);
for time = 1:length(t)
        X(time,:) = x(time,1:100,1);
        Y(time,:) = x(time,1:100,2);
        Z(time,:) = x(time,1:100,3);
end


% Convert to traj for plotting
dt = 1/100;
traj_GT = pos_to_traj(X,Y,Z,dt)

plot_long_trajectories(traj_GT(1:100),2)
 