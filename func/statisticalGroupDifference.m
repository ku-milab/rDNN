function pvals = statisticalGroupDifference( trainData, trainLabel )
% trainData(voxels, samples)
% trainLabel(classes, samples)

disp( 'Perform t-test for statistical group difference...' );

patients = find( trainLabel(1, :) == 1 );
normal = find( trainLabel(2, :) == 1 );


x = double(trainData(:, patients));
y = double(trainData(:, normal));
    
[~, pvals] = ttest2( x', y' );

pvals( isnan(pvals) ) = 1;
