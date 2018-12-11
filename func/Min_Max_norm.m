% where n * m
% based m

function normed_Data = Min_Max_norm( Data )
    
    d_min= min(Data);
    d_max = max(Data);
    devide_V = d_max - d_min;
    
    normed_Data = (Data - repmat(d_min,size(Data,1),1)) ./ repmat(devide_V,size(Data,1),1);
        
end