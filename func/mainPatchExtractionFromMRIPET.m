function mainPatchExtractionFromMRIPET( type, tissue, wsize, imageSize, folder, bSaveIntermediateResults )

patchPath = fullfile( '.', 'temp', 'selectedPatches', ['winSize_', num2str(wsize)], 'selected_' );

%% load dataset
if strcmp( type, 'SPMCI' )
    eval( ['load ', fullfile( '.', 'Data', ['pMCI_', tissue, 'Data.mat'] )] );
    eval( ['load ', fullfile( '.', 'Data', ['sMCI_', tissue, 'Data.mat'] )] );
    patient = pMCI_data;
    normal = sMCI_data;
    clear pMCI_data sMCI_data;
    mriImgData = [patient normal];
    clear patient normal;
    
    eval( ['load ', fullfile( '.', 'Data', 'pMCI_PETData.mat' )] );
    eval( ['load ', fullfile( '.', 'Data', 'sMCI_PETData.mat' )] );
    patient = pMCI_data;
    normal = sMCI_data;
    clear pMCI_data sMCI_data;
    petImgData = [patient normal];
    
    imgLabel = zeros( 2, size(mriImgData, 2) );
    imgLabel(1, 1:size(patient, 2)) = 1;
    imgLabel(2, size(patient, 2)+1:end) = 1;
    clear patient normal;
else
    eval( ['load ', fullfile( '.', 'Data', [type, '_', tissue, 'Data.mat'] )] );
    eval( ['load ', fullfile( '.', 'Data', ['NC_', tissue, 'Data.mat'] )] );
    eval( ['patient = ', type, '_data;'] );
    normal = NORMAL_data;
    eval( ['clear ', type, '_data', ' NORMAL_data'] );
    mriImgData = [patient normal];
    clear patient normal;
    
    eval( ['load ', fullfile( '.', 'Data', [type, '_PETData.mat'] )] );
    eval( ['load ', fullfile( '.', 'Data', 'NC_PETData.mat' )] );
    eval( ['patient = ', type, '_data;'] );
    normal = NORMAL_data;
    eval( ['clear ', type, '_data', ' NORMAL_data'] );
    petImgData = [patient normal];
    
    imgLabel = zeros( 2, size(mriImgData, 2) );
    imgLabel(1, 1:size(patient, 2)) = 1;
    imgLabel(2, size(patient, 2)+1:end) = 1;
    clear patient normal;
end



randn('state', 100);
rand('state', 100);


%%

totalNumData = size(mriImgData, 2);
rndIdx = randperm( totalNumData );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% 10-fold cross-validation
numDataPerFold = floor( totalNumData/10 );
pvalue_threshold = 0.05;

for cv=1:10
    disp( ['******* CV ', num2str(cv), ' *******'] );
    if cv < 10
        testIdx = rndIdx( (cv-1)*numDataPerFold+1:cv*numDataPerFold );
    else
        testIdx = rndIdx( (cv-1)*numDataPerFold+1:end );
    end
    
    trainIdx = setdiff( 1:totalNumData, testIdx );
    
    mriTrainData = mriImgData(:, trainIdx);
    petTrainData = petImgData(:, trainIdx);
    
    trainLabel = imgLabel(:, trainIdx);
    
    %% MRI
    % ignore background voxels
    mriForegroundVoxels = find( sum(mriTrainData, 2)>1 );
    mriPvals = ones( size(mriTrainData, 1), 1 );
    
    % perform statistical test
    mriSubPvals = statisticalGroupDifference( mriTrainData(mriForegroundVoxels, :), trainLabel ); % ttest each group
    
    % ignore voxels which are statistically insignificant
    idx = find(mriSubPvals < pvalue_threshold);
    mriSigniticantVoxels = mriForegroundVoxels(idx);
    mriPvals(mriSigniticantVoxels) = mriSubPvals(idx);
    
    % compute the mean p-value of a patch centered at the current voxel
    mriMeanPV = computeMeanPValue( mriSigniticantVoxels, mriPvals, wsize, imageSize );
    
    %% both MRI and PET
    meanPV = [mriMeanPV petMeanPV];
    voxels = [mriSigniticantVoxels; petSigniticantVoxels];
    indModality = [ones(length(mriSigniticantVoxels), 1); -ones(length(petSigniticantVoxels), 1)];
    
    randIdx = randperm( length(meanPV) );
    meanPV = meanPV( randIdx );
    voxels = voxels( randIdx );
    indModality = indModality( randIdx );
    % select patched with the rules described in the paper
    [patches{cv}, selectedVoxels{cv}, selected{cv}] = selectPatches( meanPV, voxels, wsize, imageSize, indModality );
end

if bSaveIntermediateResults == 1
    disp( 'Saving the selected patches...' );
    eval( ['save ', patchPath, type, '_Multimodal_', tissue, '_Patches_', folder, '.mat patches selected'] );
    disp( 'Saving the selected patches is done...' );
end

