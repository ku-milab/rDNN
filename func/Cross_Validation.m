function [C1_te_fold, C1_val_fold, C1_tr_fold, C2_te_fold,C2_val_fold, C2_tr_fold, test_ran, train_ran, val_ran] = Cross_Validation(C1_size, C2_size, opts)


    C1_fold = crossvalind('Kfold', C1_size, opts.nfold); 
    C2_fold = crossvalind('Kfold', C2_size, opts.nfold);
    
    for fold = 1 : 10
        C1_te_fold{fold,1} = (C1_fold == fold);
        tmpfold = C1_fold((C1_fold~=fold));
        C1_val_fold{fold,1} = (C1_fold == tmpfold(1,1));
        C1_tr_fold{fold,1} = ( (C1_fold~=tmpfold(1,1)) & (C1_fold~=fold));

        C2_te_fold{fold,1} = (C2_fold == fold);
        tmpfold = C2_fold((C2_fold~=fold));
        C2_val_fold{fold,1} = (C2_fold == tmpfold(1,1));
        C2_tr_fold{fold,1} = ( (C2_fold~=tmpfold(1,1)) & (C2_fold~=fold));    

    end
    %% make shuffle index
    for fold = 1 : opts.nfold
        tef_size = (sum(C1_te_fold{fold})+sum(C2_te_fold{fold}));
        trf_size = (sum(C1_tr_fold{fold})+sum(C2_tr_fold{fold}));
        val_size = (sum(C1_val_fold{fold})+sum(C2_val_fold{fold}));
        
        test_ran{fold} = randperm(tef_size);  % shuffle
        train_ran{fold} = randperm(trf_size); % shuffle
        val_ran{fold} = randperm(val_size);   % shuffle
    end

end
   