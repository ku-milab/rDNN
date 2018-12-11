function make_Path(Data_type1, Data_type2, processed_Data_Path, opt)

for fold = 1 : 10
    mkdir(sprintf('./%s/%s_F/fold_%d',processed_Data_Path, Data_type1, fold));
    mkdir(sprintf('./%s/%s_F/fold_%d',processed_Data_Path, Data_type2, fold));
end

result_Path = sprintf('Save_result/%s/',opt.ex);
%result save path
if exist(result_Path,'dir')==0
    disp('not exist result_path');
    mkdir(result_Path);
    for i = 1 : 10        % opts.nfold
        mkdir(sprintf('Save_result/%s/fold%d',opt.ex,i));
        mkdir(sprintf('Save_result/%s/Network/fold%d',opt.ex,i));
    end
    
mkdir(sprintf('Save_result/%s/All_features',opt.ex));
else
    disp('Exist result_path');
end






end