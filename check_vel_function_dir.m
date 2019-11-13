
% this code is checking the direction of the velocity function   
clear all 
close all
clc
rng(1);
p = inputParser;

% Add optional inputs
addParameter(p, 'cameras', defaultCameraArrangement(), @isstruct);
addParameter(p, 'outdir', '.', @isstr);
addParameter(p, 'outbase', 'frame_1', @isstr);
addParameter(p, 'extension', 'tiff', @isstr);
addParameter(p, 'zeros', 4, @isnumeric);
addParameter(p, 'velocityFunction', @burgersVortex, @isFunctionHandle);
addParameter(p, 'xrange', [-.25, .25]);
addParameter(p, 'yrange', [-.25, .25]);
addParameter(p, 'zrange', [0, 0.1]);
addParameter(p, 'particleConcentration', 2e4, @isnumeric);
addParameter(p, 'tspan', linspace(0,.01, 20), @isnumeric);
addParameter(p, 'particleDiameterMean', 1.5*sqrt(8), @isnumeric);
addParameter(p, 'particleDiameterStdDev', 0.15 * sqrt(8), @isnumeric);
addParameter(p, 'beamStdDev', 0.05, @isnumeric);
addParameter(p, 'BeamPlaneZ', 0, @isnumeric);
addParameter(p, 'velocityFunctionParams', [], @isstruct);
addParameter(p, 'save', false, @islogical);
addParameter(p, 'plot', false, @islogical);
addParameter(p, 'write_to_work', 'false', @islogical);

parse(p)

Cameras = p.Results.cameras;
out_root = p.Results.outdir;
out_base = p.Results.outbase;
out_ext = p.Results.extension;
nZeros = p.Results.zeros;
velocityFunction = p.Results.velocityFunction;
xrange = p.Results.xrange;
yrange = p.Results.yrange;
zrange = p.Results.zrange;
particle_concentration = p.Results.particleConcentration;
tSpan = p.Results.tspan;
particle_diameter_mean = p.Results.particleDiameterMean;
particle_diameter_std = p.Results.particleDiameterStdDev;
beam_plane_std_dev = p.Results.beamStdDev;
beam_plane_z = p.Results.BeamPlaneZ;
velFnParams = p.Results.velocityFunctionParams;
saveImages = p.Results.save;
makePlots = p.Results.plot;
write_to_work = p.Results.write_to_work;

% Format string
fmtStr = sprintf('%%0%dd', nZeros);
outNameFmt = sprintf('%s%s.%s', out_base, fmtStr, out_ext);

testVolume = diff(xrange) * diff(yrange) * diff(zrange);
n_particles = particle_concentration * testVolume;

% Create a normal distribution of particle diameters
particleDiameters = abs(particle_diameter_std * randn(n_particles, 1) ...
    + particle_diameter_mean);

% Discrete positions
xo = xrange(1) + (xrange(2) - xrange(1)) * rand(n_particles, 1);
yo = yrange(1) + (yrange(2) - yrange(1)) * rand(n_particles, 1);
zo = zrange(1) + (zrange(2) - zrange(1)) * rand(n_particles, 1);

% xo=xo./2;
% yo=yo./2;
% zo=zo./2;
xo=xo./4;
yo=yo./4;
zo=zo./4;
% [xo1,yo1,zo1] = make_axis3();
% xo=cat(1,xo(:),xo1(:)*.05);
% yo=cat(1,yo(:),yo1(:)*.05);
% zo=cat(1,zo(:),zo1(:)*.05);
% Calculate the particle trajectories
[X, Y, Z] = velocityFunction(xo, yo, zo, tSpan, velFnParams);

