%% main_alpha 
close all
clear 
clc
%--------------------------------------------------------------------------
%% Configurações gerais e pertinentes para cada uma das câmeras C_i:
% Pacote de visão computacional do Matlab:

% câmeras da rede:
% cada uma das câmeras é considerado um nó da rede.
i = [ 1 2 3 4 5 6 7 8 ];

% Número i de câmeras:
% quantidade total de câmeras na rede. 
N = length(i);

% Alocação de memória para cada uma das câmeras:
cam = cell(1,N);

% Número total de Iterações: 
% total de quadros analisados em cada uma das câmeras. TF total  = 794
TF = 794;

% buffer para armazenamento de linhas de visadas
bufferLoS = zeros(N-1,10,N,TF);
sendCamera{TF} = [];

run loadParameters

for n=1:N % para cada i-ésima câmera

    % atribuição de identificação numérica para cada uma das câmera
    cam{n}.nodeId = i(n);
    
    % inicialização de Ids dos alvos
    cam{n}.nextId = 1;
    
    % lê os parâmetros extrínsecos de cada uma câmeras
    cam{n}.extrinsec = camExtrinsecParam(cam{n}.nodeId);
    
    % lê os parâmetros intrínsecos de cada uma das câmeras
    cam{n}.intrinsec = camIntrinsecParam(cam{n}.nodeId);
    
    % lê os vídeos das câmeras escolhidas e gera um objeto com as 
    % propriedades para análise dos quadros
    cam{n}.obj = setupSystemObjects(cam{n}.nodeId);
    
    % inicializa a estrutura de rastreio de alvos
    cam{n}.tracks = initializeTracks();
    
end

% configura se o experimento terá assincronismo e atraso no tempo de 
% processamento de cada um dos quadros 
async = true; %false
delay = true; %false

for cIdx= 1:numel(consensus)
   
    %----------------------------------------------------------------------
    % passos de consenso
    p_consensus = consensus(cIdx);
    
    %----------------------------------------------------------------------
    % Experimento com variação do assincronismo
    % atraso máximo de processamento 
    if delay
        mtau = 3;
    else
        mtau = 0;
    end
    % tempo de processamento aleatório das câmeras
    taus = randi([0 mtau],1,N);
    
    % variação do assincronismo
    alphas = [0 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40];
    % alocação de memória para mostrar o resultado de cada filtro
    armse_async = zeros(5,numel(alphas));
    
    for aIdx = 1:numel(alphas)
        alpha = alphas(aIdx);
        disp(['asynchronism:' num2str(alpha)])
    
        run estimate
        
        armse_async(:,aIdx) = RMSE;%erro médio quadrático sobre cada rodada
        
    end
    %----------------------------------------------------------------------
    % experimento com variação de atraso
    % assincronia máxima
    if async
        alpha = 6;
    else
        alpha = 0;
    end
    
    % variação dos atrasos de processamento
    mtaus = [0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40];
    % alocação de memória para mostrar o resultado de cada filtro
    armse_delays = zeros(5,numel(mtaus));
    
    for aIdx = 1:numel(mtaus)
        alpha = mtaus(aIdx);
        taus = randi([0 mtau], 1, N);
        disp(['processing delay:' num2str(alpha)])
    
        run estimate
        
        armse_delays(:,aIdx) = RMSE;%erro médio quadrático sobre cada rodada
        
    end
    %----------------------------------------------------------------------
    % Saída
    run plotOutput
end
disp('end')