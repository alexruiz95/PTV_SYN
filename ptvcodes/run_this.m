
% test='C:\Users\alex\Desktop\og\PTV_SYN\nodistort_test\res';
% test='C:\Users\alex\TEST DATA FOR PTV\test1_flat\res0';
% test = 'C:\Users\alex\Desktop\big_tank_ptv_new2\big_tank\res';
test = 'C:\Users\alex\Desktop\og\PTV_SYN\Burger\res';
start = 10001;
last = 10019;
dt=1/100;
min_len = 2;
%------

% main = 'C:\Users\alex\OneDrive - Knights - University of Central Florida\Documents\research_xray\CODE_MAIN\TEST DATA FOR PTV\';
% folder = fullfile(main,test,'res0');r


traj = ptv_is_to_traj(test,start,last,min_len,dt);

axf = 1705 ; 
traj_new = traj_vel_filter(traj,axf);

plot_long_trajectories(traj,10);
title('Trajectories')
% SET THE CAM LINE OF SIGHT 
v = [5 -3 4];
[caz,cel] = view(v)
% plot ground truth 
%traject = pos_to_traj_2(Pos,dt)















% 
% 
% 
% for i=1:length(traj)
%     all_len(i) = length(traj(i).xf);
% end
% 
% 
% %----
% % traj = ptv_is_to_traj(folder,start,last,min_len,dt);
% plot_long_trajectories(traj,5);
% %----
% [ scatter_t ] = traj2scatter_t_3D( traj );
% n=12;
% grid = scatter_to_grid( scatter_t, 5)
% [grid_d] = scatter_t2grid( scatter_t ,n) 
% quiver3(grid_d.x,grid_d.y,grid_d.z,grid_d.u,grid_d.v,grid_d.w)
% 
% 
% quiver3(grid.x,grid.y,grid.z,nanmean(grid.u,4),nanmean(grid.v,4),nanmean(grid.w,4),3)
% % grid.x=grid.x.';
% % grid.x=grid.y.';
% % grid.u=grid.u.';
% % grid.v=grid.v.'; 
% % grid.w=grid.w.';
% % grid.z=grid.z.';
% [cu,cv,cw] = curl(grid.x,grid.y,grid.z,nanmean(grid.u,4),nanmean(grid.v,4),nanmean(grid.w,4));
% div = divergence(grid.x,grid.y,grid.z,nanmean(grid.u,4),nanmean(grid.v,4),nanmean(grid.w,4));
% vtkwrite('vec_curl_div.vtk', 'structured_grid', grid.x, grid.y, grid.z,'vectors', 'vector_field', nanmean(grid.u,4),nanmean(grid.v,4),nanmean(grid.w,4), 'vectors', 'vorticity', cu, cv, cw, 'scalars', 'divergence', div);
% quiver(grid.z(:,:,1),grid.y(:,:,1),mean(nanmean(grid.w,4),3),mean(nanmean(grid.v,4),3),3)
% h=curl(grid.z(:,:,1).',grid.y(:,:,1).',mean(nanmean(grid.w,4),3).',mean(nanmean(grid.v,4),3).');
% contourf(grid.x(:,:,1).',grid.y(:,:,1).',h)