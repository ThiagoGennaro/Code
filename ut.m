%Unscented Transformation
%Input:
%        f: nonlinear map
%        X: sigma points
%       Wm: weights for mean
%       Wc: weights for covariance
%        n: numer of outputs of f
%        R: additive covariance
%Output:
%        y: transformed mean
%        Y: transformed sampling points
%        P: transformed covariance
%       Y1: transformed deviations

function [y,Y,P,Y1]=ut(X)


%% fatores de escala utilizados na UT
% fator de escala
ki = 0;
alpha = 1e-3;%default
% dimensão
L = 3; 
% fator de escala
lambda = (alpha^2)*(L + ki) - L;
c = L + lambda;
% tamanho do estado
n = 3; 
beta = 2;
% pesos para as medidas
Wm = [ lambda/c 0.5/c+zeros(1,2*L) ]; 
% pesos da covariância
Wc = Wm;
Wc(1) = Wc(1) + (1 - alpha^2 + beta);
% c coeficiente
c = sqrt(c); 

R = [1e-9 0 0; 0 1e-9 0; 0 0 1e-9];

%L=size(X,2);
y=zeros(n,1);
Y=zeros(n,L);
for k=1:L
    Y(:,k)=X(:,k);       
    y=y+Wm(k)*Y(:,k);       
end
Y1=Y-y(:,ones(1,L));
P=Y1*diag(Wc)*Y1' + R;          