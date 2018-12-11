function [catData] = concat_Data(data)%, label) , catLabel
dataSize = size(data);
catData = [];
% catLabel = [];
    for x = 1: dataSize(1)
        dataTemp = squeeze(data(x,:,:));
        % labelTemp = squeeze(label(x,:,:));
        catData = cat(1, catData, dataTemp);
        % catLabel = cat(1, catLabel, labelTemp);
         disp(x)
    end
end