function [ measLoS_3d_fusion,... 
           vetor_total_,... 
           vetor_total,...
           tracks ] = polinomialInterpolation3d( tracks,... 
                                                 tt_yA,...
                                                 n,... 
                                                 p,... 
                                                 T,... 
                                                 AA,...
                                                 k_e )

% mostra gráficos
debug=0;
% verifica as posições onde estão os NaN e os iguala a zero
tt_yA(isnan(tt_yA)) = 0;
% mostra quais são os não zeros do vetor 3D
B = any(tt_yA(2:4,:));
sz_nonzero = nnz(B);

sz = size(tt_yA,2);
ncount = 1;

%alocação de memória
timeStamp = NaN(1,sz_nonzero);
xpol = NaN(1,sz_nonzero);
ypol = NaN(1,sz_nonzero);
zpol = NaN(1,sz_nonzero);
measLoS_3d_fusion = NaN(4,1);

% vetor criado para guardar somente onde estão os dados 
for kk=1:sz
  if B(kk) == 1
      timeStamp(:,ncount) = tt_yA(1,kk);
      xpol(:,ncount) = tt_yA(2,kk);
      ypol(:,ncount) = tt_yA(3,kk);
      zpol(:,ncount) = tt_yA(4,kk);
      ncount = ncount+1;
  end
end

if ncount-1>0
    
    % coloca em ordem crescente por estampa temporal
    [vet,ind] = sort(timeStamp);
    sz_= size(vet,2);
    vetor_total = NaN(4,sz_);
   
    % coloca em ordem crescente os dados levando-se em conta a estampa temporal
    for kk_=1:sz_
        
        % vetor resultante de dados de posição(ões) em 3D
        vetor_total(:,kk_) = [timeStamp(:,ind(kk_));xpol(:,ind(kk_));ypol(:,ind(kk_));zpol(:,ind(kk_))];
        
    end
    
    if sz_>=2
               
        % obtêm os valores não repetidos do vetor de medidas
        [ value,index ] = unique(vetor_total(1,:));
        vetor_total_= zeros(4,length(value));
        
        % conta os valores repetidos 
        [ counts, ~ ] = histcounts(vetor_total(1,:));
        sz_counts = size(counts,2);
        
        % calcula a média de medidas encontradas por câmeras vizinhas com a
        % mesma estampa temporal (mesmo instante)
        Ncounts = 1;
        for ii=1:sz_counts
            if counts(ii)~=0
                
                % vetor que contém os diferentes valores obtidos da media e
                % e medidas de instantes distintos
                vetor_total_(:,Ncounts) = [value(Ncounts);mean(vetor_total(2:4,index(Ncounts):(index(Ncounts)+counts(ii)-1)),2)];
                Ncounts=Ncounts+1;
                
            end
        end
    else
        
        % caso em que o vetor tem valor único
        vetor_total_ = vetor_total;
        
    end
    
    sz_vet = size(vetor_total_,2);
    if sz_vet == 1
        
        measLoS_3d_fusion = [k_e;vetor_total_(2:4)];
        
        % alvo inicializado com a medida em 3D
        if tracks(p).measIni == 0
            
            tracks(p).measIni = 1;
            
            xa = [ measLoS_3d_fusion(2);
                          0.1;
                   measLoS_3d_fusion(3);
                          0.1; 
                   measLoS_3d_fusion(4);
                          0.01 ];
               
             Pinv = pinv([ 1   0    0   0    0   0;
                           0   0    1   0    0   0;
                           0   0    0   0    1   0;
                           0   0.1  0   0    0   0;
                           0   0    0   0.1  0   0;
                           0   0    0   0    0   0.1 ]);
            
            tracks(p).y(:,k_e) = Pinv*xa;
            tracks(p).Y(:,:,k_e) = Pinv;
        end
        
    else
        N = sz_vet-1;
        pol_x = polyfit(vetor_total_(1,:),vetor_total_(2,:),N);
        pol_y = polyfit(vetor_total_(1,:),vetor_total_(3,:),N);
        pol_z = polyfit(vetor_total_(1,:),vetor_total_(4,:),N);
        measLoS_3d_fusion = [k_e;polyval(pol_x,k_e);polyval(pol_y,k_e);polyval(pol_z,k_e)];
        
        % alvo inicializado com a medida em 3D
        if tracks(p).measIni == 0
            
            tracks(p).measIni = 1;
            
            xa = [ measLoS_3d_fusion(2);
                          0.1;
                   measLoS_3d_fusion(3);
                          0.1; 
                   measLoS_3d_fusion(4);
                          0.01 ];
                      
             Pinv = pinv([ 1   0    0   0    0   0;
                           0   0    1   0    0   0;
                           0   0    0   0    1   0;
                           0   0.1  0   0    0   0;
                           0   0    0   0.1  0   0;
                           0   0    0   0    0   0.1 ]);
            
            tracks(p).y(:,k_e) = Pinv*xa;
            tracks(p).Y(:,:,k_e) = Pinv;
        end
        
    end
else
    
    vetor_total_ = NaN(4,1);
    vetor_total  = NaN(4,1);
    
end
%% Plots
if ( (debug == 1) && (ncount-1>0) && (AA(1)~=0))
    
    figure
    plot3(vetor_total(2,:),vetor_total(3,:),vetor_total(4,:),'*')
    hold on
    trplot(T)
    hold on
    plot3(AA(1),AA(2),AA(3),'r*')
    text(AA(1)+0.1,AA(2)+0.1,AA(3)+0.25,strcat('C_','{',num2str(n),'}'))
    title(['\fontsize{12} Trajetória do centróide do alvo ',num2str(p),' \fontsize{12} dentro da janela temporal'])
    xlabel('x(m)','Interpreter','latex')
    ylabel('y(m)','Interpreter','latex')
    zlabel('z(m)','Interpreter','latex')
    grid on
    axes('position',[.65 .3 .25 .25])
    box on
    plot3(vetor_total(2,:),vetor_total(3,:),vetor_total(4,:),'b*')
    title('Pontos do centróide')
    xlabel('x (m)','Interpreter','latex')
    ylabel('y (m)','Interpreter','latex')
    zlabel('z (m)','Interpreter','latex')
    grid on
    axis tight
    hold off
    
    figure
    plot(vetor_total(2,:),vetor_total(3,:),'*')
    hold on
    plot(AA(1),AA(2),'r*')
    text(AA(1)+0.1,AA(2)+0.1,strcat('C_','{',num2str(n),'}'))
    x1=xline( min(vetor_total(2,:),[],2),'-.','K_{ini}');
    x1.LabelHorizontalAlignment = 'left';
    xline( max(vetor_total(2,:),[],2),'-.','K_{fim}');
    title(['\fontsize{12} Trajetória do alvo ',num2str(p),'\fontsize{12} dentro da janela temporal'],...
                  '\newline \fontsize{12} \color{red} \it Vista superior')
    xlabel('x(m)','Interpreter','latex')
    ylabel('y(m)','Interpreter','latex')
    zlabel('z(m)','Interpreter','latex')
    grid on
    
end
