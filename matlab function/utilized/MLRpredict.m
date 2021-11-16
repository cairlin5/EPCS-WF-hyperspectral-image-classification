function [p, classp, OA, kappa, AA, CA] = ALpredict(view_data, w, trnSet, testSet, num_of_classes, scale, sigma, show_type)
    global save_map cellidx 

    sz = size(view_data); 
    height = sz(1);
    width = sz(2);
    if(size(sz,2)==3)
        bands = sz(3);
    else 
        bands = 1;
    end

    view_data = double(reshape(view_data, height*width, bands));

    ens_X_train = view_data(trnSet(:,1),:);
    ens_X_train = ens_X_train';
    ens_Y_train = trnSet(:,2);

    ens_X_test = view_data(testSet(:,1),:);
    ens_X_test = ens_X_test';

    if ~exist('show_type', 'var')
        show_type = '';
    end

    p = splitimage2(ens_X_test, ens_X_train, w, scale,sigma);
    [maxp, classp] = max(p);
    ens_Y_test = testSet(:,2);
    ens_Y_test = ens_Y_test';
    [OA, kappa, AA, CA] = calcError( ens_Y_test-1, classp-1, [1:num_of_classes] );

    if strcmp(show_type, 'show_map')
        p = splitimage2(view_data', ens_X_train, w, scale,sigma);
        [maxp, classp] = max(p);
    end
end
