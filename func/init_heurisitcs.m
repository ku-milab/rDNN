% heurisitcs initial scale
function nn_W = init_heurisitcs(m,n)

        
% nn.W{i - 1} = (rand(nn.size(i), nn.size(i - 1)+1) - ) * 2 * 6 / sqrt(nn.size(i) + nn.size(i - 1));

nn_W = (rand(m, n + 1) - 0.5) * 2 * 6 / sqrt(m + n);

end