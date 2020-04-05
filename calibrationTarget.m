function [x,y,z, xc, yc, zc] = calibrationTarget(varargin)
% Makes [x,y,z] coordinates that can be passed to generateParticleImage 
% to create an image of a camera calibration target.

    % Input parser
    p = inputParser;

    % Add optional inputs
    addParameter(p, 'dotSpacing', 0.0032, @isnumeric); %  0.0254,0.032
    addParameter(p, 'dotDiameter', 0.000025, @isnumeric); % changed 0.005
    addParameter(p, 'rows', 5, @isnumeric); % changed 9
    addParameter(p, 'columns', 5, @isnumeric); % changed 9
    addParameter(p, 'origin', [0,0,0], @isnumeric);
    addParameter(p, 'particlesPerDot', 1e3, @isnumeric);
    addParameter(p, 'target_3D', true, @islogical);
    addParameter(p, 'make_axis', false, @islogical);
    
    % Parse the arguments
    parse(p, varargin{:});

    % Results structure
    target3D = p.Results.target_3D;
    dot_spacing_m = p.Results.dotSpacing;
    dot_diameter_m   = p.Results.dotDiameter;
    dot_rows = p.Results.rows;
    dot_cols = p.Results.columns;
    target_origin   = p.Results.origin;
    particles_per_dot = p.Results.particlesPerDot;
 
    % Number of dots
    nDots = dot_rows * dot_cols;
    
    % make axis 
    MakeAxis = p.Results.make_axis;
    
    % Width of target (center of first dot to center of last dot)
    targetWidth =  (dot_cols - 1) * dot_spacing_m;
    targetHeight = (dot_rows - 1) * dot_spacing_m;
    
    % Dot centers
    xv = linspace(-targetWidth/2, targetWidth/2, dot_cols)   + target_origin(1);
    % lets flip yv here so our points are in the same order for PTV
    % that is left to right top to bottom
    %yv = linspace(-targetHeight/2, targetHeight/2, dot_rows) + target_origin(2);
    yv = linspace(targetHeight/2, -targetHeight/2, dot_rows) + target_origin(2);
    zv = target_origin(3);
    zv1 = linspace(-targetHeight/2, targetHeight/2, dot_rows) + target_origin(3);

    
    % Make a grid of dot centers
    % lets flip yv here so our points are in the same order for PTV
    % that is left to right top to bottom
%     [xdots, ydots, zdots] = meshgrid(xv, yv, zv);
    % Better to use ndgrid
    [xdots, ydots, zdots] = ndgrid(xv, yv, zv);
    if target3D
            % Make a grid of dot centers
        [xx,zz] = meshgrid(xv, zv1);
        zz=sqrt(zz.^2);
        zdots=zz/2;
    end
    
    % used to check image direction 
    if MakeAxis
        [xdots1,ydots1,zdots1] = make_axis3();
        xdots=cat(1,xdots(:),xdots1(:)*.1);
        ydots=cat(1,ydots(:),ydots1(:)*.1);
        zdots=cat(1,zdots(:),zdots1(:)*.1);
        nDots = length(xdots);
    end
  
    % Reshape the dot center arrays into vectors
    xc = xdots(:);
    yc = ydots(:);
    zc = zdots(:);
    
    % DISP min and max of target file 
    text_2_disp = ['X-Range:',num2str([min(xc),max(xc)]),'; Y-Range:',num2str([min(yc),max(yc)]),'; Z-Range:',num2str([min(zc),max(zc)])];
    disp(text_2_disp)
    
    % Allocate array to hold all the [x,y,z] points
    x = zeros(particles_per_dot, nDots);
    y = zeros(particles_per_dot, nDots);
    z = zeros(particles_per_dot, nDots);
    
    % Make all the dots
    for n = 1 : nDots;
        
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
