
function model = model_Mean(res,opts,CV)


% loadPath = sprintf('Final_Data/output_data/ex%s/CV%d_result%d.mat',ex,cv,opts.weaklearn);
% loadData = load(loadPath);

temp_resTrain = [];
temp_resTest = [];
num_Sample = size(res{1,1}.train,2);
%  num_Sample = 3;
for i = 1 : num_Sample
    temp_resTrain = cat(2,temp_resTrain,res{1,CV}.train{1,i}(:,1));
    temp_resTest = cat(2,temp_resTest,res{1,CV}.test{1,i}(:,1));
end

model.train(:,1) = mean(temp_resTrain,2);
model.test(:,1) = mean(temp_resTest,2);
model.trLabel = res{1,CV}.trainLabel{1,1}(:,1);
model.teLabel = res{1,CV}.testLabel{1,1}(:,1);

%%
% Temp.train_mean = repmat(mean(temp_resTrain,2),1,size(temp_resTrain,2));  %each sub mean by demention (:,2)
% Temp.test_mean = repmat(mean(temp_resTest,2),1,size(temp_resTrain,2));
% Temp.train_std = repmat(std(temp_resTrain,0,2),1,size(temp_resTrain,2));
% Temp.test_std = repmat(std(temp_resTest,0,2),1,size(temp_resTrain,2));
% model.train(:,1) = (temp_resTrain - Temp.train_mean) ./ Temp.train_std;
% model.test(:,1) = (temp_resTest - Temp.test_mean) ./ Temp.test_std;
%%


% TrMean_Sub = repmat(mean(Temp.train,1),size(Temp.train));  % all sub mean
% TeMean_Sub = repmat(mean(Temp.test,1),size(Temp.test));
% TrStd_Sub = repmat(std(Temp.train,1),size(Temp.train));    % all sub std
% TeStd_Sub = repmat(std(Temp.test,1),size(Temp.test));

% Mean_TrStd = repmat(mean(temp_TrStd),size(Temp.train));
% Mean_TeStd = repmat(mean(temp_TeStd),size(Temp.test));
% Std_TrStd = repmat(std(temp_TrStd),size(Temp.train));
% Std_TeStd = repmat(std(temp_TeStd),size(Temp.test));

% model.train(:,1) = (Temp.train-TrMean_Sub) ./ TrStd_Sub;
% model.train(:,2) = (temp_TrStd-Mean_TrStd) ./ Std_TrStd;
% 
% model.test(:,1) = (Temp.test-TeMean_Sub) ./ TeStd_Sub;
% model.test(:,2) = (temp_TeStd-Mean_TeStd) ./ Std_TeStd;

%model Label

end