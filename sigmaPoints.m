% function [ psA, psB ] = sigmaPoints( A, B )

% Input-: 
% A e B pontos principais a serem avaliados.
% A(x1,y1,z=f1)=> ponto da linha de visada do t-ésimo alvo visto pela i-ésima câmera. 
% B(x2,y2,z=f2)=> ponto da linha de visada do t-ésimo alvo recebida da j-ésima câmera vizinha.
% c coeficiente 
% C covariância do alvo
%
% Output-:
% psA e psB são os "sigma points" referentes a LoS de cada um dos alvos 
% correspondendo a 7 linhas de visadas por alvo
%

function [ psA, psB ] = sigmaPoints( A, B, camera, camera_j, alvo, debug )

%%  Fatores de escala utilizados na função sigmaPoints

% fator de escala
ki = 0;
alpha = 1e-3;%default
% dimensão
L = 3; 
% fator de escala
lambda = (alpha^2)*(L + ki) - L;
c = L + lambda;
% tamanho do estado
n = 3; 
beta = 2;
% pesos para as medidas
Wm = [ lambda/c 0.5/c+zeros(1,2*L) ]; 
% pesos da covariância
Wc = Wm;
Wc(1) = Wc(1) + (1 - alpha^2 + beta);
% c coeficiente
c = sqrt(c); 
%% cálculo dos sigma points 

% covariância dos alvos - incerteza atribuída a linha de visada do alvo no
% plano da imagem
C = [1e-4 0 0;0 1e-4 0; 0 0 1e-4];

% quantidade de "sigma points" do alvo da i-ésima câmera (7 pontos)
psA = sigmas(A(4:6),C,c);
psA = [repmat(A(1:3),[1 7]);psA];

% quantidade de "sigma points" do alvo recebidos da j-ésima câmera vizinha
% (7 pontos)
psB = sigmas(B(4:6),C,c);
psB = [repmat(B(1:3),[1 7]);psB];

