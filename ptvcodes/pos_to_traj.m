function traject = pos_to_traj(X,Y,Z,dt)
% this function takes in X Y Z dt to make a trajectory structure 
% from the output of the burgers velocity function

dt = dt;
traj = struct('xf',[],'yf',[],'zf',[],'uf',[],'vf',[],'wf',[],'axf',[],'ayf',[],'azf',[],'t',[],'trajid',[])

[Mdim,Ndim]=size(X);
for i=1:Ndim;
    traj(i).xf = X(:, i);
    traj(i).yf = Y(:, i);
    traj(i).zf = Z(:, i);
    start=1;
    id = length(traj(i).xf)+start;
    traj(i).t  = (start:id-1).';
    traj(i).uf = gradient5(traj(i).xf,traj(i).t*dt);
    traj(i).vf = gradient5(traj(i).yf,traj(i).t*dt);
    traj(i).wf = gradient5(traj(i).zf,traj(i).t*dt);
    traj(i).axf = gradient5(traj(i).uf,traj(i).t*dt);
    traj(i).ayf = gradient5(traj(i).vf,traj(i).t*dt);
    traj(i).azf = gradient5(traj(i).uf,traj(i).t*dt);
    traj(i).trajid = ones(size(traj(i).xf)).*i;
    traject = traj;
end

