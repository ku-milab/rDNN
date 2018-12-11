function [accuracy,Sensitivity,Specificity,ROC,AUC] = buildClassifier( ens , kernel_state )
% trainFeatures, trainLabel, testFeatures, testLabel
% % Gaussian normalization
% for i=1:size(trainFeatures,2)
% mu = mean( trainFeatures{i} );
% var = std( trainFeatures{i} );
% trainFeatures{i} = trainFeatures{i} - repmat(mu, [size(trainFeatures{i}, 1), 1]);
% trainFeatures{i} = trainFeatures{i} ./ repmat( var, [size(trainFeatures{i}, 1), 1]);
% 
% testFeatures{i} = testFeatures{i} - repmat(mu, [size(testFeatures{i}, 1), 1]);
% testFeatures{i} = testFeatures{i} ./ repmat( var, [size(testFeatures{i}, 1), 1]);
% end

%======================================================================
% Gaussian normalization
% mu = mean( trainFeatures{1} );
% var = std( trainFeatures{1} );
% trainFeatures{1} = trainFeatures{1} - repmat(mu, [size(trainFeatures{1}, 1), 1]);
% trainFeatures{1} = trainFeatures{1} ./ repmat( var, [size(trainFeatures{1}, 1), 1]);
% 
% testFeatures{1} = testFeatures{1} - repmat(mu, [size(testFeatures{1}, 1), 1]);
% testFeatures{1} = testFeatures{1} ./ repmat( var, [size(testFeatures{1}, 1), 1]);

%
trainFeatures{1} = double(ens.train);
trainLabel = double(ens.trLabel(:,1));
trainLabel(trainLabel~=1) = -1;
testFeatures{1} = double(ens.test);
testLabel= double(ens.teLabel(:,1));
testLabel(testLabel~=1)= -1;
%
% %================ SVC parameters ================%
% kernel             = 'linear';
kernel             = kernel_state;
       
% c is 2^5~ 2^-5  num 10 
C                  = 5; % Cvalue
cvgrid.MAX_C       = C;   % Tuning C only +5;
cvgrid.MIN_C       = -C;   % -10
cvgrid.C_TIMES     = 15;

cvgrid.MAX_gamma   = 0;   % Tuning gamma only 0;
cvgrid.MIN_gamma   = 0;   % -10
cvgrid.gamma_TIMES = 1;

cvgrid.FOLD_NUM    = 5;    % k-fold CV;
%================================================%


[predicted_label, acc, w] = multiKernelSVM( kernel, cvgrid, trainFeatures, trainLabel, testFeatures, testLabel, [] );

predicted_label(predicted_label < 0 ) = 0;
testLabel(testLabel < 0)= 0;

CP=classperf(testLabel, predicted_label, 'Positive', 1, 'Negative', 0);

[X,Y,T,AUC] = perfcurve(testLabel, w, 1);

Sensitivity=CP.Sensitivity*100;
Specificity=CP.Specificity*100;

ROC.X = X;
ROC.Y = Y;

 accuracy = acc(1);

% if accuracy == 1
%     fprintf( 'Correct...\n' );
% else
%     fprintf( 2, 'Incorrect...\n' );
% end