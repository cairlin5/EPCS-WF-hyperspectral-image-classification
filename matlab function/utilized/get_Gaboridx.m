function list = get_Gaboridx(FreqMagnitude, TempAngle)
list = [];
for i = 1: length(FreqMagnitude)
    for j = 1: length(TempAngle)
        if TempAngle(j) == 0
            vv = 1;
        else
            vv = length(TempAngle);
        end
        for z = 1: vv
            list = [list; FreqMagnitude(i), TempAngle(j), TempAngle(z)];
        end
    end
end
end