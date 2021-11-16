function [ results, classps, cost_time] = MLRclassifier(features, trnSet, test_set)
    t1 = clock;
    number_of_class = max(unique(test_set(:,2)));
    [w, L, scale, sigma] = MLRtrain(features, trnSet);            
    [p, classps, OA, kappa, AA, CA]  = MLRpredict(features, w, trnSet, test_set, number_of_class, scale, sigma, 'show_map');
    t2 = clock;
    results = [CA; OA; AA; kappa];
    cost_time =  etime(t2, t1);
end