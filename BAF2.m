function tracks = BAF2( tracks, extrinsec, intrinsec, camera, LTicks_c, cycle_st, cycle_end, H, F, Q, Rinv, k, debug )

%--------------------------------------------------------------------------
%% processa os pontos dentro da janela temporal:
% verifica se acabou o ciclo da janela temporal
cIdx = find(k == cycle_end);

% entra no processamento somente se k é o fim do ciclo da janela temporal
if numel(cIdx) == 1
    
    kcs = cycle_st(cIdx):cycle_end(cIdx);

    PP = numel(tracks);   % número de alvos
    
    %% índices dos momentos de captura para cada uma das janelas temporais
    
    % índice do primeiro instante de captura
    idx = find(LTicks_c(camera,1:k-1) == 2);
    if (numel(idx)>0)
        k_ = idx(end);% realiza a predição desde a última estimativa
    else
        k_ = 1;% realiza a predição do começo
    end
    
    sz_idx = size(idx,2);
    if sz_idx == 1
        k_e = idx;
    else
        k_e = idx(1,sz_idx-1);
    end

    if (LTicks_c(camera,k_e) == 2)

        % para cada um dos alvos existentes dentro da janela temporal
        for t=1:PP % t: targets

            % verifica se o alvo já foi inicializado em y e Y
            if ((tracks(t).fz == 1) && (tracks(t).y(1,k_e) ~= 0))

                % Atualização: predição de k_e para k
                [ tracks(t).y(:,k_),tracks(t).Y(:,:,k_) ] = IFpredict( tracks(t).y(:,k_e), tracks(t).Y(:,:,k_e), k_e, k_, F, Q );

                % Atualização da medida
                [ u,U ] = IFlikelihood( tracks(t).measLoS(2:4,k_), H(:,:,camera), Rinv );

                tracks(t).y(:,k_)   = tracks(t).y(:,k_) + u;
                tracks(t).Y(:,:,k_) = tracks(t).Y(:,:,k_) + U;
                
                %atualização do estado estimado: KLA estimated
                tracks(t).x(:,k_)   = tracks(t).Y(:,:,k_)\ tracks(t).y(:,k_);
                % buffer x
                tracks(t).xx(:,k_)  = tracks(t).x(:,k_);
                
                % transformação das medidas no espaço 3D para
                % medidas no plano a imagem da câmera
                tracks(t).x3Dto2D(:,k_) = camCoordToPixels(worldToCamCoord(tracks(t).x(1:3,k_), extrinsec.R, extrinsec.C_t), intrinsec );
                % buffer 3D para 2D
                tracks(t).xx3Dto2D(:,k_) = camCoordToPixels(worldToCamCoord(tracks(t).xx(1:3,k_), extrinsec.R, extrinsec.C_t), intrinsec );

                % mostra resultados com a tentativa de traçar todo percurso dentro
                % da janela temporal no plano da imagem
                filtro = 1;
                showResultsAnalisys3Dto2D(tracks(t), camera, extrinsec, kcs, k_e, k, filtro, 'BAF', debug );
            end

        end

    end
        
end

%--------------------------------------------------------------------------        





