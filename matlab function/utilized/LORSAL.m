function [v,L] = LORSAL(x,y, lambda, beta, MMiter,w0)
%       
%
%  Sparse Multinomial Logistic Regression 
%  
%  Implements a block Gauss Seidel  algorithm for fast solution of 
%  the SMLR introduced in Krishnapuram et. al, IEEE TPMI, 2005 (eq. 12)
%
% -- Input Parameters ----------------
%
% x ->      training set (each column represent a sample).
%           x can be samples or functions of samples, i.e., 
%           kernels, basis, etc.
% y ->      class (1,2,...,m)
% lambda -> sparsness parameter
% 
% MMiter -> Number of iterations (default 100)
%
% Author: Jose M. Bioucas-Dias, Fev. 2006

% Bregman weight

%  beta = 0.1*beta;
% beta = 0.5*lambda;
% Bregman iterations
BR_iter = 1;
% Block iterations
Bloc_iters = 1;

if nargin < 5
    MMiter = 200;
end
%[d - space dimension, n-number of samples]
[d,n] = size(x);
% if (size(y,1) ~= 1) | (size(y,2) ~= n)
%     error('Input vector y is not of size [1,%d]',n)
% end
% number of classes 
m = max(y);
% auxiliar matrix to compute a bound for the logistic hessian
U = -1/2*(eye(m-1)-ones(m-1)/m); 
% convert y into binary information
Y = zeros(m,n);
for i=1:n
    Y(y(i),i) = 1;
end
% remove last line
Y=Y(1:m-1,:);
% Y = Yf;
% build Rx
Rx = x*x';
% initialize w with ridge regression fitted to w'*x = 10 in the class
% and w'*x = -10 outside the class
if (nargin < 6)
    alpha = 1e-5;
    w=(Rx+alpha*eye(d))\(x*(10*Y'-5*ones(size(Y'))));
%     b = x*(10*Y'-5*ones(size(Y')));
%     for i = 1:d
%         Rx(i,i) = Rx(i,i)+alpha;
%     end
%     w = Rx\b;
% else
%     w=w0;
end

% do eigen-decomposition
[Uu,Du] = eig(U);
[Ur,Dr] = eig(Rx);

S = 1./(repmat(diag(Dr),1,m-1)*Du -beta*ones(d,m-1));



% Bregman iterative scheme to compute w
%
% initialize v (to impose the constraint w=v)
v = w;
% initialize the Bregman vector b
b = 0*v;
% MM iterations
for i=1:MMiter
%     fprintf('\n i = %d',i);
    % compute the  multinomial distributions (one per sample)
    aux1 = exp(w'*x);
    aux2 = 1+sum(aux1,1);
    p =  aux1./repmat(aux2,m-1,1);
    % compute log-likelihood
    L(i) = sum(  sum(Y.*(w'*x),1) -log(aux2)) -lambda*sum(abs(w(:)))+ ...
        lambda*sum(abs(w(1,:)))  ;
%     db(i) = norm(w);
%     bd(i) = norm(w-v);
    % compute derivative of the multinomial logistic regression at w2
    % g = x*(Y-p)';
    % compute derivative
    dg = Rx*w*U'-x*(Y-p)';
    
    
    % Bregman iterations
    for k = 1:BR_iter
       for j=1:Bloc_iters
           % update w
           z = dg-beta*(v+b);
           w = S.*(Ur'*z*Uu);
           w = Ur*w*Uu';
           % update v
           v=wthresh(w-b,'s',lambda/beta);
       end
       % Bregman factor
       b = b-(w-v);
%        norm(b)
    end

    beta = beta*1.05;
    S = 1./(repmat(diag(Dr),1,m-1)*Du -beta*ones(d,m-1));
end
% p(m,:) = 1-sum(p,1);










