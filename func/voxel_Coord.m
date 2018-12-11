function idx3 = voxel_Coord(idx)

idx3 = zeros(size(idx,1),3); remainder = 0;
idx3(:,3) = ceil(idx(:) ./ (256 * 256));

if idx3(:,3)==0
    idx(:,3) = 256;
end

remainder = rem(idx, (256 * 256)) ;
idx3(:,2) = ceil(remainder ./ 256);
if idx3(:,2)==0
    idx3(:,2)=256;
end

remainder = rem(remainder, 256) ;
idx3(:,1) = remainder;

if idx3(:,1)==0
    idx3(:,1)=256;
end

end