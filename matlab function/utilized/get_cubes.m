function cube = get_cubes(phase_img, CubeNum, size_x, size_y)
    if size(phase_img, 3) > 1
        phase_img = reshape32(phase_img);
    end
    for z = 1: CubeNum
        ll = clist(1,  size(phase_img, 2), CubeNum);
        temp_img = phase_img(:, [ll(z,1): ll(z,2)] );   
        temp_img = reshape(temp_img, size_x, size_y, []);
        cube{z} = temp_img;
    end
end
function newtm = clist(start_num, end_num, points)
    start_num = start_num - 1;
    points = points + 1;
    target = linspace(start_num, end_num, points);
    target1 = target + 1;
    for i = 1:points-1
        newtm(i, :) = [target1(i), target(i+1)];
    end 
end