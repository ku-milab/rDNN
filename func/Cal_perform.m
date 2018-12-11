function [perf,performance, w,model] = Cal_perform(Data)

cvNum = size(Data,2);
% for fold = 1 : cvNum

for fold = 1 : cvNum
    kernel_state = 'linear';
    [accuracy_l,Sensitivity_l,Specificity_l,ROC_l,AUC_l, w.linear{fold}, model.linear{fold}] = buildClassifier( Data{fold} , kernel_state );
    %     [accuracy_l,Sensitivity_l,Specificity_l,ROC_l,AUC_l] = buildClassifier( ens{1,fold} , kernel_state );
    perf.Accuracy_l(fold)    = accuracy_l;
    perf.Sensitivity_l(fold) = Sensitivity_l ;
    perf.Specificity_l(fold) = Specificity_l ;
    perf.ROC_l(fold)         = ROC_l;
    perf.AUC_l(fold)         = AUC_l;
    
    kernel_state = 'rbf';
    [accuracy_r,Sensitivity_r,Specificity_r,ROC_r,AUC_r, w.rbf{fold}, model.rbf{fold}] = buildClassifier( Data{fold} , kernel_state );
    %     [accuracy_r,Sensitivity_r,Specificity_r,ROC_r,AUC_r] = buildClassifier( ens{1,fold} , kernel_state );
    
    perf.Accuracy_r(fold)    = accuracy_r;
    perf.Sensitivity_r(fold) = Sensitivity_r ;
    perf.Specificity_r(fold) = Specificity_r ;
    perf.ROC_r(fold)         = ROC_r;
    perf.AUC_r(fold)         = AUC_r;
end

performance = [];
for fold = 1: cvNum
    performance.linear(fold).acc = perf.Accuracy_l(fold);
    performance.linear(fold).sen = perf.Sensitivity_l(fold);
    performance.linear(fold).spc = perf.Specificity_l(fold);
    performance.linear(fold).auc = perf.AUC_l(fold);
    performance.linear(fold).roc = perf.ROC_l(fold);
    
    performance.rbf(fold).acc = perf.Accuracy_r(fold);
    performance.rbf(fold).sen = perf.Sensitivity_r(fold);
    performance.rbf(fold).spc = perf.Specificity_r(fold);
    performance.rbf(fold).auc = perf.AUC_r(fold);
    performance.rbf(fold).roc = perf.ROC_r(fold);
end

performance.linear(fold+1).acc = mean(perf.Accuracy_l);
performance.linear(fold+1).sen = mean(perf.Sensitivity_l);
performance.linear(fold+1).spc = mean(perf.Specificity_l);
performance.linear(fold+1).auc = mean(perf.AUC_l);
performance.linear(fold+1).roc = 'Average';

performance.rbf(fold+1).acc =  mean(perf.Accuracy_r);
performance.rbf(fold+1).sen =  mean(perf.Sensitivity_r);
performance.rbf(fold+1).spc =  mean(perf.Specificity_r);
performance.rbf(fold+1).auc =  mean(perf.AUC_r);
performance.rbf(fold+1).roc = 'Average';



% perfCell.linear.acc(f+1) = perform_mean.accuracy_l;
% perfCell.linear.sen(f+1) = perform_mean.sensitivity_l;
% perfCell.linear.spc(f+1) = perform_mean.specificity_l;
% perfCell.linear.auc(f+1) = perform_mean.AUC_l;
% perfCell.linear.roc(f+1) = 'Average';


%%

performance.linear(fold+2).acc = std(perf.Accuracy_l);
performance.linear(fold+2).sen = std(perf.Sensitivity_l);
performance.linear(fold+2).spc = std(perf.Specificity_l);
performance.linear(fold+2).auc = std(perf.AUC_l);
performance.linear(fold+2).roc = 'STD';

performance.rbf(fold+2).acc = std(perf.Accuracy_r);
performance.rbf(fold+2).sen = std(perf.Sensitivity_r);
performance.rbf(fold+2).spc = std(perf.Specificity_r);
performance.rbf(fold+2).auc = std(perf.AUC_r);
performance.rbf(fold+2).roc = 'STD';



end
