
test='C:\Users\alex\Desktop\og\PTV_SYN\test2\res';
start = 10001;
last = 10020;
dt=1/100;
min_len = 4;
%------

% main = 'C:\Users\alex\OneDrive - Knights - University of Central Florida\Documents\research_xray\CODE_MAIN\TEST DATA FOR PTV\';
% folder = fullfile(main,test,'res0');

traj = ptv_is_to_traj(test,start,last,min_len,dt);
plot_long_trajectories(traj,min_len);



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