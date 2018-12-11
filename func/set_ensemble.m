function ens = set_ensemble(res)

cvNum = size(res,2);

for cv = 1 : cvNum
    fprintf('\n cvNum = %d\n',cv);
    
    ensemble_train = [];
    ensemble_test = [];
    
    model = concate(res,cv);
    
    ensemble_train = cat(2,ensemble_train,model.train);
    ensemble_test = cat(2,ensemble_test,model.test);
    
    ens{cv}.train = ensemble_train;
    ens{cv}.test = ensemble_test;
    ens{cv}.trLabel = model.trLabel;
    ens{cv}.teLabel = model.teLabel;
end

end


function model = concate(res,cv)
temp_resTrain = [];
temp_resTest = [];

for i = 1 : size(res.train,2)
    
    if ~isnan(res.train{1,i}(:,1))
        temp_resTrain = cat(2,temp_resTrain,res.train{1,i}(:,1));
        temp_resTest = cat(2,temp_resTest,res.test{1,i}(:,1));
    end
end

%% mean ====================================================================
model.train = mean(temp_resTrain,2);
model.test = mean(temp_resTest,2);

model.trLabel = res.trainLabel(:,1);
model.teLabel = res.testLabel(:,1);

end

