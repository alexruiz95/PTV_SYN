function remove_tif_M(folder)
% UGLY BUT WORKS 
% Just run this it should work.

% Where are the Cam1, Cam2 .. etc folder 
% path = 'test/img/';
path = [folder,'/'];
% What is the file extension
exten = '.tiff' ; 

% for each folder 
for i = 1:4
    full_ext = [path,'Cam',num2str(i),'/','*',exten];
    files = dir(full_ext);


% Get all text files in the current folder
% files = dir('*.txt');
% Loop through each file 
    for id = 1:length(files)
        % Get the file name 
        [~, f,ext] = fileparts(files(id).name);
        [fold] = fileparts(files(id).folder);
        rename = strcat(fold,'\Cam',num2str(i),'\',f) 
        rename2 = strcat(fold,'\Cam',num2str(i),'\',f,ext);
        movefile(rename2, rename);
    end
end
end
