function meanPVals = computeMeanPValue( voxels, pvals, wsize, imgSize )

disp( 'Compute the mean p-value for each selected voxels...' );

pvals(isnan(pvals)) = 1;
pval3D = reshape( pvals, imgSize );
meanPVals = zeros( 1, numel(voxels) );

halfWSize = (wsize-1)/2;
for v=1:numel(voxels)
    [i, j, k] = ind2sub( imgSize, voxels(v) );
    mini = i-halfWSize;
    maxi = i+halfWSize;
    
    minj = j-halfWSize;
    maxj = j+halfWSize;
    
    mink = k-halfWSize;
    maxk = k+halfWSize;
    
    if mini<=0, mini=1;    end
    if maxi>imgSize(1), maxi=imgSize(1);    end
    if minj<=0, minj=1;    end
    if maxj>imgSize(2), maxj=imgSize(2);    end
    if mink<=0, mink=1;    end
    if maxk>imgSize(3), maxk=imgSize(3);    end
    
    patch = pval3D(mini:maxi, minj:maxj, mink:maxk);
    meanPVals(v) = mean(patch(:));
end
