
function valData = loadData(opts, cvNum)
load(opts.cvSavePath);  %% load allData_cv

valData = [];
tmpTest_data = [];
tmpTest_label = [];

tmpTrain_data = [];
tmpTrain_label = [];

for i = 1: opts.cvNum
    if i == cvNum
        tmpTest_data = cat(3, allData_cv{i}.AD, allData_cv{i}.NC);
        tmpTest_label = cat(1, allData_cv{i}.AD_label, allData_cv{i}.NC_label);
    else
        tmpTrain_data = cat(3, tmpTrain_data, allData_cv{i}.AD, allData_cv{i}.NC);
        tmpTrain_label = cat(1, tmpTrain_label, allData_cv{i}.AD_label, allData_cv{i}.NC_label);
    end
end
valData.Test_data = tmpTest_data;
valData.Test_label = tmpTest_label;
valData.Train_data = tmpTrain_data;
valData.Train_label =tmpTrain_label;
end

% % % shaffle
% if exist(shaffle_Path,'file') == 0;
%     for i = 1: opts.cvNum
%         shaffle1{i} = randperm(size(Test_data,3));
%         shaffle2{i} = randperm(size(Train_data,3));
%     end
% else
%     load(shaffle_Path);
% end
% 
% Test_data = Test_data(:,:,shaffle1(1,:));
% Test_labels = Test_labels(shaffle1(1,:),:);
% 
% Train_data = Train_data(:,:,shaffle2(1,:));
% Train_labels = Train_labels(shaffle2(1,:),:);
% 
% save(shaffle_Path,'shaffle1','shaffle2');
