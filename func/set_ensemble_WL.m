function ens = set_ensemble_WL(res,opts)

ensemble_train = [];
ensemble_test = [];
CV_size = size(res,2);
for CV = 1: CV_size
    model{CV} = model_Mean(res,opts,CV);
    
    ens{CV}.train = model{CV}.train;
    ens{CV}.test = model{CV}.test;
    ens{CV}.trLabel = model{CV}.trLabel;
    ens{CV}.teLabel = model{CV}.teLabel;
end

%     ensemble_train = cat(2,ensemble_train,model{CV}.train);
%     ensemble_test = cat(2,ensemble_test,model{CV}.test);

% ens.train = ensemble_train;
% ens.test = ensemble_test;
% ens.trLabel = model.trLabel;
% ens.teLabel = model.teLabel;



end
