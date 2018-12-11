function make_CV_idx(opt, num_type1, num_type2)

type1_fold = crossvalind('Kfold', num_type1, opt.nfold);
type2_fold = crossvalind('Kfold', num_type2, opt.nfold);

for fold = 1 : opt.nfold
    type1_te_fold{fold,1} = (type1_fold == fold);
    tmpfold = type1_fold((type1_fold~=fold));
    type1_val_fold{fold,1} = (type1_fold == tmpfold(1,1));
    type1_tr_fold{fold,1} = ( (type1_fold~=tmpfold(1,1)) & (type1_fold~=fold));
    
    type2_te_fold{fold,1} = (type2_fold == fold);
    tmpfold = type2_fold((type2_fold~=fold));
    type2_val_fold{fold,1} = (type2_fold == tmpfold(1,1));
    type2_tr_fold{fold,1} = ( (type2_fold~=tmpfold(1,1)) & (type2_fold~=fold));
    
    save(sprintf('./Save_result/%s/crossValidation_idx.mat',opt.ex), 'type1_fold', 'type2_fold','type1_te_fold','type1_val_fold','type1_tr_fold','type2_te_fold','type2_val_fold','type2_tr_fold' )
end
%% make shuffle index
for fold = 1 : opt.nfold
    tef_size = (sum(type1_te_fold{fold})+sum(type2_te_fold{fold}));
    trf_size = (sum(type1_tr_fold{fold})+sum(type2_tr_fold{fold}));
    val_size = (sum(type1_val_fold{fold})+sum(type2_val_fold{fold}));
    
    test_ran{fold} = randperm(tef_size);  % shuffle
    train_ran{fold} = randperm(trf_size); % shuffle
    val_ran{fold} = randperm(val_size);   % shuffle
end
save(sprintf('./Save_result/%s/Shuffle_idx.mat',opt.ex),'train_ran','test_ran','val_ran');







end