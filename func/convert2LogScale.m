function scaled = convert2LogScale( data )

nonzero = find( data ~= 0 );
scaled = zeros( size(data) );
scaled(nonzero) = -log(data(nonzero));