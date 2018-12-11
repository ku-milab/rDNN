
Ens = [];
load ROI_info.mat
ex = 'ex170429_';
% R = ROI number
fold = 10;
for cv = 1 : fold
    for R = 1 : size(ROI_info,1)
        ROI_num = ROI_info(R);
        loadPath = sprintf('Save_result/%s/fold%d/%s_f%dROI_%d.mat',ex,fold,ex,fold,ROI_num);
        load(loadPath);
        
        mean_set = set_ensemble(res);
        
        
        %         if sum(isnan(mean_set{1,cv}.train))
        %             temp_train = 0.5;
        %             temp_test = 0.5;
        %         elseif ~size(mean_set{1,cv}.train,1)
        %              temp_test = 0.5;
        %              temp_train = 0.5;
        %         else
        temp_train = mean_set{1,cv}.train;
        temp_test = mean_set{1,cv}.test;
        %         end
        
        Ens{cv}.train(:,R) = temp_train;
        Ens{cv}.test(:,R) = temp_test;
        Ens{cv}.trLabel = mean_set{1,cv}.trLabel;
        Ens{cv}.teLabel = mean_set{1,cv}.teLabel;
        
    end
end

EnsAD = Ens{cv}.train((Ens{cv}.trLabel == 1),:);
EnsNC = Ens{cv}.train((Ens{cv}.trLabel == 0),:);

[h,p] = ttest2(EnsAD,EnsNC);
p((isnan(p)==1))=1;
% for cv = 1 : 1
    %     Ens{cv}.train = 1-Ens{cv}.train;
    %     Ens{cv}.test = 1-Ens{cv}.test;
    Ens_p{cv}.train = Ens{cv}.train(:,p<0.5);
    Ens_p{cv}.test = Ens{cv}.test(:,p<0.5);
    Ens_p{cv}.trLabel = Ens{cv}.trLabel;
    Ens_p{cv}.teLabel = Ens{cv}.teLabel;
% end

Ens{1,1}.train = double(Ens{1,1}.train);
Ens{1,1}.test = double(Ens{1,1}.test);


acc = 0;
for cv = 1 : 1
    trainFeatrues{1} = sparse(double(Ens{cv}.train));
    testFeatures{1} = sparse(double(Ens{cv}.test));
    
    [predicted, accuracy, w, model] = buildClassifier_L1_RV( trainFeatrues, Ens{cv}.trLabel, testFeatures, Ens{cv}.teLabel, []);
    
    acc = acc+accuracy;
    
end

m = acc/10;
% if ttest2(EnsAD,EnsNC);
Ens_p{1}.train = double(Ens_p{1}.train);
Ens_p{1}.test = double(Ens_p{1}.test);
[perf, perform_mean,performance] = Cal_perform(Ens_p{1});
plot(performance.linear(1).roc.X,performance.linear(1).roc.Y)

trF = [];
teF = [];
trLabel = [];
teLabel = [];

for cv = 1 : 10
    trF = [trF; Ens{cv}.train];
    testF = [testF; Ens{cv}.test];
    trLabel = [trLabel; Ens{cv}.trLabel];
    teLabel = [teLabel; Ens{cv}.teLabel];
end

trainF{1} = sparse(Ens{1}.train);
[model] = buildClassifier_allRV( trainF, trLabel,[]);


SVlabel = trLabel( model.sv_indices );
SValpha = model.sv_coef;
SVdata = trF( model.sv_indices, : );
SVM_weight = (SVlabel.*SValpha)'*SVdata;





