function [X,Y,Z] = Get_turb_data(data_name,time,ntraj)
% READ THE TURBLENET DATA 

% Set file name 
file_name = [data_name,'.mat'];
% Name file 
load(file_name);


for time = 1:time
        X(time,:) = x(time,1:ntraj,1);
        Y(time,:) = x(time,1:ntraj,2);
        Z(time,:) = x(time,1:ntraj,3);
end
X = double(X);
Y = double(Y);
Z = double(Z);

end

