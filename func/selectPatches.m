function [patch_idx, selected_point] = selectPatches(Center_point_axis, Hc_size)
patch_idx = [];
selected_point = [];

for axis=1 : size(Center_point_axis,1)
    bValid = 1;
%     if ~isempty(selected_point)
%         bValid = checkValidity(selected_point,Center_point_axis(axis,:), Hc_size);
%     end
    
    if bValid == 1
        
        C_x(:,1) = Center_point_axis(axis,1)-Hc_size;
        C_x(:,2) = Center_point_axis(axis,1)+Hc_size;
        
        C_y(:,1) = Center_point_axis(axis,2)-Hc_size;
        C_y(:,2) = Center_point_axis(axis,2)+Hc_size;
        
        C_z(:,1) = Center_point_axis(axis,3)-Hc_size;
        C_z(:,2) = Center_point_axis(axis,3)+Hc_size;
        
%         patch = cat(2,C_x,C_y,C_z);
        patch_idx = [patch_idx; C_x,C_y,C_z];
        selected_point = [selected_point; Center_point_axis(axis,:)];
        
    end
end

function bValid = checkValidity( selected_point, Center_point_axis, Hc_size )

bValid = 1;
% [i0 j0 k0] = Center_point_axis;
% [i, j, k] = selected_point;

selected = selected_point;
one = repmat( Center_point_axis , [size(selected,1), 1] );

distance = sqrt( sum((selected-one).^2, 2) );

if ~isempty( find( distance<=Hc_size*3/10 ) )
    bValid = 0;
end