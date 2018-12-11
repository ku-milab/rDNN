function ens = set_ensemble(ex,opts)

for cv = 1 :  opts.nfold
    fprintf('\n cvNum = %d\n',cv);
    
    %     ensemble_train = [];
    %     ensemble_test = [];
    
    
    
    load('ROI_info.mat');
    for roi = 1 : size(ROI_info,1)
        model = calMean(ex,cv,roi);
        allROIData = cat(2,allROIData,model);
    end
    
    
    %     ensemble_train = cat(2,ensemble_train,model.train);
    %     ensemble_test = cat(2,ensemble_test,model.test);
    %
    %
    %     ens{cv}.train = ensemble_train;
    %     ens{cv}.test = ensemble_test;
    %     ens{cv}.trLabel = model.trLabel;
    %     ens{cv}.teLabel = model.teLabel;
end

end


function model = calMean(ex,cv,roi)

temp_resTrain = [];
temp_resTest = [];

loadPath = load(sprintf('Save_result/%s/fold%d/%s_f%dROI_%d.mat',ex,cv,ex,cv,ROI_info{roi,1}));
load(loadPath);

for i = 1 : size(res.train,2)
    temp_resTrain = cat(2,temp_resTrain,res.train{i,1}(:,1));
    temp_resTest = cat(2,temp_resTest,res.test{i,1}(:,1));
end

model.train = mean(temp_resTrain,2);
model.test = mean(temp_resTest,2);


end



% TrMean_Sub = repmat(mean(Temp.train,1),size(Temp.train));  % all sub mean
% TeMean_Sub = repmat(mean(Temp.test,1),size(Temp.test));
% TrStd_Sub = repmat(std(Temp.train,1),size(Temp.train));    % all sub std
% TeStd_Sub = repmat(std(Temp.test,1),size(Temp.test));
% temp_TrStd = std(temp_resTrain,0,2);
% temp_TeStd = std(temp_resTest,0,2);
% Mean_TrStd = repmat(mean(temp_TrStd),size(Temp.train));
% Mean_TeStd = repmat(mean(temp_TeStd),size(Temp.test));
% Std_TrStd = repmat(std(temp_TrStd),size(Temp.train));
% Std_TeStd = repmat(std(temp_TeStd),size(Temp.test));
% 
% model.train(:,1) = (Temp.train-TrMean_Sub) ./ TrStd_Sub;
% model.train(:,2) = (temp_TrStd-Mean_TrStd) ./ Std_TrStd;
% model.test(:,1) = (Temp.test-TeMean_Sub) ./ TeStd_Sub;
% model.test(:,2) = (temp_TeStd-Mean_TeStd) ./ Std_TeStd;

%model Label
% model.trLabel = loadData.cvRes{1,cv}{1,1}.trainLabel;
% model.teLabel = loadData.cvRes{1,cv}{1,1}.testLabel;
