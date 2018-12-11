function [predicted, accuracy, w, model] = buildClassifier_L1_RV( trainFeatures, trainLabel, testFeatures, testLabel, weights )


trainLabel(trainLabel~=1) = -1;
testLabel(testLabel~=1)= -1;
% Gaussian normalization
% [trainFeatures{1}, testFeatures{1}, ~] = gaussianNormalization( trainFeatures{1}, testFeatures{1}, [] );

%================ SVC parameters ================%
kernel             = 'linear';

cvgrid.MAX_C       = 5;   % Tuning C only +5;
cvgrid.MIN_C       = -5;   % -10
cvgrid.C_TIMES     = 11;

cvgrid.MAX_gamma   = 0;   % Tuning gamma only 0;
cvgrid.MIN_gamma   = 0;   % -10
cvgrid.gamma_TIMES = 1;

cvgrid.FOLD_NUM    = 5;    % k-fold CV;
%================================================%

[predicted, acc, w, model] = multiKernelSVM_L1_RV(kernel, cvgrid, trainFeatures, trainLabel, testFeatures, testLabel, weights);
%[predicted, acc, w] = multiKernelSVM( kernel, cvgrid, trainFeatures, trainLabel, testFeatures, testLabel, weights );

accuracy = acc(1);
% end