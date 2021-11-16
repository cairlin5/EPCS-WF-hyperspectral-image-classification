function [w, L, scale, sigma] = ALtrain(view_data, trnSet)
    sz = size(view_data); 
    height = sz(1);width = sz(2);
    if(size(sz,2)==3)
        bands = sz(3);
    else 
        bands = 1;
    end
    view_data = double(reshape(view_data, height*width, bands));
    ens_X_train = view_data(trnSet(:,1),:);
    ens_X_train = ens_X_train';
    ens_Y_train = trnSet(:,2);
    [d, n] = size(ens_X_train);
    nx = sum(ens_X_train.^2);
    [X, Y] = meshgrid(nx);
    dist = X+Y-2*ens_X_train'*ens_X_train;
    scale = mean(dist(:));
    sigma = 0.6;
    K = exp(-dist/2/scale/sigma^2);
    K = [ones(1,n); K];
    lambda = 0.00015; 
    [w, L] = LORSAL(K,ens_Y_train,lambda,lambda,200);

end