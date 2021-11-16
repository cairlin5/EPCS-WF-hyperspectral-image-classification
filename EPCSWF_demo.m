% This code is developed by Runlin Cai. So that this code is distributed bounded by the terms and policies by Runlin Cai.
% If you have any questions, please feel free to contact Runlin Cai (cairlin5@mail2.sysu.edu.cn).
% The set of files contains the MATLAB code for the experiments in the following paper:
% R. Cai, C. Liu and J. Li, 'Efficient Phase-induced Gabor Cube Selection and Weighted Fusion for Hyperspectral Image Classification'.
% Science China Technological Sciences, Under review.
% 
% If you are using this code, please cite the following related references:
% [1] R. Cai, C. Liu and J. Li, 'Efficient Phase-induced Gabor Cube Selection and Weighted Fusion for Hyperspectral Image Classification'.
% Science China Technological Sciences.
% The traditional Gabor feature extraction is given by:
% [2] L. He, J. Li, A. Plaza, and Y. Li, 'Discriminative low-rank Gabor filtering for spectral¨Cspatial hyperspectral image classification',
% IEEE Transactions on Geoscience and Remote Sensing, vol. 55, no. 3, pp. 1381¨C1395, Mar. 2017.
% The basic feature selection procedure is given by:
% [3] S. Jia, G. Tang, J. Zhu and Q. Li, 'A Novel Ranking-Based Clustering Approach for Hyperspectral Band Selection',
% IEEE Transactions on Geoscience and Remote Sensing, vol. 54, no. 1, pp. 88-102, Jan. 2016.
% The Multinomial logistic regression (MLR) implimentation is by:
% [4] J. Li, J. Bioucas-Dias and A. Plaza. Hyperspectral Image Segmentation Using a New Bayesian Approach with Active Learning, 
% IEEE Transactions on Geoscience and Remote Sensing, vol. 49, no. 10, pp. 3947-3960, October 2011.
% ¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª
%% Initialization
clear all; clc
rng('shuffle', 'twister');  % for reproducibility
addpath('.\Dataset'); 
addpath(genpath('.\matlab function'));

%% INPUT: datasets and classification settings 
data = single(get_data('Indian_pines')); % the original HSI with the size of 145X145X200
gtmap = get_data('Indian_Pines_gt'); % the labeled map with the size of 145X145
phase_list = [0, pi/6, pi/3, pi/2]; % the list of preset Ps.
parameter_beta = 2.5; % thecoefficient that controls the influence of weights (please refer to our manuscript)
sample_each_class = 15; % the samples of each class randomly selected for classification

%% Some variable definitions
size_x = size(data, 1);
size_y = size(data, 2);
size_z = size(data, 3);
Q = length(phase_list);

%% Gabor cube generation
FreqMagnitude = [1/2, 1/4, 1/8, 1/16]'  ; %  the list of frequencies. 
TempAngle = [0, pi/4, 2*pi/4, 3*pi/4]'; % the list orientations
R = 52;
[Re, Im] = GetFeats(single(data), FreqMagnitude, TempAngle);
Re = reshape(Re, size_x, size_y, []);
Im = reshape(Im, size_x, size_y, []);
ReCubes = get_cubes(Re, R, size_x, size_y) ;  
ImCubes = get_cubes(Im, R, size_x, size_y) ;  
                
%% Gabor energy feature calcualation
counts = 0;
for q = 1 : Q
    phase = phase_list(q);
    for r = 1 : R
        counts = counts + 1;
        Recube = ReCubes{r};
        Imcube = ImCubes{r};                        
        Pcube = Recube .* cos(phase) - Imcube .* sin(phase);
        phase_cube_energy{counts} = sum(Pcube, 3);          
    end
end
               
for r = 1 : R  
    magnitude_cube_energy{r} = sum( sqrt( ReCubes{r}.^2 + ImCubes{r}.^2  ), 3); 
end

%% feature cube selection for various types of Gabor features
magnitude_scores = Energy_based_cube_selection(magnitude_cube_energy);  
[~, MaCS_selected] = sort(magnitude_scores,  'descend');

phases_scores = Energy_based_cube_selection(phase_cube_energy);  
[~, EPCS_selected] = sort(phases_scores,  'descend');

feature_set = [];
for q = 1 : Q
    group_index = [1, R] + R * (q - 1);
    for group_idx = group_index
       feature_set(:, q) = EPCS_selected(EPCS_selected >= group_index(1) & EPCS_selected <= group_index(2)  ) ;               
    end
