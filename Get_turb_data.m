function [X,Y,Z] = Get_turb_data(data_name)
% READ THE TURBLENET DATA 

% Set file name 
file_name = [data_name,'.mat'];
% Name file 
load(file_name);


for time = 1:length(t)
        X(time,:) = x(time,1:100,1);
        Y(time,:) = x(time,1:100,2);
        Z(time,:) = x(time,1:100,3);
end
X = double(X);
Y = double(Y);
Z = double(Z);

end