%% Plots
if debug == 1
    
    figure
    plot3(A(1),A(2),A(3),'r*')
    hold on
    plot3(A(1)+A(4),A(2)+A(5),A(3)+A(6),'b*')
    hold on
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    line([A(1);A(1)+A(4)],[A(2);A(2)+A(5)],[A(3);A(3)+A(6)],'Color','black','LineStyle','--','Marker','>','LineWidth',2)
    %title(['\fontsize{12} LoS to target ',num2str(alvo),' on camera ',num2str(camera)],['\fontsize{12} \bf on the z=f axis'])
    text( A(1),A(2),A(3),strcat('\bf C_{',num2str(camera),'}') )
    text( max(psA(1)+psA(4,:)),max(psA(2)+psA(5,:)),max(psA(3)+psA(6,:)),strcat('\bf target_{',num2str(alvo),'}') )
    annotation('textarrow',[0.3 0.5],[0.6  0.5],'String','$$\lambda\vec{\bf{LoS}}_{1,k,1}^{w}$$','Interpreter','latex','FontSize',12)
    annotation('textarrow',[0.6 0.7],[0.8  0.85],'String','$$\vec{_{c}^{w}\bf{t}}^{1}$$','Interpreter','latex','FontSize',12)
    annotation('textarrow',[0.28 0.35],[0.3  0.18],'String','$$\vec{\bf{r}}_{1,k,1}^{w}(\lambda)$$','Interpreter','latex','FontSize',12)
    xlabel('x (m)','Interpreter','latex')
    ylabel('y (m)','Interpreter','latex')
    zlabel('z (m)','Interpreter','latex')
    grid on

    figure
    plot3(psA(1)+psA(4,:),psA(2)+psA(5,:),psA(3)+psA(6,:),'*')
    hold on
    plot3(psA(1),psA(2),psA(3),'r*')
    hold on
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    line([repmat(psA(1),[1 size(psA,2)]);psA(1)+psA(4,:)],[repmat(psA(2),[1 size(psA,2)]);psA(2)+psA(5,:)],[repmat(psA(3),[1 size(psA,2)]);psA(3)+psA(6,:)],'Color','black','LineStyle','--')
    %title(['\fontsize{12} "Sigma Points" do alvo ',num2str(alvo),' na câmera ',num2str(camera)],['\fontsize{12} \bf no eixo z=f'])
    %title(['\fontsize{12} Sigma Points to target ',num2str(alvo),' on camera ',num2str(camera)],['\fontsize{12} \bf on the z=f axis'])
    text( psA(1),psA(2),psA(3),strcat('\bf C_{',num2str(camera),'}') )
    %text( max(psA(1)+psA(4,:)),max(psA(2)+psA(5,:)),max(psA(3)+psA(6,:)),strcat('\bf alvo_{',num2str(alvo),'}') )
    text( max(psA(1)+psA(4,:)),max(psA(2)+psA(5,:)),max(psA(3)+psA(6,:)),strcat('\bf target_{',num2str(alvo),'}') )
    xlabel('x (m)','Interpreter','latex')
    ylabel('y (m)','Interpreter','latex')
    zlabel('z (m)','Interpreter','latex')
    grid on
    axes('position',[.55 .20 .20 .20])
    box on
    plot3(psA(1)+psA(4,:),psA(2)+psA(5,:),psA(3)+psA(6,:),'b*')
    %title('\fontsize{9} Ampliação dos ','\fontsize{9} \bf "sigma points"')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    title('\fontsize{12} Zoom of ','\fontsize{12} \bf sigma points')
    xlabel('x (m)','Interpreter','latex')
    ylabel('y (m)','Interpreter','latex')
    zlabel('z (m)','Interpreter','latex')
    grid on
    axis tight
    
    figure
    plot3(psB(1)+psB(4,:),psB(2)+psB(5,:),psB(3)+psB(6,:),'*')
    hold on
    plot3(psB(1),psB(2),psB(3),'r*')
    hold on
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    line([repmat(psB(1),[1 size(psB,2)]);psB(1)+psB(4,:)],[repmat(psB(2),[1 size(psB,2)]);psB(2)+psB(5,:)],[repmat(psB(3),[1 size(psB,2)]);psB(3)+psB(6,:)],'Color','black','LineStyle','--')
    %title(['\fontsize{12} "Sigma Points" do alvo ',' observado na câmera vizinha ',num2str(camera_j)],['\fontsize{12} \bf no eixo z=f'])
    %title(['\fontsize{12} Sigma Points to target_{x} ',' on the receiving camera ',num2str(camera),' from neighboring camera ',num2str(camera_j)],['\fontsize{12} \bf on the z=f axis'])
    text( psB(1),psB(2),psB(3),strcat('\bf C_{',num2str(camera_j),'}') )
    %text( max(psB(1)+psB(4,:)),max(psB(2)+psB(5,:)),max(psB(3)+psB(6,:)),strcat('\bf alvo_{x}') )
    text( max(psB(1)+psB(4,:)),max(psB(2)+psB(5,:)),max(psB(3)+psB(6,:)),strcat('\bf target_{x}') )
    xlabel('x (m)','Interpreter','latex')
    ylabel('y (m)','Interpreter','latex')
    zlabel('z (m)','Interpreter','latex')
    grid on
    axes('position',[.55 .20 .20 .20])
    box on
    plot3(psB(1)+psB(4,:),psB(2)+psB(5,:),psB(3)+psB(6,:),'b*')
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    %title('\fontsize{9} Ampliação dos ','\fontsize{9} \bf "sigma points"')
    title('\fontsize{9} Zoom of ','\fontsize{9} \bf sigma points')
    xlabel('x (m)','Interpreter','latex')
    ylabel('y (m)','Interpreter','latex')
    zlabel('z (m)','Interpreter','latex')
    grid on
    axis tight

end