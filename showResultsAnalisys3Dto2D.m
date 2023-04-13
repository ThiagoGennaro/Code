function showResultsAnalisys3Dto2D( tracks, camera, extrinsec, kcs, k_e, k, filtro, typefilter, debug )


    % tipo de câmera utilizada, e sua resolução
    [model,resolution,~] = camModel(camera);


    if debug == 1
        
        % escolha para mostrar o resultado do filtro
        if filtro == 0 % não mostra o resultado do filtro

            %----------------------------------------------------------------------
            figure
            plot(tracks.bufferCentroids(1,kcs),tracks.bufferCentroids(2,kcs),'o')
            hold on
            plot(tracks.meas3Dto2D(1,kcs),tracks.meas3Dto2D(2,kcs),'*r')
            hold on
            plot(tracks.meas3Dto2D(1,k_e),tracks.meas3Dto2D(2,k_e),'go')
            hold on
            patch([0 resolution.W resolution.W 0],[0 0 resolution.H resolution.H],'g','FaceAlpha',.1)
            hold on
            %title(['\fontsize{12} Trajetória do alvo ',num2str(tracks.id),'\fontsize{12} no plano da imagem para a câmera ',num2str(camera),' modelo ',model],...
            %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
            %title(['\fontsize{12} Trajectory of target ',num2str(alvo),'\fontsize{12} on image plane for camera ',num2str(camera),' model ',model],...
            %      ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
            set(groot,'defaultAxesTickLabelInterpreter','latex');
            xticklabels(strrep(xticklabels,'-','$-$'));
            yticklabels(strrep(yticklabels,'-','$-$'));
            xlabel('\bf width(pixels)','Interpreter','latex')
            ylabel('\bf height(pixels)','Interpreter','latex')
            %legend('medida real','medida obtida da comparação de LoS e polinômio interpolante','medida obtida da fusão de LoS no momento de captura')
            legend('real measurement','measurement obtained by LoS comparision and polynomial interpolating','obtained measurement of LoS fusion on capture moment')
            grid on
            hold off
    
            %----------------------------------------------------------------------
            figure
            imshow(strcat('C:\Users\Thiago\Dropbox\DoutoradoITA\Código_Matlab\Time_12-34\View_00',num2str(camera),'\frame_',num2str(k,'%04d'),'.jpg'))
            hold on
            plot(tracks.bufferCentroids(1,kcs),tracks.bufferCentroids(2,kcs),'o')
            hold on
            plot(tracks.meas3Dto2D(1,kcs),tracks.meas3Dto2D(2,kcs),'*r')
            hold on
            plot(tracks.meas3Dto2D(1,k_e),tracks.meas3Dto2D(2,k_e),'go')
            hold on
            patch([0 resolution.W resolution.W 0],[0 0 resolution.H resolution.H],'g','FaceAlpha',.1)
            hold on
            set(groot,'defaultAxesTickLabelInterpreter','latex');
            xticklabels(strrep(xticklabels,'-','$-$'));
            yticklabels(strrep(yticklabels,'-','$-$'));
            %title(['\fontsize{12} Trajetória do alvo ',num2str(tracks.id),'\fontsize{12} no plano da imagem para a câmera ',num2str(camera),' modelo ',model],...
            %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
            title(['\fontsize{12} Trajectory of target ',num2str(tracks.id),'\fontsize{12} on image plane for camera ',num2str(camera),' model ',model],...
                  ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
            xlabel('\bf width(pixels)','Interpreter','latex')
            ylabel('\bf height(pixels)','Interpreter','latex')
            %legend('medida real','medida obtida da comparação de LoS e polinômio interpolante','medida obtida da fusão de LoS no momento de captura')
            legend('real measurement','measurement obtained by LoS comparision and polynomial interpolating','obtained measurement of LoS fusion on capture moment')
            grid on
            hold off

        else % mostra o resultado do filtro
            
            switch typefilter
                
                case 'BAF'
                    %----------------------------------------------------------------------
                    figure
                    plot(tracks.bufferCentroids(1,kcs),tracks.bufferCentroids(2,kcs),'o')
                    hold on
                    plot(tracks.x3Dto2D(1,k_e),tracks.x3Dto2D(2,k_e),'*g')
                    hold on
                    plot(tracks.bufferCentroids(1,k_e),tracks.bufferCentroids(2,k_e),'ro')
                    hold on
                    patch([0 resolution.W resolution.W 0],[0 0 resolution.H resolution.H],'g','FaceAlpha',.1)
                    hold on
                    set(groot,'defaultAxesTickLabelInterpreter','latex');
                    xticklabels(strrep(xticklabels,'-','$-$'));
                    yticklabels(strrep(yticklabels,'-','$-$'));
                    %title(['\fontsize{12} Trajetória do alvo ',num2str(tracks.id),'\fontsize{12} no plano da imagem para a câmera ',num2str(camera),' modelo ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
                    title(['\fontsize{12} Trajectory of target ',num2str(tracks.id),'\fontsize{12} on image plane for camera ',num2str(camera),' model ',model],...
                          ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
                    xlabel('\bf width(pixels)','Interpreter','latex')
                    ylabel('\bf height(pixels)','Interpreter','latex')
                    %legend('medida real', 'resultado do filtro BAF no momento de captura' )
                    legend('real mesurement','BAF filter result on capture moment')
                    grid on
                    hold off
            
                    %----------------------------------------------------------------------
                    figure
                    imshow(strcat('C:\Users\Thiago\Dropbox\DoutoradoITA\Código_Matlab\Time_12-34\View_00',num2str(camera),'\frame_',num2str(k,'%04d'),'.jpg'))
                    hold on
                    plot(tracks.bufferCentroids(1,kcs),tracks.bufferCentroids(2,kcs),'o')
                    hold on
                    plot(tracks.x3Dto2D(1,k_e),tracks.x3Dto2D(2,k_e),'*g')
                    hold on
                    plot(tracks.bufferCentroids(1,k_e),tracks.bufferCentroids(2,k_e),'ro')
                    hold on
                    patch([0 resolution.W resolution.W 0],[0 0 resolution.H resolution.H],'g','FaceAlpha',.1)
                    hold on
                    set(groot,'defaultAxesTickLabelInterpreter','latex');
                    xticklabels(strrep(xticklabels,'-','$-$'));
                    yticklabels(strrep(yticklabels,'-','$-$'));
                    %title(['\fontsize{12} Trajetória do alvo ',num2str(tracks.id),'\fontsize{12} no plano da imagem para a câmera ',num2str(camera),' modelo ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
                    title(['\fontsize{12} Trajectory of target ',num2str(tracks.id),'\fontsize{12} on image plane for camera ',num2str(camera),' model ',model],...
                          ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
                    xlabel('\bf width(pixels)','Interpreter','latex')
                    ylabel('\bf height(pixels)','Interpreter','latex')
                    %legend('medida real','resultado do filtro BAF no momento de captura')
                    legend('real mesurement','BAF filter result on capture moment')
                    grid on
                    hold off

                case 'PF'
                    %----------------------------------------------------------------------
                    figure
                    plot(tracks.bufferCentroids(1,kcs),tracks.bufferCentroids(2,kcs),'o')
                    hold on
                    plot(tracks.pf_x3Dto2D(1,k_e),tracks.pf_x3Dto2D(2,k_e),'*g')
                    hold on
                    plot(tracks.bufferCentroids(1,k_e),tracks.bufferCentroids(2,k_e),'ro')
                    hold on
                    patch([0 resolution.W resolution.W 0],[0 0 resolution.H resolution.H],'g','FaceAlpha',.1)
                    hold on
                    set(groot,'defaultAxesTickLabelInterpreter','latex');
                    xticklabels(strrep(xticklabels,'-','$-$'));
                    yticklabels(strrep(yticklabels,'-','$-$'));
                    %title(['\fontsize{12} Trajetória do alvo ',num2str(tracks.id),'\fontsize{12} no plano da imagem para a câmera ',num2str(camera),' modelo ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
                    %title(['\fontsize{12} Trajectory of target ',num2str(tracks.id),'\fontsize{12} on image plane for camera ',num2str(camera),' model ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
                    xlabel('\bf width(pixels)','Interpreter','latex')
                    ylabel('\bf height(pixels)','Interpreter','latex')
                    %legend('medida real', 'resultado do filtro PF no momento de captura','momento de captura' )
                    legend('real mesurement','PF filter result on capture moment','capture moment')
                    grid on
                    hold off
            
                    %----------------------------------------------------------------------
                    figure
                    imshow(strcat('C:\Users\Thiago\Dropbox\DoutoradoITA\Código_Matlab\Time_12-34\View_00',num2str(camera),'\frame_',num2str(k,'%04d'),'.jpg'))
                    hold on
                    plot(tracks.bufferCentroids(1,kcs),tracks.bufferCentroids(2,kcs),'o')
                    hold on
                    plot(tracks.pf_x3Dto2D(1,k_e),tracks.pf_x3Dto2D(2,k_e),'*g')
                    hold on
                    plot(tracks.bufferCentroids(1,k_e),tracks.bufferCentroids(2,k_e),'ro')
                    hold on
                    patch([0 resolution.W resolution.W 0],[0 0 resolution.H resolution.H],'g','FaceAlpha',.1)
                    hold on
                    %title(['\fontsize{12} Trajetória do alvo ',num2str(tracks.id),'\fontsize{12} no plano da imagem para a câmera ',num2str(camera),' modelo ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
                    title(['\fontsize{12} Trajectory of target ',num2str(tracks.id),'\fontsize{12} on image plane for camera ',num2str(camera),' model ',model],...
                          ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
                    xlabel('\bf width(pixels)','Interpreter','latex')
                    ylabel('\bf height(pixels)','Interpreter','latex')
                    %legend('medida real','resultado do filtro PF no momento de captura','momento de captura')
                    legend('real mesurement','PF filter result on capture moment','capture moment')
                    grid on
                    hold off

                    figure
                    plot3(tracks.measLoS(2,k_e),tracks.measLoS(3,k_e),tracks.measLoS(4,k_e),'r*','LineWidth',10)
                    hold on
                    plot3(tracks.pf.Particles(:,1),tracks.pf.Particles(:,2),tracks.pf.Particles(:,3),'bo')
                    hold on
                    plot3(tracks.pf_x(1,k_e),tracks.pf_x(2,k_e),tracks.pf_x(3,k_e),'*g','LineWidth',10)
                    %hold on
                    %title(['\fontsize{12} Resultado do filtro de Partículas para o alvo ',num2str(tracks.id),'\fontsize{12} no espaço 3D na câmera ',num2str(camera),' modelo ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it para o k-ésimo instante de captura ',num2str(k_e)])
                    %title(['\fontsize{12} Particle Filter result for target ',num2str(tracks.id),'\fontsize{12} on 3D space for camera ',num2str(camera),' model ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it of k-th instants ',num2str(kcs)])
                    xlabel('\bf x(m)','Interpreter','latex')
                    ylabel('\bf y(m)','Interpreter','latex')
                    zlabel('\bf z(m)','Interpreter','latex')
                    %legend('medida obtida por comparação de LoS','Partículas n=1000','resultado do filtro PF no momento de captura')
                    legend('measurement obtained by LoS comparision','Number of particles n=1000','PF result on capture moment')
                    grid on
                    hold off

                    figure
                    plot3(tracks.measLoS(2,k_e),tracks.measLoS(3,k_e),tracks.measLoS(4,k_e),'r*','LineWidth',10)
                    hold on
                    plot3(tracks.pf.Particles(:,1),tracks.pf.Particles(:,2),tracks.pf.Particles(:,3),'bo')
                    hold on
                    plot3(tracks.pf_x(1,k_e),tracks.pf_x(2,k_e),tracks.pf_x(3,k_e),'*g','LineWidth',10)
                    hold on
                    plot3(extrinsec.t(1),extrinsec.t(2),extrinsec.t(3),'r*')
                    text(extrinsec.t(1)+0.1,extrinsec.t(2)+0.1,extrinsec.t(3)+0.1,strcat('\bf C_','{',num2str(camera),'}'))
                    %hold on
                    %hold on
                    %title(['\fontsize{12} Resultado do filtro de Partículas para o alvo ',num2str(tracks.id),'\fontsize{12} no espaço 3D na câmera ',num2str(camera),' modelo ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it para o k-ésimo instante de captura ',num2str(k_e)])
                    %title(['\fontsize{12} Particle Filter result for target ',num2str(tracks.id),'\fontsize{12} on 3D space for camera ',num2str(camera),' model ',model],...
                    %      ['\newline \fontsize{12} \color{red} \it of k-th instants ',num2str(kcs)])
                    xlabel('\bf x(m)','Interpreter','latex')
                    ylabel('\bf y(m)','Interpreter','latex')
                    zlabel('\bf z(m)','Interpreter','latex')
                    %legend('medida obtida por comparação de LoS','Partículas n=1000','resultado do filtro PF no momento de captura')
                    legend('measurement obtained by LoS comparision','Number of particles n=1000','PF result on capture moment')
                    grid on
                    hold off

            end

        end
    
    end