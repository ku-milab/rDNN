clear;
close;
addpath(genpath('.'));
addpath(genpath('/home/eh/Desktop/Data/ADNI/'));   %% Data path


%% initialize
% ADNI data path
Data_Path = '/home/eh/Desktop/Data/ADNI/';
opt.Data_type1 = 'AD';
opt.Data_type2 = 'NC';
opt.threshold = 0.05;
opt.nfold = 10;
opt.num_voxel = 200;



opt.type1_Data_Path = sprintf('%sRavens_density_%s',Data_Path,opt.Data_type1);
opt.type2_Data_Path = sprintf('%sRavens_density_%s',Data_Path,opt.Data_type2);


%% result path
opt.ex = sprintf('ex170913_%s_%s',opt.Data_type1, opt.Data_type2);
processed_Data_Path = sprintf('%s_Data',opt.ex);
result_Path = sprintf('./Save_result/%s',opt.ex);
DataClass = { opt.Data_type1, opt.Data_type2 };

make_Path(opt.Data_type1, opt.Data_type2, processed_Data_Path, opt)

%% Data file name
[opt.Type1_file_name,num_type1] = Read_file_name (opt.type1_Data_Path); % AD
[opt.Type2_file_name,num_type2] = Read_file_name (opt.type2_Data_Path); % NC

%% get Template ROI index
load ROI_info.mat;
if ~exist('./Template_ROI_idx.mat')
    template_name = sprintf('%s/template/jakob-label-axialdown-256_256_256',Data_Path);
    Template_ROI_idx = Load_Tmplate_idx(template_name, ROI_info);
    Template_ROI_idx(:,2) = num2cell(ROI_info);

    save('Template_ROI_idx.mat','Template_ROI_idx')
else
    load('./Template_ROI_idx.mat');
end

%% make cross validation index
make_CV_idx(opt, num_type1, num_type2)
load(sprintf('./Save_result/%s/crossValidation_idx.mat',opt.ex));
load(sprintf('./Save_result/%s/Shuffle_idx.mat',opt.ex));

%% ttest
[p_value,Thresh_idx] = stat_map2(Data_Path,DataClass,Template_ROI_idx, ROI_info, Type1_tr_fold, Type2_tr_fold, opt);
load(sprintf('./Save_result/%s/TreshIdx%.2f.mat',opt.ex,threshold),'Thresh_idx','p_value');


%% make random subspace
make_Subspace(opt, processed_Data_Path, opt.Data_type1, opt.Data_type2)


%% network Training
Network_training(opt, processed_Data_Path, Data_type1, Data_type2)

%% network Testing
Network_testing(opt, processed_Data_Path, Data_type1, Data_type2)


%% ensemble
ens = [];  
% ex = 'ex170701';
load ROI_info.mat;
for fold = 1 : 10
    load(sprintf('./Save_result/%s/All_features/Abnormality_feature_%d.mat',opt.ex,fold));
    for roi = 1 :  size(ROI_info,1)
        tmp = [];
        for i=1 : size(test_Abnormality{roi}.result,1)
            tmp.train(:,i) = train_Abnormality{roi}.result{i,1}(:,1);
            tmp.test(:,i) = test_Abnormality{roi}.result{i,1}(:,1);
        end
        tmp.trLabel = train_Abnormality{roi}.Label;
        tmp.teLabel = test_Abnormality{roi}.Label;
        
        tmp.train = mean(tmp.train,2);
        tmp.test  = mean(tmp.test,2);
        
        ens{fold}.train(:,roi) = tmp.train;
        ens{fold}.test(:,roi) = tmp.test;
        ens{fold}.trLabel = tmp.trLabel(:,1);
        ens{fold}.teLabel = tmp.teLabel(:,1);
    end
    
end
[perf, performance, weight, model] = Cal_perform(ens);

save(sprintf('%s',opt.ex),'perf','performance','weight','model','ens');

