function pathstr = getPath(varargin) 
if nargin == 0 
    target_num = 1;
else
    target_num = varargin{1};
end
filep = mfilename('fullpath'); 

if target_num ~= 0
stridx = strfind(filep, '\');
len = length(stridx);
pathstr = filep(1  : stridx(len - target_num + 1));
else
    pathstr = filep;
end
end