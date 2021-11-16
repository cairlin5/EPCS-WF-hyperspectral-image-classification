function [trainall, unlabel_index] = get_train_test(gt_data)
    if size(gt_data,1) > 2 & size(gt_data,2) > 2 
        gtdata(1,:) = reshape(gt_data, size(gt_data,1)* size(gt_data,2), 1);
        gtdata(2,:) = [1:length(gtdata)];
        idx = find(gtdata(1,:)==0);
        gtdata(:, idx) = [];
    else
        error('There must be some mistake, please check it! ')
    end
    trainall = gtdata' ;
    trainall = fliplr(trainall); 
    gtmap = zeros(size(gt_data));
    gtmap(trainall(:, 1)) = trainall(:,2);
    unlabel_index= find(gtmap == 0);
end 