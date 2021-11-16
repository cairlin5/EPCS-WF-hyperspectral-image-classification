%% Demo with LRGF and DLRGF with AVIRIS Indiana Pines dataset 
%% for the discriminative Gabor filtering method
%% intoduced in the following paper:
%
% [1] L. He, J. Li, A. Plaza, and Y. Li, ¡°Discriminative low-rank Gabor
%     filtering for spectral¨Cspatial hyperspectral image classification,¡± 
%     IEEE Trans. Geosci. Remote Sens., vol. 55, no. 3, pp. 1381¨C1395, Mar. 2017.
%
%%
% If you use this demo, please be aware of the parameters involved in the
% building of the Gabor filterings which might affect the final performance. 
%
%%
% For any question or suggestion, it is greatly appreciated to contact the
% author: Lin He (helin@scut.edu.cn)

function gabor_feat = fGet_3DGaborFeat(img, ScaleXY, ScaleB,...
    FreqMagnitude,TempAngle,IdxCom, cubetype)

HyperCube = img;
[Height,Width,Band] = size(HyperCube);
clear img

Scale = [repmat(ScaleXY, length(ScaleB),1), ScaleB];  

%% Gabor feature extraction
IdxCounter = 1;
for IdxAngle1 = 1:length(TempAngle)
    for IdxAngle2 = 1:length(TempAngle)
        FreqDirection(IdxCounter,1) = TempAngle(IdxAngle1); 
        FreqDirection(IdxCounter,2) = TempAngle(IdxAngle2); 
        IdxCounter = IdxCounter +1;
    end
end
if length(TempAngle).*  length(TempAngle) ~= 1
    FreqDirection([5 9 13],:) = [];
end

ScaleLen = size(Scale,1);     
FreqMagLen = size(FreqMagnitude,1);  
if strcmp(cubetype, '2D')
    FreqDirection = TempAngle;
end
    FreqDirLen = size(FreqDirection,1);   

%% Gabor Feature Extraction
gabor_feat = [];
for IdxScale = 1:ScaleLen    
    Component = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 1 0 0 0 0;...
        0 0 0 0 1 0 0 0; 0 0 0 0 0 1 0 0; 0 0 0 0 0 0 1 0; 0 0 0 0 0 0 0 1; 1 1 1 1 1 1 1 1];

    ImCounter = 0;
    SamTotalTemp = [];

    for IdxFreqMag = 1:FreqMagLen  
        for IdxFreqDir = 1: FreqDirLen       
            if strcmp(cubetype, '2D')
            [GaborFeaRe, GaborFeaIm] = fImageFiltering3DGaborSepV2_2( HyperCube, Scale(IdxScale,:),...
                                                        FreqMagnitude(IdxFreqMag), FreqDirection(IdxFreqDir,:), 2, [0,0], [1,1]); 

            elseif strcmp(cubetype, 'make_cube')
            [GaborFeaRe, GaborFeaIm] = ...
                make_cube('2D', HyperCube, Scale(IdxScale,:),...
                FreqMagnitude(IdxFreqMag), FreqDirection(IdxFreqDir,:), 2, [0,0], [1,1]);

            elseif strcmp(cubetype, '3D')
            [GaborFeaRe, GaborFeaIm] = ...
                fImageFiltering3DGaborSepV2('3D', HyperCube, Scale(IdxScale,:),...
                FreqMagnitude(IdxFreqMag),FreqDirection(IdxFreqDir,:),2, [0,0,0,0], [1,1,1,1]);
            else
                error('Error cubetype')
            end
            GaborFeaRe = reshape(GaborFeaRe,Height*Width,Band);
            GaborFeaIm = reshape(GaborFeaIm,Height*Width,Band);
            SamMag = GaborFeaIm;
            clear GaborFeaRe GaborFeaIm
            SamTotalTemp = [SamTotalTemp, gather(SamMag)];
            clear SamMag
            ImCounter = ImCounter+1
        end
    end
    clear HyperCube
    NormSam = SamTotalTemp;
    clear SamTotalTemp
    gabor_feat = [gabor_feat, gather(NormSam)];
end

clc
