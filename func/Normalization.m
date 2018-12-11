function [normedData, Mu1, Std1] = Normalization(Data, Mu, Std)

if(nargin == 1)    
    tmpData = reshape(Data, (size(Data,1)*size(Data,2)), []);

    Mu1 = mean(tmpData,2);
    Std1 = std(tmpData,0,2);
   
    tmp = tmpData - repmat(Mu1, [1, size(tmpData,2), 1]);
    tmp1 = tmp ./ repmat(Std1, [1 size(tmpData,2)]);

    assert(any(isnan(Mu1)) == 0, 'exist NaN value');
        

    normedData = reshape(tmp1,size(Data,1),size(Data,2),[]);
    clear tmp tmp1;

end

if(nargin == 3)
    tmpData = reshape(Data, (size(Data,1)*size(Data,2)), []);
    
    tmp = tmpData - repmat(Mu, [1, size(tmpData,2), 1]);
    tmp1 = tmp ./ repmat(Std, [1 size(tmpData,2)]);
        assert(any(isnan(Mu)) == 0, 'exist NaN value');
    normedData = reshape(tmp1,size(Data,1),size(Data,2),[]);
    
    clear tmp tmp1;

end