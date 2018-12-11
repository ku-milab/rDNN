function [model] = multiKernelSVM_allRV(kernel, cvgrid, trainData, trainLabels,weights)

addpath( genpath( fullfile( '..', 'libsvm-mat-3.21','matlab' ) ) );
% addpath( genpath( fullfile( '..', 'toolboxes', 'liblinear-2.1','matlab' ) ) );
% trainData and testData are cells.
% trainLabels and testLabels are vectors

%%
if size(trainLabels, 1) == 1
    trainLabels = trainLabels';
end



if ~isempty(weights) && length(trainData)-1 ~= length(weights)
    fprintf( 2, 'The number of the weights and the number of modalities mismatch.\n' );
    fprintf( 2, 'THe number of the weights should be equal to the number of modalities minus one.\n' );
end


cv_errs = [];
opt_g   = [];
opt_c   = [];


%% Optimal parameters selection (for libsvm with option '-v', which is cross-validation, the output of svmtrain is just cv accuracy)
cv_acc = zeros(cvgrid.C_TIMES, cvgrid.gamma_TIMES);
for c_count = 1:cvgrid.C_TIMES
    if(cvgrid.C_TIMES == 1)
        c_val = cvgrid.MIN_C;
    else
        c_val = cvgrid.MIN_C + ( 1.0 * ( (cvgrid.MAX_C - cvgrid.MIN_C) * (c_count - 1) / (cvgrid.C_TIMES - 1) ) );
    end
    
    
    for g_count = 1:cvgrid.gamma_TIMES
        if(cvgrid.gamma_TIMES == 1)
            g_val = cvgrid.MIN_gamma;
        else
            g_val = cvgrid.MIN_gamma + ( 1.0 * ( (cvgrid.MAX_gamma - cvgrid.MIN_gamma) * (g_count - 1) / (cvgrid.gamma_TIMES - 1) ) );
        end
    
        trainKernel = cell(length(trainData), 1);
        
        for k=1:length(trainData)
            % training set
            trainKernel{k} = calckernel(kernel, 10^(g_val), trainData{k});              

        end

        % Weighted combination of the multiple kernels
        combinedTrainKernel = (1-sum(weights))*trainKernel{end};
        if ~isempty(weights)
            for k=1:length(weights)
                combinedTrainKernel = combinedTrainKernel + weights(k)*trainKernel{k};
            end
        end

        switch kernel
            case 'rbf'
                opt = ['-q -t 4 -h 0 -e 0.001 -w1 1.0 -c ', num2str(2^(c_val)), ' -g ', num2str(10^(g_val)), ' -v ', num2str(cvgrid.FOLD_NUM)];
                cv_acc(c_count, g_count) = svmtrain_libsvm(trainLabels, [(1:length(trainLabels))',combinedTrainKernel], opt);
            case 'linear'
                opt = ['-q -t 4 -h 0 -e 0.001 -w1 1.0 -c ', num2str(2^(c_val)), ' -v ', num2str(cvgrid.FOLD_NUM)];
                cv_acc(c_count, g_count) = svmtrain_libsvm(trainLabels, [(1:length(trainLabels))', combinedTrainKernel], opt);
        end
    end % g_count
end % c_count


%% Searching for the optimal parameters

max_cv_acc = max(max(cv_acc)); 
cv_err = 1 - max_cv_acc/100; %%% Maximum classification accuracy;
cv_errs = [cv_errs; cv_err];
acc_index = [];
for i=1:size(cv_acc,1)
   for j=1:size(cv_acc,2)
       if(cv_acc(i,j)==max_cv_acc)
           acc_index = [acc_index; [i j]]; 
       end
   end
end

med_index = median(acc_index,1);
diff = sum((acc_index - repmat(med_index,size(acc_index,1),1)).^2,2);
[yy,I] = min(diff);
opt_index = acc_index(I,:);
opt_c_index = opt_index(1,1); 
opt_gamma_index = opt_index(1,2);


if(cvgrid.C_TIMES==1)
    Opt_c = cvgrid.MIN_C;
else
    Opt_c = cvgrid.MIN_C + ( 1.0 * ( cvgrid.MAX_C - cvgrid.MIN_C ) * ( opt_c_index - 1 ) / ( cvgrid.C_TIMES - 1 ) );
end
    
if(cvgrid.gamma_TIMES==1)
    Opt_gamma = cvgrid.MIN_gamma;
else
    Opt_gamma = cvgrid.MIN_gamma + ( 1.0 * ( cvgrid.MAX_gamma - cvgrid.MIN_gamma ) * ( opt_gamma_index - 1 ) / ( cvgrid.gamma_TIMES - 1 ) );
end

opt_g = [opt_g; Opt_gamma];
opt_c = [opt_c; Opt_c];


%% SVM model construction

switch kernel
    case 'rbf'
        opt = ['-q -t 4 -h 0 -e 0.001 -w1 1.0 -c ', num2str(2^(Opt_c)), ' -g ', num2str(10^(Opt_gamma))];
        model = svmtrain_libsvm(trainLabels, [(1:length(trainLabels))', combinedTrainKernel], opt);
    case 'linear' % "-t 4": using predefined kernel
        opt = ['-q -t 4 -h 0 -e 0.001 -w1 1.0 -c ', num2str(2^(Opt_c))];
        model = svmtrain_libsvm(trainLabels, [(1:length(trainLabels))', combinedTrainKernel], opt);
end
    
end