function [Rolling_Data] = Rolling_window_3D(Data, win_size)
kernel = ones(win_size);

conv_Data = convn(Data,kernel,'same');
Rolling_Data = conv_Data ./ (win_size(1)*win_size(2)*win_size(3));

end

%        poolobj = parpool('local', 4);
%        
%        Cov = cell(1, numSubject);
%        CovfeatureVector = zeros(numSubject, numROI);
%        CovfeatureVector_zMap = zeros(numSubject, numROI);
%        temp = cell(1, numSubject);        
%        if diseaseType == 7
%            temp = DataSubject;
%        else
%            for i=1:numSubject
%                temp{i} = squeeze( normedData(s, :, :slightly_smiling_face:' );
%            end
%        end
%        
%        
%        parfor s=1:numSubject
%            Cov_pool = zeros( numROI, numROI );
%            zMap = zeros( numROI, numROI );
%            CovfeatureVector_pool = zeros( 1, numROI );
%            CovfeatureVector_zMap_pool = zeros( 1, numROI);
%            
%            fprintf('%dth subject is start!\t', s);
%        
%            [ Cov_pool, ~ ] = graphicalLasso( cov(temp{s}), lambda );
%            
%            CovfeatureVector_pool = clustering_coef_wu( abs(Cov_pool) );
%            
%            zMap = 0.5 * log( (1+Cov_pool)./(1-Cov_pool) );
%            zMap(1:numROI+1:end) = 0;
%            CovfeatureVector_zMap_pool = clustering_coef_wu( abs( zMap ) );
%            
%            fprintf('%dth subject is complete!\n', s);
%            
%            Cov{s} = Cov_pool;
%            CovfeatureVector(s, :slightly_smiling_face: = CovfeatureVector_pool;
%            CovfeatureVector_zMap(s, :) = CovfeatureVector_zMap_pool;
%        end
%        
%        delete(poolobj);