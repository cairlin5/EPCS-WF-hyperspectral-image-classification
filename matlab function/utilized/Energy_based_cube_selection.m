function lambda = Energy_based_cube_selection(energy_cube)

    S_uv = zeros( length(energy_cube),  length(energy_cube) );
    N = length(energy_cube);
    for v   =  1  :  length(energy_cube)  -  1
        energy_v = energy_cube{v};
        energy_v = energy_v(:) ;
        for u =  v + 1 : length(energy_cube)
            energy_u = energy_cube{u};
            energy_u  = energy_u (:) ;
            S_uv(v,u) = norm((energy_u - energy_v),   2);
            S_uv(u,v) = S_uv(v,   u);
        end
    end
    S_uv = S_uv / N ;

    rhos = [];
    percent_setting = [1, 1.25, 1.5, 1.75, 2];
    J = length(percent_setting);
    
    for j = 1: length(percent_setting)
        percent = percent_setting(j);
        position = round( N*(N-1) / 2 * percent / 100)  ;
        temp = S_uv( find(tril(S_uv)~=0) );
        sda = sort(temp);
        dini = sda(position);
        tau = dini;
        rho = zeros(N,1);
        for u = 1:N
            for v = 1:N
                if u ~= v
                    rho(u) = rho(u)+ exp(-(S_uv(u,v) / tau)^2);
                end
            end
        end
        rhos(:,:,j) = rho;
    end
    
    clear rho
    rho = mean(rhos, 3);
    [rho_sorted, ordrho] = sort(rho,  'descend');
    maxd = max(  max(  S_uv(  ordrho(1),:) ) );
    delta = zeros(N,1);
    delta(ordrho(1)) = -1;
    maxD = max(  max(  S_uv)  );
    for u = 2:  N
        delta(ordrho(u)) = maxD;
        for v = 1:  u-1
            if S_uv(ordrho(u),  ordrho(v))  <  delta(ordrho(u)  )
                delta(ordrho(u)) = S_uv  (ordrho(u),   ordrho(v)  );
            end
        end
    end
    delta(ordrho(1)) = max(delta);
    rho = (rho-min(rho(:)))/(max(rho(:))-min(rho(:)));
    delta = (delta-min(delta(:)))/(max(delta(:))-min(delta(:)));
    lambda =rho.*(delta.*delta);
end