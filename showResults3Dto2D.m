function showResults3Dto2D( meas3Dto2D, centroids, camera, alvo, kcs, k_e, k, debug  )

if debug == 1
    
    % tipo de câmera utilizada e sua resolução
    [model,resolution,~] = camModel(camera);
    
    %----------------------------------------------------------------------
    figure
    plot(centroids(1,kcs),centroids(2,kcs),'o')
    hold on
    plot(meas3Dto2D(1,kcs),meas3Dto2D(2,kcs),'*r')
    hold on
    plot(centroids(1,k_e),centroids(2,k_e),'mo')
    hold on
    patch([0 resolution.W resolution.W 0],[0 0 resolution.H resolution.H],'g','FaceAlpha',.1)
    hold on
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    %title(['\fontsize{12} Trajetória do alvo ',num2str(alvo),'\fontsize{12} no plano da imagem para a câmera ',num2str(camera),' modelo ',model],...
    %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
    title(['\fontsize{12} Trajectory of target ',num2str(alvo),'\fontsize{12} on image plane for camera ',num2str(camera),' model ',model],...
          ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
    xlabel('\bf width(pixels)','Interpreter','latex')
    ylabel('\bf height(pixels)','Interpreter','latex')
    %legend('medida real','medida obtida da comparação de LoS','momento de captura')
    legend('Real measurement','Measurement obtained by comparision of $$\vec{\textbf{r}}_{t,k,i}^{w}$$ and $$\vec{\textbf{r}}_{t,k,i}^{w}$$' ,'Capture moment','Interpreter','latex','Fontsize',12)
    grid on
    hold off
    
    %----------------------------------------------------------------------
    figure
    imshow(strcat('C:\Users\Thiago\Dropbox\DoutoradoITA\Código_Matlab\Time_12-34\View_00',num2str(camera),'\frame_',num2str(k,'%04d'),'.jpg'))
    hold on
    plot(centroids(1,kcs),centroids(2,kcs),'o')
    hold on
    plot(meas3Dto2D(1,kcs),meas3Dto2D(2,kcs),'*r')
    hold on
    plot(centroids(1,k_e),centroids(2,k_e),'mo')
    hold on
    patch([0 resolution.W resolution.W 0],[0 0 resolution.H resolution.H],'g','FaceAlpha',.1)
    hold on
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    %title(['\fontsize{12} Trajetória do alvo ',num2str(alvo),'\fontsize{12} no plano da imagem para a câmera ',num2str(camera),' modelo ',model],...
    %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
    title(['\fontsize{12} Trajectory  of target ',num2str(alvo),'\fontsize{12} on image plane for camera ',num2str(camera),' model ',model],...
          ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
    xlabel('\bf width(pixels)','Interpreter','latex')
    ylabel('\bf height(pixels)','Interpreter','latex')
    %legend('medida real','medida obtida da comparação de LoS','momento de captura')
    legend('Real measurement','Measurement obtained by comparision of $$\vec{\textbf{r}}_{t,k,i}^{w}$$ and $$\vec{\textbf{r}}_{t,k,i}^{w}$$' ,'Capture moment','Interpreter','latex','Fontsize',12)
    grid on
    hold off

end



    
    
