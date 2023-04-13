%% squared error
S_Error = zeros(5,M); % resultado do cálculo para cada rodada Monte-Carlo

% mostra os gráficos
debug = 0;

for r=1:M % Monte-Carlo
    
    % mostra a m-ésima iteração Monte-Carlo
    disp(['Monte-Carlo runs: ' num2str(r)])

    %% geração do relógio para cada uma das câmeras - captura e transmissão
    run ClockCamerasGenerator
    
    % resultado do cálculo dentro da janela temporal
    Sk_Error = zeros(5,TF); 
    
    for k=1:TF % para cada k-ésimo instante
       
        % mostra a k-ésima iteração
        disp(['Iteration: ' num2str(k)]);

        for n=1:N % para cada i-ésima câmera
            
            %% Leitura e salvamento dos frames dentro de uma janela temporal:
            frame = readFrame( cam{n}.obj.reader );
            
            %% Obtêm-se os centroids dos alvos no FoV de cada uma das câmeras
            [ centroids, bboxes, mask, groundPoint ] = ...
            detectObjects( cam{n}.obj, frame );
            
            %% Realiza a predição da posição do centróide do alvo no k-ésimo instante
            cam{n}.tracks = predictNewLocationsOfTracks( cam{n}.tracks ); 
            
            %% associa um Id ao alvo: -
            % multiple object tracking using the James Munkres' variant
            % of the Hungarian assignment algorithm
            [ assignments, unassignedTracks, unassignedDetections ] = ...
                detectionToTrackAssignment( cam{n}.tracks, centroids );

            %% atualiza os alvos detectados com as informações no instante k
            cam{n}.tracks = updateAssignedTracks( cam{n}.tracks,...
                                                  assignments,...
                                                  centroids,...
                                                  bboxes,...
                                                  cam{n}.intrinsec,...
                                                  cam{n}.extrinsec,...
                                                  k );

            %% atualiza quantidade de alvos não detectados
            cam{n}.tracks = updateUnassignedTracks( cam{n}.tracks,...
                                                    unassignedTracks );

            %% deleta alvos não detectados
            cam{n}.tracks = deleteLostTracks( cam{n}.tracks );
            
            %% cria novos alvos detectados
            [ cam{n}.tracks,cam{n}.nextId ] = ...
            createNewTracks( cam{n}.tracks,...
                             unassignedDetections,...
                             centroids,...
                             bboxes,...
                             cam{n}.nextId,...
                             cam{n}.intrinsec,...
                             cam{n}.extrinsec,...
                             TF,...
                             k );
            
            %% mostra o resultado dos centroides detectados
            %displayTrackingResults( cam{n}.obj, frame, mask, cam{n}.tracks, n )
            
            %% transmissão assíncrona de informações: 
            % envio de LoS comsuas estampas temporais
            [ cam{n}.tracks, bufferLoS, sendCamera ] = sendLoS( cam{n}.tracks,... 
                                                                bufferLoS,...
                                                                sendCamera,...
                                                                Ticks_t,... 
                                                                n,... 
                                                                k ); 
            
            %% Obtenção dos pontos no espaço 3D: 
            % Dentro da janela temporal, a i-ésima câmera captura os quadros
            % a cada k-ésimo instante, recebe as linhas de visadas dos alvos 
            % enviados pelas j-ésimas câmeras vizinhas, e obtêm os "sigma points" 
            % das linhas de visada dos alvos dentro do seu próprio campo de visão e
            % dos alvos recebidos de suas j-ésimas vizinhas.
            % Quando comparadas as linhas de visadas, obtidas e recebidas, 
            % geradas "pelos sigma points", uma quantidade de pontos no
            % espaço 3D são obtidos. Estes pontos são obtidos por comparação 
            % entre retas reversas (linhas de visada prolongadas até o 
            % centróide do alvo). A distância máxima permitida entre as 
            % retas é de 0.5 metros.
            cam{n}.tracks = points3D( cam{n}.tracks,...
                                      cam{n}.extrinsec,...
                                      cam{n}.intrinsec,...
                                      bufferLoS,...
                                      sendCamera,...
                                      Ticks_c,...
                                      cycle_st,...
                                      cycle_end,...
                                      n,...
                                      Pinv,...
                                      k,...
                                      debug );
            
            %% Filtros: sem consenso
            % BAF 2: 
            % o primeiro  cálculo não leva em consideração consenso entre câmera
            cam{n}.tracks = BAF2( cam{n}.tracks,...
                                  cam{n}.extrinsec,...
                                  cam{n}.intrinsec,...
                                  n,... 
                                  Ticks_c,... 
                                  cycle_st,... 
                                  cycle_end,...
                                  H,... 
                                  F,... 
                                  Q,...
                                  Rinv,...
                                  k,...
                                  debug );

            % Particle Filter
            % o primeiro  cálculo não leva em consideração consenso entre câmeras
            cam{n}.tracks = PFilter( cam{n}.tracks,...
                                     cam{n}.extrinsec,...
                                     cam{n}.intrinsec,...
                                     n,... 
                                     Ticks_c,... 
                                     cycle_st,... 
                                     cycle_end,...
                                     k,...
                                     debug );
            
        end% end da n-ésima câmera
        
        %% Consenso entre câmeras 
        cam = consensusSend( cam, Ticks_c, cycle_end, N, k, F, Q, p_consensus );
        
        %% cálculo do RMSE dentro de cada uma das janelas temporais   
        typeData = 1;% fusão de LoS
        Sk_Error(1,k) = computeStats( cam, Ticks_c, cycle_st, cycle_end, N, k, typeData );
        
        typeData = 2;% BAF (transmissão de atraso)- (Batch Asynchronous Filter)
        Sk_Error(2,k) = computeStats( cam, Ticks_c, cycle_st, cycle_end, N, k, typeData );

        typeData = 3;% filtro de partículas - (SA-PF - Sequential Asynchronous Particle Filter)
        Sk_Error(3,k) = computeStats( cam, Ticks_c, cycle_st, cycle_end, N, k, typeData );

        typeData = 4;% BAF (transmissão de atraso)- (Batch Asynchronous Filter) - consenso com p passos
        Sk_Error(4,k) = computeStats( cam, Ticks_c, cycle_st, cycle_end, N, k, typeData );
        
        typeData = 5;% PF (Particle Filter) - consenso com p passos
        Sk_Error(5,k) = computeStats( cam, Ticks_c, cycle_st, cycle_end, N, k, typeData );    
        
    end%end k 
    
    %% erro médio quadrático para cada rodada Monte-Carlo
    S_Error(1,r) = sum(Sk_Error(1,:),2)/numel(cycle_st);
    disp(['LoS Mean squared error (pixel^2) : ' num2str(S_Error(1,r))]);
    
    S_Error(2,r) = sum(Sk_Error(2,:),2)/numel(cycle_st);
    disp(['BAF-2 Mean squared error (pixel^2) : ' num2str(S_Error(2,r))]);

    S_Error(3,r) = sum(Sk_Error(3,:),2)/numel(cycle_st);
    disp(['PF Mean squared error (pixel^2) : ' num2str(S_Error(3,r))]);

    S_Error(4,r) = sum(Sk_Error(4,:),2)/numel(cycle_st);
    disp(['BAF Mean squared error (pixel^2) - Consensus: ' num2str(S_Error(4,r))]);

    S_Error(5,r) = sum(Sk_Error(5,:),2)/numel(cycle_st);
    disp(['PF Mean squared error (pixel^2) - Consensus: ' num2str(S_Error(5,r))]);
    
    %% volta os quadros para análise 
    % lê os vídeos das câmeras escolhidas e gera um objeto com as 
    % propriedades para análise dos quadros
    for n=1:N
        cam{n}.obj = setupSystemObjects(cam{n}.nodeId);
    end
end%end for r-th Monte-Carlo 

% RMSE para cada M rodada de Monte-Carlo
RMSE = zeros(5,1);
for alg = 1:5
   RMSE(alg) = sqrt(sum(S_Error(alg,:))/M); 
end