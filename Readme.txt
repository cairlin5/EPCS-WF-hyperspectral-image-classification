This code is developed by Runlin Cai. So that this code is distributed bounded by the terms and policies by Runlin Cai.
If you have any questions, please feel free to contact Runlin Cai (cairlin5@mail2.sysu.edu.cn).
The set of files contains the Matlab code for the experiments in the following paper:
R. Cai, C. Liu and J. Li, 'Efficient Phase-induced Gabor Cube Selection and Weighted Fusion for Hyperspectral Image Classification'. Science China Technological Sciences, Under review.

If you are using this code, please cite the following related references:
(1) The code of EPCS-WF method is given by:
[1] R. Cai, C. Liu and J. Li, 'Efficient Phase-induced Gabor Cube Selection and Weighted Fusion for Hyperspectral Image Classification'.
Science China Technological Sciences.

(2) The traditional Gabor feature extraction is given by:
[2] L. He, J. Li, A. Plaza, and Y. Li, 'Discriminative low-rank Gabor filtering for spectral–spatial hyperspectral image classification',
IEEE Transactions on Geoscience and Remote Sensing, vol. 55, no. 3, pp. 1381–1395, Mar. 2017.

(3) The basic feature selection procedure is given by:
[3] S. Jia, G. Tang, J. Zhu and Q. Li, 'A Novel Ranking-Based Clustering Approach for Hyperspectral Band Selection',
IEEE Transactions on Geoscience and Remote Sensing, vol. 54, no. 1, pp. 88-102, Jan. 2016.

(4) The Multinomial logistic regression (MLR) implimentation is by:
[4] J. Li, J. Bioucas-Dias and A. Plaza. Hyperspectral Image Segmentation Using a New Bayesian Approach with Active Learning, 
IEEE Transactions on Geoscience and Remote Sensing, vol. 49, no. 10, pp. 3947-3960, October 2011.
-----------------------------------------------------------------------------------------------------------------------------
Please run 'EPCSWF_demo.m' for classification experiment. The Gabor-based classification methods including
ReGF, MaGF, PGF, ReCS, MaCS, EPCS, and EPCS-WF are provided in the demo.

Please pay attention to the folders including 'Dataset' and 'matlab functions'.
Dataset：Indian Pines along with its ground truth data. The size of Indian Pines: 145 × 145 × 200 (after removing the noise band).
matlab functions: contains the matlab code used in this program.
-----------------------------------------------------------------------------------------------------------------------------
Here are the detail variables of the EPCSWF method shown in this demo:
INPUT:
1) p_list: the settings of phase offsets, e.g., [0, π/6, π/3, π/2], where four phases offesets are set in our case.
2) hyperbeta: the cofficient used in weigthed decision fusion, 2.5 as default. For more details, please refer to the paper.
3) sample_each_class: the number of training samples of each class randomly selected for classification.

OUTPUT:
1）Classification result, a numeric vector, including CA, OA, AA, Kappa, and the running time.
2）Classification map, a numeric matrix with the predicted labels, with the same spatial size of the original dataset.
