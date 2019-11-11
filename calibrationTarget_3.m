function [x,y,z, xc, yc, zc] = calibrationTarget_3(varargin)
% Makes [x,y,z] coordinates that can be passed to generateParticleImage 
% to create an image of a camera calibration target.

% I THINK THESE ARE IN CAMERA COORDINATES: 

    % Input parser
    p = inputParser;

    % Add optional inputs
    addParameter(p, 'dotSpacing', 0.0254, @isnumeric);
    addParameter(p, 'dotDiameter', 0.0005, @isnumeric); % changed 0.005
    addParameter(p, 'rows', 5, @isnumeric); % changed 9
    addParameter(p, 'columns', 5, @isnumeric); % changed 9
    addParameter(p, 'origin', [0,0,0], @isnumeric);
    addParameter(p, 'particlesPerDot', 1e3, @isnumeric);
    
    % Parse the arguments
    parse(p, varargin{:});

    % Results structure
    dot_spacing_m = p.Results.dotSpacing;
    dot_diameter_m   = p.Results.dotDiameter;
    dot_rows = p.Results.rows;
    dot_cols = p.Results.columns;
    target_origin   = p.Results.origin;
    particles_per_dot = p.Results.particlesPerDot;
 
    % Number of dots
    nDots = dot_rows * dot_cols;
    
    % Width of target (center of first dot to center of last dot)
    targetWidth =  (dot_cols - 1) * dot_spacing_m;
    targetHeight = (dot_rows - 1) * dot_spacing_m;
    
    % Dot centers
    xv = linspace(-targetWidth/2, targetWidth/2, dot_cols)   + target_origin(1);
    yv = linspace(-targetHeight/2, targetHeight/2, dot_rows) + target_origin(2);
    zv = target_origin(3);
    
    % Make a grid of dot centers
    [xdots1, ydots1, zdots1] = meshgrid(xv, yv, zv);

    [xdots,ydots,zdots] = make_axis3();
    
%     xdots=cat(1,xdots,xdots1(:));
%     ydots=cat(1,ydots,ydots1(:));
%     zdots=cat(1,zdots,zdots1(:));
        xdots=cat(1,xdots*.1,xdots1(:));
    ydots=cat(1,ydots*.1,ydots1(:));
    zdots=cat(1,zdots*.1,zdots1(:));
    nDots = length(xdots);
    
%     xdots = [-0.025400,-0.025400,-0.025400,0.000];
%     ydots = [-0.025400,0.000,0.025400,0.025400];
%     zdots = [0,0,0,0];
    % Reshape the dot center arrays into vectors
    
%     xc = xdots(:)*.1;
%     yc = ydots(:)*.1;
%     zc = zdots(:)*.1;
    xc = xdots(:);
    yc = ydots(:);
    zc = zdots(:);
    % Allocate array to hold all the [x,y,z] points
    x = zeros(particles_per_dot, nDots);
    y = zeros(particles_per_dot, nDots);
    z = zeros(particles_per_dot, nDots);
    
    % Make all the dots
    for n = 1 : nDots
%         dot_diameter_m = dot_diameter_m *2; % lets see how its plotting
        % Random angle from dot center
        th = 2 * pi * rand(particles_per_dot, 1);
        r = dot_diameter_m/2  * rand(particles_per_dot, 1);
        zraw = zeros(particles_per_dot, 1);
        [xraw, yraw, ~] = pol2cart(th, r, zraw);
        x(:, n) = xraw + xc(n);
        y(:, n) = yraw + yc(n);
        z(:, n) = zraw + zc(n);
    end
    
end
