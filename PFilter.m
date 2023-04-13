function tracks = PFilter( tracks, extrinsec, intrinsec, camera, LTicks_c, cycle_st, cycle_end, k, debug )
 
%--------------------------------------------------------------------------
%% processa os pontos dentro da janela temporal:
% verifica se acabou o ciclo da janela temporal
cIdx = find(k == cycle_end);

% entra no processamento somente se k é o fim do ciclo da janela temporal
if numel(cIdx) == 1
    

    kcs = cycle_st(cIdx):cycle_end(cIdx);  % começo do ciclo
    
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
        for t = 1:PP % t: targets

            % verifica se o alvo já foi inicializado em y e Y
            if ( tracks(t).fz == 1 && ~isnan(tracks(t).measLoS(1,k_)))

                 % predição
                predict(tracks(t).pf,k_,k_e);

                % Correct position based on the given measurement to get best estimation
                tracks(t).pf_x(:,k_) = correct(tracks(t).pf,[tracks(t).measLoS(2:4,k_)]');
                tracks(t).pf_xx(:,k_) = tracks(t).pf_x(:,k_);

                % transformação das medidas no espaço 3D para
                % medidas no plano da imagem da câmera
                tracks(t).pf_x3Dto2D(:,k_) = camCoordToPixels(worldToCamCoord(tracks(t).pf_x(1:3,k_), extrinsec.R, extrinsec.C_t), intrinsec );
                tracks(t).pf_xx3Dto2D(:,k_) = tracks(t).pf_x3Dto2D(:,k_);

                % mostra o resultado do filtro de partículas no plano
                % da imagem
                filter = 1;
                showResultsAnalisys3Dto2D( tracks(t), camera, extrinsec, kcs, k_e, k, filter, 'PF', debug );
            end

        end

    end

end

