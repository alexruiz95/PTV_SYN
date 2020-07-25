function [traj_new] = scale_traj(traj,scale)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% traj_new = traj;

for ii =  1:length(traj)
    traj_new(ii).xf = scale*traj(ii).xf;
    traj_new(ii).yf = scale*traj(ii).yf;
    traj_new(ii).zf = scale*traj(ii).zf;
    traj_new(ii).uf = scale*traj(ii).uf;
    traj_new(ii).vf = scale*traj(ii).vf;
    traj_new(ii).wf = scale*traj(ii).wf;
    traj_new(ii).axf = scale*traj(ii).axf;
    traj_new(ii).ayf = scale*traj(ii).ayf;
    traj_new(ii).azf = scale*traj(ii).azf;
    traj_new(ii).t = traj(ii).t;
    traj_new(ii).trajid = traj(ii).trajid;
end

