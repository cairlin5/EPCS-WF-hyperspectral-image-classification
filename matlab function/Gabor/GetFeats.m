function [ReCube, ImCube] = GetFeats(data, FreqMagnitude, TempAngle)
    a = size(data, 1);
    b = size(data, 2);
    c = size(data, 3);
    ScaleXY = [3.8*ones(1,2)] * 1;
    ScaleB = [0.8]';
    IdxCom = 9;
    ReCube = fGet_3DGaborFeat_ReCube(data, ScaleXY, ScaleB, FreqMagnitude, TempAngle, IdxCom, '3D');
    ImCube = fGet_3DGaborFeat_ImCube(data, ScaleXY, ScaleB, FreqMagnitude, TempAngle, IdxCom, '3D');
end