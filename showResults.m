function showResults(AA, target, targetMean, fusionPoints, camera, alvo, kcs, k_e, debug)

sz_targetmean = size(targetMean,2);
sz_fusionpoints = size(fusionPoints,2);

if debug == 1
    %----------------------------------------------------------------------
    % gráfico mostrando a trajetória do alvo no espaço 3D dentro da janela
    % temporal para cada um k-ésimos instantes dentro da janela
    % temporal - todos os pontos obtidos pela comparação das linhas de
    % visadas
    figure
    plot3(target(2,:),target(3,:),target(4,:),'b*')
    hold on
    plot3(AA.t(1),AA.t(2),AA.t(3),'r*')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    text(AA.t(1)+0.1,AA.t(2)+0.1,AA.t(3)+0.1,strcat('\bf C_','{',num2str(camera),'}'))
    line([repmat(AA.t(1),[1 size(target,2)]);target(2,:)],[repmat(AA.t(2),[1 size(target,2)]);target(3,:)],[repmat(AA.t(3),[1 size(target,2)]);target(4,:)],'Color','black','LineStyle','--')
    grid on
    %title(['\fontsize{12} Trajetória do alvo ',num2str(alvo),'\fontsize{12} dentro da janela temporal para a câmera ',num2str(camera)],...
    %      ['\newline \fontsize{12} \color{red} \it para os k-ésimos instantes: ',num2str(kcs)])
    %title(['\fontsize{12} Trajectory of target  ',num2str(alvo),'\fontsize{12} for a time window of camera ',num2str(camera)],...
    %      ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
    %text( target(2,1),target(3,1),target(4,1),strcat('\bf alvo_{',num2str(alvo),'}') )
    text( target(2,1),target(3,1),target(4,1),strcat('\bf target_{',num2str(alvo),'}') )
    xlabel('\bf x(m)','Interpreter','latex')
    ylabel('\bf y(m)','Interpreter','latex')
    zlabel('\bf z(m)','Interpreter','latex')
    grid on
    axes('position',[.55 .20 .20 .20])
    box on
    plot3(target(2,:),target(3,:),target(4,:),'b*')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    title('zoom:','3D points from determining proximity between $$\vec{\textbf{r}}_{1,k,i}^{w}$$ and $$\vec{\textbf{r}}_{t,k,j}^{w}$$','Interpreter','latex','FontSize',12)
    xlabel('\bf x (m)','Interpreter','latex')
    ylabel('\bf y (m)','Interpreter','latex')
    zlabel('\bf z (m)','Interpreter','latex')
    grid on
    axis tight
    hold off
  
    %----------------------------------------------------------------------
    % gráfico mostrando a trajetória do alvo no espaço 3D dentro da janela
    % temporal para cada um k-ésimos instantes dentro da janela
    % temporal - vista superior mostrando o período da janela temporal
    figure
    plot3(target(1,:),target(2,:),target(3,:),'*')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    %title(['\fontsize{12} Trajetória do alvo ',num2str(alvo),'\fontsize{12} dentro da janela temporal para a câmera ',num2str(camera)],...
    %      ['\newline \fontsize{12} \color{red} \it Vista superior para os k-ésimos instantes: ',num2str(kcs)])
    %title(['\fontsize{12} Trajectory of target ',num2str(alvo),'\fontsize{12} for a time window of camera ',num2str(camera)],...
    %      ['\newline \fontsize{12} \color{red} \it for k-th instants: ',num2str(kcs)])
    if ( k_e == min(kcs,[],2) )
        
        x1 = xline(k_e,'-.r','\bf K_{capture}','FontSize',14);
        x1.LabelVerticalAlignment = 'bottom';
        xline( max(kcs,[],2),'-.','\bf K_{end}','FontSize',14);
        
    elseif ( k_e == max(kcs,[],2) )
        
        x1=xline( min(kcs,[],2),'-.','\bf K_{ini}','FontSize',14);
        x1.LabelVerticalAlignment = 'bottom';
        xline(k_e,'-.r','\bf K_{capture}','FontSize',14);
    
    else
        
        x1=xline( min(kcs,[],2),'-.','\bf K_{ini}','FontSize',14);
        x1.LabelVerticalAlignment = 'bottom';
        x2 = xline(k_e,'-.r','\bf K_{capture}','FontSize',14);
        x2.LabelVerticalAlignment = 'bottom';
        xline( max(kcs,[],2),'-.','\bf K_{end}','FontSize',14);
        
    end
    xlabel('\bf k','Interpreter','latex')
    ylabel('\bf x(m)','Interpreter','latex')
    zlabel('\bf y(m)','Interpreter','latex')
    grid on
    
    %----------------------------------------------------------------------
    % gráfico mostrando a trajetória do alvo no espaço 3D dentro da janela
    % temporal para cada um k-ésimos dos instantes dentro da janela
    % temporal - resultado da média para cada um dos alvos obtidos
    figure
    subplot(1,2,1)
    plot3(targetMean(2,:),targetMean(3,:),targetMean(4,:),'*')
    %title(['\fontsize{12} Trajetória do alvo ',num2str(alvo),'\fontsize{12} no espaço 3D dentro da janela temporal para a câmera ',num2str(camera)],...
    %      ['\newline \fontsize{12} \color{red} \it Vista 3D para os k-ésimos instantes: ',num2str(kcs)])
    %title(['\fontsize{12} Trajectory of target ',num2str(alvo),'\fontsize{12} in 3D space for a time window of camera ',num2str(camera)],...
    %      ['\newline \fontsize{12} \color{red} \it 3D view for the k-th instants: ',num2str(kcs)])
    hold on
    plot3(AA.t(1),AA.t(2),AA.t(3),'r*')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    text(AA.t(1)+0.1,AA.t(2)+0.1,AA.t(3)+0.1,strcat('\bf C_','{',num2str(camera),'}'))
    line([repmat(AA.t(1),[1 size(targetMean,2)]);targetMean(2,:)],[repmat(AA.t(2),[1 size(targetMean,2)]);targetMean(3,:)],[repmat(AA.t(3),[1 size(targetMean,2)]);targetMean(4,:)],'Color','black','LineStyle','--')
    text( targetMean(2,1),targetMean(3,1),targetMean(4,1),strcat('\bf target_{',num2str(alvo),'}') )
    xlabel('\bf x(m)','Interpreter','latex')
    ylabel('\bf y(m)','Interpreter','latex')
    zlabel('\bf z(m)','Interpreter','latex')
    hold on
    grid on
    %axes('position',[.55 .20 .20 .20])
    %box on
    subplot(1,2,2)
    plot3(targetMean(2,:),targetMean(3,:),targetMean(4,:),'*')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    for ii=1:sz_targetmean 
        text(targetMean(2,ii),targetMean(3,ii),targetMean(4,ii),strcat('k=',num2str(targetMean(1,ii))),'FontSize',12)
        hold on
    end
    %title('\fontsize{9} Ampliação dos','\fontsize{9} \bf pontos obtidos no espaço 3D')
    title('\bf{zoom of}','\bf{UT means $$\mu_{j,k}$$ in 3D space}','Interpreter','latex','FontSize',12)
    xlabel('\bf x (m)','Interpreter','latex')
    ylabel('\bf y (m)','Interpreter','latex')
    zlabel('\bf z (m)','Interpreter','latex')
    grid on
    axis tight
    hold off
    
    %----------------------------------------------------------------------
    % gráfico mostrando a trajetória do alvo no espaço 3D dentro da janela
    % temporal para cada um k-ésimos dos instantes dentro da janela
    % temporal - resultado da média total para cada um dos instantes (fusão das médias)
    figure
    subplot(1,2,1)
    plot3(fusionPoints(2,:),fusionPoints(3,:),fusionPoints(4,:),'*')
    %title(['\fontsize{12} Trajetória do alvo ',num2str(alvo),'\fontsize{12} no espaço 3D dentro da janela temporal para a câmera ',num2str(camera)],...
    %      ['\newline \fontsize{12} \color{red} \it Vista 3D para os k-ésimos instantes: ',num2str(kcs)])
    %title(['\fontsize{12} Trajectory of target ',num2str(alvo),'\fontsize{12} in 3D space for a time window of camera ',num2str(camera)],...
    %      ['\newline \fontsize{12} \color{red} \it 3D view for the k-th instants: ',num2str(kcs)])
    hold on
    for ii=1:sz_fusionpoints 
        text(fusionPoints(2,ii),fusionPoints(3,ii),fusionPoints(4,ii),strcat('k=',num2str(fusionPoints(1,ii))),'FontSize',12)
        hold on
    end
    plot3(AA.t(1),AA.t(2),AA.t(3),'r*')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    text(AA.t(1)+0.1,AA.t(2)+0.1,AA.t(3)+0.1,strcat('\bf C_','{',num2str(camera),'}'))
    line([repmat(AA.t(1),[1 size(fusionPoints,2)]);fusionPoints(2,:)],[repmat(AA.t(2),[1 size(fusionPoints,2)]);fusionPoints(3,:)],[repmat(AA.t(3),[1 size(fusionPoints,2)]);fusionPoints(4,:)],'Color','black','LineStyle','--')
    xlabel('\bf x(m)','Interpreter','latex')
    ylabel('\bf y(m)','Interpreter','latex')
    zlabel('\bf z(m)','Interpreter','latex')
    hold on
    grid on
    %axes('position',[.55 .20 .20 .20])
    %box on
    subplot(1,2,2)
    plot3(fusionPoints(2,:),fusionPoints(3,:),fusionPoints(4,:),'*')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    for ii=1:sz_fusionpoints  
        text(fusionPoints(2,ii),fusionPoints(3,ii),fusionPoints(4,ii),strcat('k=',num2str(fusionPoints(1,ii))),"FontSize",12)
        hold on
    end
    %title('\fontsize{9} Ampliação dos','\fontsize{9} \bf pontos obtidos no espaço 3D')
    title('\bf{zoom of}','\bf{UT means $$\mu_{j,k}$$ in 3D space}','Interpreter','latex','FontSize',12)
    xlabel('\bf x (m)','Interpreter','latex')
    ylabel('\bf y (m)','Interpreter','latex')
    zlabel('\bf z (m)','Interpreter','latex')
    grid on
    axis tight
    hold off
    
end


    
    

