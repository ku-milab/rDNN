function [p_value,Thresh_idx] = stat_map(Data_Path,className,Template_ROI_idx, threshold, ROI_info, type1_CV, type2_CV)

%%
% Data_Path = '/media/hisuk/BigHHD/ADNI/Ravens_density_';
% Load data
% /media/hisuk/BigHHD/ADNI/Ravens_density_MCI
%  className = {'MCI', 'NC'};
% classDataName = {'MCI', 'NORMAL'};
ClassDataName = {'AD', 'NORMAL'};
for c=1:length(ClassDataName)
    dataPath = fullfile( Data_Path,['Ravens_density_', className{c}] );
    s = what(dataPath);
    for roi = 1 : length(ROI_info)
        classData{c}{roi,1} = zeros(length(Template_ROI_idx{roi,1}), numel(s.mat));
        
        fprintf( 'Load %s %d data:\n', className{c}, numel(s.mat) );
        for n=1:numel(s.mat)
            fprintf( '.' );
            fname = fullfile( dataPath, char(s.mat(n)) );
            mriData = load( fname );
            temp = eval( ['mriData.RavensMap_', ClassDataName{c}] );
            classData{c}{roi,1}(:, n) = temp( Template_ROI_idx{roi,1} );
            clear mriData temp;
            if mod(n, 50) == 0
                fprintf( '%d_ROI%d\n', n ,ROI_info(roi,1) );
            end
        end
        fprintf( '%d\n', n );
    end
end
% Do statistical test
% 
% for roi = 1 : 93
%     [h, p{roi,1}] = ttest2( classData{1}{roi,1}', classData{2}{roi,1}' );
%     rejected{roi,1} = find( h==0 );
%     p{roi,1}(rejected{roi,1}) = 0;
%     
%     Thresh_idx = Template_idx{roi,1}((p{roi}~=0));
% end
% 

% 
% scaledPValue = convert2LogScale( p );
% saveToImage( 'all_Statistic_Map', scaledPValue, Template_ROI_idx );


%%
% type1_CV = crossvalind( 'Kfold', size(classData{1}{roi}, 2), 10 );
% type1_CV = crossvalind( 'Kfold', size(classData{2}{roi}, 2), 10 );

for cv=1 : 10    
    for roi=1 : length(ROI_info)
        train1 = find( type1_CV{cv,1} );
        train2 = find( type2_CV{cv,1});
        [h1{roi,1}, p1{roi,1}] = ttest2( classData{1}{roi,1}(:, train1)', classData{2}{roi,1}(:, train2)', 'alpha', threshold );
        
        if any(isnan(h1{roi,1}))
            h1{roi,1}(isnan(h1{roi,1})) = 0;
        end
        rejected1 = find( h1{roi,1}==0 );
        
        p1{roi,1}(rejected1) = 0;
        
        Thresh_idx{cv}{roi,1} = Template_ROI_idx{roi,1}( (p1{roi,1}~=0) );
    end    
end
p_value = p1;

end
%%

%%
% templateFileName = fullfile( '..', 'Template', 'jakob-label-axialdown-256_256_256.img' );

%%
% templateFileName = fullfile( '.','Template', 'jakob-label-axialdown-256_256_256.img' );
% fid = fopen( templateFileName, 'r' );
% roiLabelImage = fread( fid, 'uint8' );
% fclose( fid );
% 
% roiFileName = fullfile( '..', 'Template', 'ROI_info.mat' );
% 
% load('ROI_info.mat');
% 
% Template_idx = [];
% for r=1:length(ROI_info)
%     idx = find( roiLabelImage==ROI_info(r) );
%     Template_idx{r,1} = idx;
%     Template_idx{r,2} = ROI_info(r); 
% end
% validVoxels = sort( validVoxels, 'ascend' );
% fid = fopen( templateFileName, 'r' );
% roiLabelImage = fread( fid, 'uint8' );
% fclose( fid );
% 
% % roiFileName = fullfile( '..', 'Template', 'ROI_info.mat' );
% 
% validVoxels = [];
% for r=1:length(ROI_info)
%     idx = find( roiLabelImage==ROI_info(r) );
%     validVoxels = [validVoxels; idx];
% end
% validVoxels = sort( validVoxels, 'ascend' );
% 
% %%
% % Load data
% className = {'MCI', 'NC'};
% classDataName = {'MCI', 'NORMAL'};
% for c=1:length(className)
%     dataPath = fullfile( '.', ['Ravens_density_', className{c}] );
%     s = what(dataPath);
%     classData{c} = zeros(length(validVoxels), numel(s.mat));
%     
%     fprintf( 'Load %s %d data:\n', className{c}, numel(s.mat) );
%     for n=1:numel(s.mat)
%         fprintf( '.' );
%         fname = fullfile( dataPath, char(s.mat(n)) );
%         mriData = load( fname );
%         temp = eval( ['mriData.RavensMap_', classDataName{c}] );
%         classData{c}(:, n) = temp( validVoxels );
%         clear mriData temp;
%         if mod(n, 50) == 0
%             fprintf( '%d\n', n );
%         end
%     end
%     fprintf( '%d\n', n );
% end
% 
%