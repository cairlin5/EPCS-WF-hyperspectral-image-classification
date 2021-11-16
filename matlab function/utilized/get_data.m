function outputname = get_data(ori_load_name, varargin)
    if length(varargin) > 0
        tar_num = varargin{1};
    else
        tar_num = 1;
    end
    target = load([ori_load_name]);
    target = struct2cell(target);
    outputname = target{tar_num};
end