disp('Loading filter parameters...');

% Quantidade de rodadas de Monte-Carlo - verificar a quantidade de rodadas
% - qual critério é adotado - convergência numérica?
M = 12; % number of Monte-Carlo runs

dT = 1; % size of time step
%% state dynamics model parameters
nx = 3; % state vector length

%% state dynamics model parameters

F = @(t2,t1)[ eye(3)    (t2-t1)*eye(3);
              zeros(3)   eye(3) ];
         
dt = @(t2,t1,j)(abs(t2-t1)^j)/j;

q = 10;

%% Covariance matrix of process noise Gaussian distribution
                     
Q = @(t2,t1)(q^2)*[  dt(t2,t1,3)         0            0       dt(t2,t1,2)       0           0;
                         0          dt(t2,t1,3)       0           0        dt(t2,t1,2)      0;
                         0               0       dt(t2,t1,3)      0             0       dt(t2,t1,2);
                     dt(t2,t1,2)         0            0       dt(t2,t1,1)       0           0;
                         0          dt(t2,t1,2)       0           0        dt(t2,t1,1)      0;
                         0               0       dt(t2,t1,2)      0             0       dt(t2,t1,1) ];%covariance matrix of the process noise Gaussian distribution
                     
%% observation model parameters
R  = 60*[ 1   0   0;
          0   1   0;
          0   0   1 ];  %covariance matrix of the measurement noise Gaussian distribution

Rinv  = pinv(R);

%% Homography matrices of cameras
H=zeros(3,6,8);

for c = 1:8
    % Compute state to measurement transition matrix
    H(:,:,c)  = [ 1 0 0 0 0 0;
                  0 1 0 0 0 0;
                  0 0 1 0 0 0 ];
    
end

%% Initial Prior Covariance matrix of each camera for each target
PC = diag([1 1 1 0.1 0.1 0.1]);
Pinv = pinv(PC);

%% Passos de consenso
consensus = [1 2 4 6 10];
