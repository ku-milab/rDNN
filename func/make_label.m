function [train, val, test] = make_label( type, Train_data, Val_data, Test_data )

if strcmp(type, 'AD')
    label = [1, 0];
    trainSize = size(Train_data);
    testSize = size(Test_data);
    valSize = size(Val_data);
    
    train = repmat(reshape(label, 1,1,[]), [trainSize(1,1:2) 1]);
    test  = repmat(reshape(label, 1,1,[]), [testSize(1,1:2) 1]);
    val   = repmat(reshape(label, 1,1,[]), [valSize(1,1:2) 1]);
    
elseif strcmp(type, 'NC')
    label = [0, 1];
    
    trainSize = size(Train_data);
    testSize = size(Test_data);
    valSize = size(Val_data);
    
    train = repmat(reshape(label, 1,1,[]), [trainSize(1,1:2) 1]);
    test  = repmat(reshape(label, 1,1,[]), [testSize(1,1:2) 1]);
    val   = repmat(reshape(label, 1,1,[]), [valSize(1,1:2) 1]);
end

end