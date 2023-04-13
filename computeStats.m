function error_ip_dif = computeStats(cam, LTicks_c, cycle_st, cycle_end, N, k, type)

%% Mean Square Error (MSE) calculado no plano da imagem para cada uma das janelas temporais

% verifica se acabou o ciclo da janela temporal
cIdx = find(k == cycle_end);
        
% entra no processamento somente se k é o fim do ciclo da janela temporal
if numel(cIdx) == 1
    
    cs = cycle_st(cIdx);  % começo do ciclo
    ce = cycle_end(cIdx); % término do ciclo
    
    sum_error_N = 0;
    
    % para cada uma das n-ésimas câmeras
    for n=1:N
        
        % soma do erro médio no plano da imagem para todos os t-ésimos alvos 
        % na n-ésima câmera 
        sum_error_P = 0;
        
        % quantidade de alvos no k-ésimo instante
        PP = numel(cam{n}.tracks); 
        TT = 0;
        
        % para cada uma dos t-ésimos alvos
        for t = 1:PP% t: target
            
            % contador dos instantes de captura
            count_kc = 0;
            
            % soma de todos os erros no plano da imagem para todos os
            % instantes de captura para cada uma das câmeras para cada um dos
            % t-ésimos alvos
            sum_error_kc = 0;

            %erro médio no plano da imagem para todos os k-ésimos instantes de
            %captura da n-ésima câmera para os t-ésimos alvos
            avg_error_time = 0;
            
            % para todo período dentro da janela temporal
            for tw=cs:ce% tw: time window

                switch type% tipo de dados a serem comparados
                    
                    case 1% comparação entre os centroids reais e os obtidos pelas comparações entre LoS

                        % instante de captura da câmera n dentro da janela temporal
                        if (LTicks_c(n,tw)==2)

                            z_gt = cam{n}.tracks(t).bufferCentroids(:,tw);
                
                            z_dif = cam{n}.tracks(t).meas3Dto2D(:,tw);

                        end
                        
                    case 2% comparação entre os centroids reais e os obtidos pelo filtro BAF-2

                         % instante de captura da câmera n dentro da janela temporal
                        if (LTicks_c(n,tw)==2)

                            z_gt = cam{n}.tracks(t).bufferCentroids(:,tw);
                        
                            z_dif = cam{n}.tracks(t).x3Dto2D(:,tw);

                        end
                        
                    case 3% comparação entre os centroids reais e os obtidos pelo filtro de partículas
                        % instante de captura da câmera n dentro da janela temporal
                        if (LTicks_c(n,tw)==2)

                            z_gt = cam{n}.tracks(t).bufferCentroids(:,tw);

                            z_dif = cam{n}.tracks(t).pf_x3Dto2D(:,tw);

                        end
                        
                    case 4% comparação com o BAF-2 e janela de consenso - p passos de consenso
                        if (LTicks_c(n,tw)==2)

                            z_gt = cam{n}.tracks(t).bufferCentroids(:,tw);

                            z_dif = cam{n}.tracks(t).xx3Dto2D(:,tw);

                        end

                    case 5% comparação com o PF e janela de consenso - p passos de consenso
                        if (LTicks_c(n,tw)==2)

                            z_gt = cam{n}.tracks(t).bufferCentroids(:,tw);

                            z_dif = cam{n}.tracks(t).pf_xx3Dto2D(:,tw);

                        end
                        
                end
            end
                    
            if (~isnan(z_gt(1)) && z_dif(1)>0)
                
                count_kc = count_kc + 1;
                TT = TT + 1;
                error_ip = ( z_gt(1)-z_dif(1) )^2 + ( z_gt(2)-z_dif(2) )^2;
                
                % erro acumulado no tempo
                sum_error_kc = sum_error_kc + error_ip;
            end

            if (count_kc~=0)
                avg_error_time = sum_error_kc/count_kc; % erro médio por tempo
            end
            sum_error_P = sum_error_P + avg_error_time;
        end
        if (TT~=0)
            avg_error_tracks = sum_error_P/TT;
            sum_error_N = sum_error_N + avg_error_tracks;
        end
    end
    error_ip_dif = sum_error_N/N;
else
    error_ip_dif = 0;
end


