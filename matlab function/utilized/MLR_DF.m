function  [ results, labels, time_cost ] = MLR_DF(Feature_set,  vote_list, alpha, decision_fusion_type, trnSet, test_set)
%% Decision fusion based on multinomial logistic regression (MLR_DF)
% INPUTS:
% 1) Feature_set: A cell vector including the Gabor cubes to be processed.
% 2) vote_list: The indexes of Gabor cubes used for decision fusion (voting).
% 3) alpha: A numeric vector - the weights of corresponding Gabor cubes for decision fusion. if the weights are equal, please set them to 1.
% 4) decision_fusion_type: i.e., 'LOGP' and 'LOP', logarithmic  & linear opinion pools. For detail information, please refer to other articles.
% 5) trnSet: A two-column-matrix indicating the sample index and its label, which is used for training the classifiers. 
% 6) test_set: A two-column-matrix indicating the sample index and its label, which is used for testing the performance.

% OUTPUTS:
% 1) results: A numeric vector containing CA, OA, AA, and Kappa results.
% 2) labels: A labeled vector. 
% 3) time_cost: The time cost for classification procedure.
% ！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！ 

   batch_p = [];
   t1 = clock;
   number_of_class = max(unique(test_set(:, 2)));
   if size(vote_list, 1) > 1
    vote_list = vote_list'; 
   end
    for i =  vote_list
        features = Feature_set{i};         
        [w, L, scale, sigma] = MLRtrain(features, trnSet);            
        [p, ~, ~, ~, ~, ~]  = MLRpredict(features, w, trnSet, test_set, number_of_class, scale, sigma, 'show_map')   ;
        batch_p = cat(3, batch_p, p) ;
    end
      
   if  strcmp(decision_fusion_type, 'LOP')  % function with LOP
        soft_p = sum(batch_p .* reshape(alpha, 1,1, length(vote_list)),   3)  ; 
   elseif  strcmp(decision_fusion_type, 'LOGP')% function with LOGP
       soft_p = prod(batch_p  .^ reshape(alpha, 1,1, length(vote_list)) , 3) ;
   else
       error('Error decison fusion type! LOP or LOGP is required. ' )
   end
    
    [~, labels] = max( soft_p  , [], 1);
    [OA, kappa, AA, CA, ~] = calcError( test_set(:,2) - 1, labels(test_set(:,1))' - 1,  [1: number_of_class]) ;
    results = [CA; OA; AA; kappa];
    t2 = clock;
    time_cost = etime(t2, t1);
  end