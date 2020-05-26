function varargout = plot_long_traject_COP(traj,title1,traj2,title2,minLength);
% Usage:

% COMPARES TWO TRAJECTORIES SIDE BY SIDE ALEX RUIZ UCF MODIFEIED
%   PLOT_LONG_TRAJECTORIES(TRAJ,<MINLENGTH>,<FIGUREHANDLE>)
% where TRAJ is a structure that includes
% field 'traj' and optional input MINLENGTH is the
% shortest length of the trajectory to plot.
% If FigureHandles is an open figure, adds the trajectories to that plot
% with some random color and without markers.
%
% SEE ALSO: building_trajectories.m

% Author: Alex Liberzon
% Copyright (c) 2007,2015 TAU

% default minimum length to plot, saves memory and space
% if nargin < 2, minLength = 10; end

trajLen = zeros(length(traj),1);
only_long = isfield(traj,'trajid');
if only_long % we can select according to length
    for i = 1:length(traj)
        trajLen(i) = length(traj(i).trajid);
        if traj(i).trajid == -999
            trajLen(i) = 0;
        end
    end
    id = find(trajLen >= minLength);
else % we cannot, take everything?
    id = 1:length(traj);
end

% if nargin < 3 % new figure, use markers
figure1 = figure;
axes('Parent',figure1);
box('on');
grid('on');
hold('all');


for i = 1:length(id)
    hold on
    subplot(1,2,1);
    plot3(traj(id(i)).xf,traj(id(i)).yf,traj(id(i)).zf,...
        'MarkerFaceColor','w','Marker','o',...
        'MarkerSize',4,...
        'UserData',traj(id(i)).trajid(1));
    plot3(traj(id(i)).xf(1),traj(id(i)).yf(1),traj(id(i)).zf(1),...
        'MarkerFaceColor','w','Marker','>',...
        'MarkerSize',6);
end
% SET THE VIEW 
v = [-10 -8 2];
[caz,cel] = view(v)
hold off
title(title1,'fontsize', 14, 'interpreter', 'latex')
axis tight


% ----  --------------traj2 ---------------------------%
trajLen = zeros(length(traj2),1);
only_long = isfield(traj2,'trajid');
if only_long % we can select according to length
    for i = 1:length(traj2)
        traj2Len(i) = length(traj2(i).trajid);
        if traj2(i).trajid == -999
            traj2Len(i) = 0;
        end
    end
    id = find(traj2Len >= minLength);
else % we cannot, take everything?
    id = 1:length(traj2);
end
xlabel('x (m)', 'fontsize', 12, 'interpreter', 'latex');
ylabel('y (m)', 'fontsize', 12, 'interpreter', 'latex');
zlabel('z (m)', 'fontsize', 12, 'interpreter', 'latex');
grid on
for i = 1:length(id)
    subplot(1,2,2);
    hold on
    plot3(traj2(id(i)).xf,traj2(id(i)).yf,traj2(id(i)).zf,...
        'MarkerFaceColor','w','Marker','o',...
        'MarkerSize',4,...
        'UserData',traj2(id(i)).trajid(1));
    plot3(traj2(id(i)).xf(1),traj2(id(i)).yf(1),traj2(id(i)).zf(1),...
        'MarkerFaceColor','w','Marker','>',...
        'MarkerSize',6);
end
hold off

% Create labels
xlabel('x (mm)', 'fontsize', 12, 'interpreter', 'latex');
ylabel('y (mm)', 'fontsize', 12, 'interpreter', 'latex');
zlabel('z (mm)', 'fontsize', 12, 'interpreter', 'latex');
grid on
title(title2,'fontsize', 14, 'interpreter', 'latex')
[caz,cel] = view(v)
axis tight

if nargout == 1
    varargout{1} = figure1;
elseif nargout == 2
    varargout{1} = figure1;
    varargout{2} = TrajLen;
end