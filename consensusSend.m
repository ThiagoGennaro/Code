function cam = consensusSend( cam, LTicks_c, cycle_end, N, k, F, Q, p_consensus )


% verifica se acabou o ciclo da janela temporal
cIdx = find(k == cycle_end);
        
% entra no processamento somente se k é o fim do ciclo da janela temporal
if numel(cIdx) == 1
    
    %cs = cycle_st(cIdx);  % começo do ciclo
    %ce = cycle_end(cIdx); % término do ciclo
    Nj = 8; % câmeras vizinhas
    transmit = randi([0 1],Nj,p_consensus);% variável aleatória de envio das câmeras - n passos de consenso 
    sz_css = size(transmit,2);
    
    for css = 1:sz_css

        for n = 1:N
    
            % momento de transmissão dado pela linha de relógio na função ClockCamerasGenerator
            % para o último instante da janela temporal
            if (transmit(n,css) == 1)
                
                % acha o momento de captura
                kk = find(LTicks_c(n,1:k)==2);
                k_e = kk(end);
    
                % número de alvos no k-ésimo instante
                PP = length(cam{n}.tracks);
                
                % para cada um dos p alvos
                for t = 1:PP% t:targets
                    
                    % verifica se o alvo já foi detectado
                    if (cam{n}.tracks(t).fz == 1)
    
                        % para cada uma das vizinhas
                        for nj = 1:Nj
                            
                            % para câmeras distintas da câmera n que está
                            % enviando a medida
                            if( n~=nj )
    
                                % acha o momento de captura da câmera vizinha
                                kk_j = find(LTicks_c(nj,1:k)==2);
                                k_e_j = kk_j(end);
    
                                % quantidade de alvos vizinhos
                                PP_nj = length(cam{nj}.tracks);
                                
                                % para cada um dos alvos vizinhos 
                                for tj = 1:PP_nj
                                    
                                    % verifica se o alvo vizinho foi detectado
                                    if (cam{nj}.tracks(tj).fz == 1)
                                        
                                        % contador para realizar a média final
                                        ncount = 1;
    
                                        % realiza a predição do alvo para o
                                        % momento de captura em relação ao
                                        % momento de captura da câmera vizinha
                                        [ yy,YY ] = IFpredict( cam{n}.tracks(t).y(:,k_e),cam{n}.tracks(t).Y(:,:,k_e),k_e,k_e_j,F,Q );
                                        
                                        % estado estimado para o alvo i
                                        target_i = YY\yy;
    
                                        % valor do estado estimado do alvo j
                                        target_j = cam{nj}.tracks(tj).Y(:,:,k_e_j)\cam{nj}.tracks(tj).y(:,k_e_j);
                                        
                                        % distância euclidiana entre os alvos
                                        % da câmera que enviou, e os alvos da
                                        % câmera que recebeu
                                        d = norm(target_i - target_j);
                                        
                                        % atualização da medida para o filtro
                                        % de partículas para o momento de
                                        % captura da câmera vizinha
                                        pftarget_i = F(k_e,k_e_j)*cam{n}.tracks(t).pf_x(:,k_e);
    
                                        % valor do estado estimado do alvo j no
                                        % filtro de partículas
                                        pftarget_j = cam{nj}.tracks(tj).pf_x(:,k_e_j);
                                        
                                        % verificação se trata do mesmo alvo
                                        if d<=0.5
                                            %% BAF (delay transmission)
                                            ncount = ncount + 1;
                                            
                                            % resultado do consenso entre as câmeras
                                            target_mean = (target_i + target_j)/ncount;
                                            cam{nj}.tracks(tj).xx(:,k_e_j)   = target_mean;
                                            
                                            % transfomação 3D em 2D 
                                            cam{nj}.tracks(tj).xx3Dto2D(:,k_e_j) = camCoordToPixels(worldToCamCoord(cam{nj}.tracks(tj).xx(1:3,k_e_j), cam{nj}.extrinsec.R, cam{nj}.extrinsec.C_t), cam{nj}.intrinsec );
                                            
                                            %% Particle Filter
    
                                            % resultado do consenso entre as câmeras
                                            target_mean_pf = (pftarget_i + pftarget_j)/ncount;
                                            cam{nj}.tracks(tj).pf_xx(:,k_e_j) = target_mean_pf;
                                            
                                            % transfomação 3D em 2D
                                            cam{nj}.tracks(tj).pf_xx3Dto2D(:,k_e_j) = camCoordToPixels(worldToCamCoord(cam{nj}.tracks(tj).pf_xx(1:3,k_e_j), cam{nj}.extrinsec.R, cam{nj}.extrinsec.C_t), cam{nj}.intrinsec );
                                        end
    
                                    end
    
                                end
    
                            end
    
                        end
    
                    end
    
                end
    
            end
    
        end

    end

end