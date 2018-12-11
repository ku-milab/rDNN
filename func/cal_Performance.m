 function [performance]= cal_Performance(Predicted, Labels, pre)
    Positive_idx = find(Labels==1);
    Negative_idx = find(Labels~=1);
    

    TP = sum(Labels(Positive_idx) == Predicted(Positive_idx));
    TN = sum(Labels(Negative_idx) == Predicted(Negative_idx));
    
    FP = sum(Labels(Positive_idx) ~= Predicted(Positive_idx));
    FN = sum(Labels(Negative_idx) ~= Predicted(Negative_idx));

    PPV = TP / (TP + FP);
    NPV = TN / (FN + TN);
%     
    Acc =  (TP + TN) / size(Labels,1);
    
    Tpr = TP / (TP + FN);
    Fpr = FP / (FP + TN);
    
    Auc = Fpr / Tpr;
    
   
%     Sen = TP / (TP + FN);
%     Spe = TN / (FP + TN);
% %     AUC = Sen / Spe;
    Predicted(Predicted==2) = 0;
    Labels(Labels==2) = 0;
    CP=classperf(Labels, Predicted, 'Positive', 1, 'Negative', 0);
    
    [X,Y,T,AUC] = perfcurve(Labels, pre(:,1), 1);
    
    Sensitivity=CP.Sensitivity*100;
    Specificity=CP.Specificity*100;

%     Sen = TP / (TP + FN);
%     Spe = TN / (FP + TN);
% %     AUC = Sen / Spe;
    
    performance.PPV = PPV;
    performance.NPV = NPV;
    performance.ACC = Acc*100;
    performance.SEN = Sensitivity;
    performance.SPE = Specificity;
    performance.AUC = AUC;
    
end