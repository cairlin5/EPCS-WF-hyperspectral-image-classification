function data = norm_data(data)
    maxdata = max(data(:)); 
    mindata = min(data(:));
    data = (data - mindata)/(maxdata - mindata);
end