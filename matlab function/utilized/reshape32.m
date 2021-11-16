function data = reshape32(data)
    [x,y,z] = size(data);
    data = reshape(data, x*y, z);
end