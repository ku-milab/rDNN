function opts = init_para()

%     opts.learning_rate = 0.01;
%     opts.batch_size = 50;
    opts.nfold = 10;
    
    opts.ae_learningRate = 0.03;
    opts.sae_numepochs = 120;
    opts.sae_batchsize = 50;
    opts.inputZeroMaskedFraction = 0.5;
    opts.sae_plot = 0;
    
%     option.sae_numepochs;
%     option.sae_batchsize;
%     option.sae_plot;
    
    opts.nn_validation = 1;
%     opts.nn_numepochs = 120;
    opts.nn_numepochs = 150; % change
    opts.nn_batchsize = 50;
    opts.nn_learningRate = 0.003;
    % opts.nn_learningRate = 0.003;
    opts.nn_plot = 0;
    
end