end

EPCS_selected = feature_set(1, :)';
ReCS_selected = feature_set(1: Q, 1);
MaCS_selected =  MaCS_selected(1: Q);

%% Calculating the weights for EPCS_WF method
for q = 1: Q
    E{q} = phase_cube_energy{  EPCS_selected(q)   };
end
alpha = compute_alpha(E, parameter_beta);
                       
%% feature cube generation for various Gabor features
% 1) Real part of Gabor features
for q = 1 : Q
    Cube_idx =  ReCS_selected(q);
    real_part_cube{Cube_idx} =ReCubes{Cube_idx};
end
% 2) Magnitude of Gabor features
for q = 1 : Q
    Cube_idx =  MaCS_selected(q);
    tempRe = ReCubes{Cube_idx};
    tempIm = ImCubes{Cube_idx};
    magnitude_cube{Cube_idx} = sqrt(tempRe.^2 + tempIm.^2 );
end
% 3) phase-induced Gabor feautres
for q = 1: Q
    Cube_idx =  EPCS_selected(q) - R * (q-1);
    tempRe = ReCubes{Cube_idx};
    tempIm = ImCubes{Cube_idx};
    phase_cube{ EPCS_selected(q) } = tempRe .* cos(phase_list(q)) - tempIm .* sin(phase_list(q));
end


%% training set generation
trainall = get_train_test(gtmap);
number_of_class = length(unique(trainall(:,2)));
train_idx = train_test_random_equal_number( trainall(:,2),  sample_each_class,  sample_each_class *  number_of_class);
train_label = trainall(train_idx, :); 
test_set = trainall;
test_set(train_idx, :) = [];

%% classification for various Gabor-based methods
[ReGF, ReGF_label, ReGF_cost] = MLRclassifier(Re, train_label, test_set);            
[MaGF, MaGF_label, MaGF_cost ] = MLRclassifier(sqrt(Re.^2 + Im.^2), train_label, test_set);    
[ReCS, ReCS_label, ReCS_cost] =  MLR_DF( real_part_cube, ReCS_selected,  [1,1,1,1], 'LOP' , train_label,  test_set);  
[MaCS, MaCS_label, MaCS_cost] =  MLR_DF( magnitude_cube,  MaCS_selected,  [1,1,1,1], 'LOP', train_label,  test_set);  
[EPCS, EPCS_label, EPCS_cost] =  MLR_DF( phase_cube,  EPCS_selected,  [1,1,1,1], 'LOP', train_label,  test_set);  
[EPCS_WF, EPCS_WF_label, EPCS_WF_cost] =  MLR_DF( phase_cube,  EPCS_selected,  alpha, 'LOGP', train_label,  test_set);  
        
%% OUTPUT: The list '[A,B,C]' above. A includes CA, AA, OA and Kappa. B is the labeled vector. C denotes the running time for classification.
fprintf( ['OA of ReGF: ', num2str(ReCS(end-2) ), ' in ', num2str(ReGF_cost), 's \n'] )  
fprintf( ['OA of MaGF: ', num2str(MaGF(end-2) ), ' in ', num2str(MaGF_cost), 's \n'] )  
fprintf( ['OA of ReCS: ', num2str(ReCS(end-2) ), ' in ', num2str(ReCS_cost), 's \n'] )  
fprintf( ['OA of MaCS: ', num2str(MaCS(end-2) ),  ' in ', num2str(MaCS_cost), 's \n'] )  
fprintf( ['OA of EPCS: ', num2str(EPCS(end-2) ), ' in ', num2str(EPCS_cost), 's \n'] )  
fprintf( ['OA of EPCS-WF: ', num2str(EPCS_WF(end-2) ),  ' in ', num2str(EPCS_WF_cost), 's \n'] )  

% % Warning: PGF may cause a huge memory burden, please pay attention!
% for q = 1: length(phase_list)
%      phase = phase_list(q);
%      PGF_cube{q} = cos(phase) .* Re - sin(phase) .* Im;
% end
% [PGF, ~, PGF_cost ] =  MLR_DF( PGF_cube,  [1,2,3,4],  [1,1,1,1], 'LOP', train_label,  test_set);
% fprintf( ['OA for PGF: ', num2str(PGF(end-2) ), ' in ', num2str(PGF_cost), 's \n'] )  

