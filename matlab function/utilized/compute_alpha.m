function alpha = compute_alpha(selected_cube, parameter_beta)
    for q = 1 :  length(selected_cube)
        for z =  1 :  length(selected_cube)
            cube_q = selected_cube{q};
            cube_z = selected_cube{z};
            if q ~= z
                MI_matrix(q,z) = MI2(cube_q, cube_z);
            else
                MI_matrix(q, z) = 0;
            end
        end
    end
    MI_Eq_Ez = MI_matrix;
    MI_Eq_Ez(MI_matrix == 0) = [];
    MI_Eq_Ez = reshape(MI_Eq_Ez, size(MI_matrix, 2) -1, size(MI_matrix, 1) )' ;
    I = exp( - sum( MI_Eq_Ez , 2) /  parameter_beta);
    alpha = I  / sum(I)   ;
end
function mi = MI2(a,b)
    [Ma , Na] = size(a);
    [Mb , Nb] = size(b);
    M = min(Ma , Mb);
    N = min(Na , Nb);
    hab = zeros(256,256);
    ha = zeros(1,256);
    hb = zeros(1,256);
    imax = max(max(max(a)));
    imin = min(min(min(a)));
    if imax ~= imin
        a = double((a-imin))/double((imax-imin));
    else
        a = zeros(M,N);
    end
    imax = max(max(max(b)));
    imin = min(min(min(b)));
    if imax ~= imin
        b = double(b-imin)/double((imax-imin));
    else
        b = zeros(M,N);
    end
    a = int16(a*255)+1;
    b = int16(b*255)+1;
    for i=1:M
        for j=1:N
            indexx = a(i,j);
            indexy = b(i,j) ;
            hab(indexx,indexy) = hab(indexx,indexy)+1; 
            ha(indexx) = ha(indexx)+1; 
            hb(indexy) = hb(indexy)+1;
        end
    end
    hsum = sum(sum(hab));
    index = find(hab~=0);
    p = hab/hsum;
    Hab = sum(-p(index).*log(p(index)));
    hsum = sum(sum(ha));
    index = find(ha~=0);
    p = ha/hsum;
    Ha = sum(-p(index).*log(p(index)));
    hsum = sum(sum(hb));
    index = find(hb~=0);
    p = hb/hsum;
    Hb = sum(-p(index).*log(p(index)));
    mi = Ha+Hb-Hab;
end