% figure
% xlabel('x')
% ylabel('y')
% for t = 1:19;
%     x = X(t, :);
%     y = Y(t, :);
%     z = Z(t, :);
%     subplot(1,2,1)
%     drawnow
%     plot(x,y,'.')
%     subplot(1,2,2)
%     drawnow
%     plot(x,z,'.')
%     pause(.5)
%     xlabel('x')
%     ylabel('y')
% %     pause(2)
% end
% 
% figure
% xlabel('x')
% ylabel('y')
% zlabel('z')
% for t = 1:19;
%     x = X(t, :);
%     y = Y(t, :);
%     z = Z(t, :);
%     drawnow
%     plot3(x,y,z,'o')
%     pause(.5)
%     xlabel('x')
%     ylabel('y')
%     zlabel('z')
% %     pause(2)
% end

% generate image volumeplayer = pcplayer([-.5 .5],[-.5 .5],[-.5 .5]);

t=0;
player = pcplayer(xrange,yrange,zrange);
while isOpen(player)
    t=t+1;
    x = X(t, :);
    y = Y(t, :);
    z = Z(t, :);
    pos=[x',y',z'];
    ptCloud = pointCloud(pos);
%     player = pcplayer(ptCloud);
    view(player,ptCloud);
    if t>18
        t=0
    else end
    pause(.2)
end 

reducer=1;
figure(2)
hold on
for j = 1:round(length(X)/reducer)
    for t = 1:10;
        part(t,:)=[X(t, j),Y(t, j),Z(t, j)];
%         plot3(part(:,1),part(:,2),part(:,3));
    end
    plot3(part(:,1),part(:,2),part(:,3));
    plot3(part(1,1),part(1,2),part(1,3),...
                    'MarkerFaceColor','w','Marker','>',...
                    'MarkerSize',4);
    plot3(part(:,1),part(:,2),part(:,3),...
        'MarkerFaceColor','w','Marker','o',...
        'MarkerSize',2);  
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    title('Trajectors from burgers function, ">" is start of traj')
    grid on
    view(3)
end
hold off

% t=1
% figure(3)
% scatter3(X(1, :),Y(1, :),Z(1, :))
% title('particles at t=')
% 
% reducer=2;
% figure(2)
% hold on
% % for t = 1:19
% for j = 1:round(length(X)/reducer);
%     for t=1:2;  
%         part(t,:)=[X(t, j),Y(t, j),Z(t, j)];
%     %         plot3(part(:,1),part(:,2),part(:,3));
%     end
%         plot3(part(:,1),part(:,2),part(:,3));
%         plot3(part(1,1),part(1,2),part(1,3),...
%                         'MarkerFaceColor','w','Marker','s',...
%                         'MarkerSize',4);
%         plot3(part(:,1),part(:,2),part(:,3),...
%             'MarkerFaceColor','w','Marker','o',...
%             'MarkerSize',2);  
%         xlabel('X')
%         ylabel('Y')
%         zlabel('Z')
%         title('Trajectors from burgers function, ">" is start of traj')
%         grid on
%         view(3)
% end
% % end
% hold off

% made cool plot for art
% hold on
% for j = 1:length(X(:,1))
%     for t = 1:19;
%         part(t,:)=[X(t, j),Y(t, j),Z(t, j)];
%         plot3(part(:,1),part(:,2),part(:,3));
%     end
% end
% hold off


reducer=2;
figure(2)
hold on
% for t = 1:19
% for j = 1:round(length(X)/reducer);
%     part=[X(:, j),Y(:, j),Z(:, j)];
% %         plot3(part(:,1),part(:,2),part(:,3));
% 
%     plot3(part(:,1),part(:,2),part(:,3));
%     plot3(part(1,1),part(1,2),part(1,3),...
%                     'MarkerFaceColor','w','Marker','>',...
%                     'MarkerSize',4);
%     plot3(part(:,1),part(:,2),part(:,3),...
%         'MarkerFaceColor','w','Marker','o',...
%         'MarkerSize',2);  
%     xlabel('X')
%     ylabel('Y')
%     zlabel('Z')
%     title('Trajectors from burgers function, ">" is start of traj')
%     grid on
%     view(3)
% end
% % end
% hold off


