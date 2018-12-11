function [p_value,Thresh_idx] = stat_map2(Data_Path,className,Template_ROI_idx, ROI_info, type1_CV, type2_CV, opt)
classData = [];


for c=1:length(className)
%     dataPath = fullfile( '..','ADAI',['RavensMap_', className{c},'_mat'] );
        if c == 1
            dataPath = fullfile( opt.type1_Data_Path );
        else
            dataPath = fullfile( opt.type2_Data_Path );
        end
            
    s = what(dataPath);
    
    for roi = 1 : length(ROI_info)
        classData{c}{roi,1} = zeros(length(Template_ROI_idx{roi,1}), numel(s.mat));
    end
    
    for n = 1 : numel(s.mat)
        fprintf('.');
        fname = fullfile( dataPath, char(s.mat(n)) );
        mriData = load( fname );
%         temp = eval( ['mriData.', classDataName{c},'_Ravens_Map']);
            temp = eval( ['mriData.RavensMap_', classDataName{c}] );

        for roi = 1 : length(ROI_info)
            classData{c}{roi,1}(:, n) = temp( Template_ROI_idx{roi,1} );
        end
        clear mriData temp;
        if mod(n, 50) == 0
            fprintf( '%d_ROI%d\n', n ,ROI_info(roi,1) );
        end
    end
    fprintf( '%d\n', n );
end

for cv=1:opt.nfold
    for roi=1 : length(ROI_info)
        train1 = find( type1_CV{cv,1} );
        train2 = find( type2_CV{cv,1} );
        [h1{roi,1}, p_value{roi,1}] = ttest2( classData{1}{roi,1}(:, train1)', classData{2}{roi,1}(:, train2)', 'alpha', opt.threshold );
        
        if any(isnan(h1{roi,1}))
            h1{roi,1}(isnan(h1{roi,1})) = 0;
        end
        
        rejected1 = find( h1{roi,1}==0 );
        p_value{roi,1}(rejected1) = 0;
        
        Thresh_idx{cv}{roi,1} = Template_ROI_idx{roi,1}( (p_value{roi,1}~=0) );
        Thresh_idx{cv}{roi,2} = p_value{roi,1}(p_value{roi,1}~=0);
    end
    %     scaledPValue1 = convert2LogScale( p1{roi,1} );
    %     saveToImage( ['cv', num2str(cv), '_Statistic_Map'], scaledPValue1, Template_idx );
    disp('CV done!!')
end
% p_value = p_value;
save(sprintf('./Save_result/%s/TreshIdx%.2f.mat',opt.ex,opt.threshold),'Thresh_idx','p_value');

end
