function [file_name,file_size] = Read_file_name (Data_Path)

%% Data_type 1 = RavensMap;

Dir = dir(sprintf('%s/*.mat',Data_Path));

[file_name,~] = sort_nat({Dir.name});
file_name = file_name';
file_size = size(file_name,1);


end