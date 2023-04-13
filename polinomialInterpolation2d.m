function polinomialInterpolation2d( x, n, p, kcs, debug )

% verifica quantos elementos dentro da janela temporal são diferentes de
% zero
B = any(x);
sz_nonzero = nnz(B);
sz = size(x,2);

% alocação de memória
timeStamp = NaN(1,sz_nonzero);
xpol = NaN(1,sz_nonzero);
ypol = NaN(1,sz_nonzero);

%contador para alocar somete os dados diferentes de zero
ncount = 1;

% são guardados somente valores diferentes de zero
for kk=1:sz
    if B(kk) == 1
        timeStamp(:,ncount) = x(1,kk);
        xpol(:,ncount) = x(5,kk);
        ypol(:,ncount) = x(6,kk);
        ncount=ncount+1;
    end
end
sz_xpol = size(xpol,2);
sz_kcs = size(kcs,2);

if (sz_xpol>1 && sz_xpol<sz_kcs)
    f_xy = zeros(2,sz_kcs);
    ncount = 1;
    flag = ismember(kcs,timeStamp);
    for ii = 1:sz_kcs
        if flag(ii) == 0
            % interpola os pontos faltantes dentro da janela temporal 
            x_ = interp1(timeStamp,xpol,kcs(ii),'linear','extrap');
            y_ = interp1(timeStamp,ypol,kcs(ii),'linear','extrap');
            % pontos interpolados
            f_xy(:,ii) = [x_;y_];
        else
            % pontos interpolados 
            f_xy(:,ii) = [xpol(1,ncount);ypol(1,ncount)];
            ncount = ncount+1;
        end
    end

else
    % pontos interpolados
    f_xy = [xpol;ypol];

end


%% Plots
if debug == 1

    sz_f_xy = size(f_xy,2);
    figure
    plot(f_xy(1,:),f_xy(2,:),'o',f_xy(1,:),f_xy(2,:),'-','LineWidth',3,'MarkerSize',10)
    set(groot,'defaultAxesTickLabelInterpreter','latex');
    xticklabels(strrep(xticklabels,'-','$-$'));
    yticklabels(strrep(yticklabels,'-','$-$'));
    hold on
    if sz_f_xy > 1
        for ii=1:sz_f_xy
            text(f_xy(1,ii),f_xy(2,ii),strcat('k=',num2str(kcs(ii))),'FontSize',14)
            hold on
        end
        x1=xline(f_xy(1,1),'-.','\bf K_{ini}','LineWidth',3,'FontSize',14);
        x1.LabelHorizontalAlignment = 'left';
        xline(f_xy(1,end),'-.','\bf K_{end}','LineWidth',3,'FontSize',14);
        %legend('Pontos da trajetória do centróide do alvo','Polinômio interpolante da trajetória')
        %title(['\fontsize{12} Trajetória do centróide do alvo ',num2str(p),' \fontsize{12} no plano da imagem (z=f)'],...
        %   ['\bf \fontsize{12} para a câmera ',num2str(n),'\bf \fontsize{12} dado em coordenadas globais {W}'])
        %title(['\fontsize{12} Centroid trajectory of target ',num2str(p),' \fontsize{12} on image plane (z=f)'],...
        %   ['\bf \fontsize{12} for camera ',num2str(n),'\bf \fontsize{12} in world coordinates'])
        legend('Target centroid trajectory','Interpolated trajectory','FontSize',12)
        xlabel('x(m)','Interpreter','latex','FontSize',14)
        ylabel('y(m)','Interpreter','latex','FontSize',14)
        grid on
        hold off
    else
        text(f_xy(1),f_xy(2),strcat('k=',num2str(timeStamp)),'FontSize',14)
        hold on
        x1=xline(f_xy(1,1),'-.','\bf K_{ini}','LineWidth',3,'FontSize',14);
        x1.LabelHorizontalAlignment = 'left';
        xline(f_xy(1,end),'-.','\bf K_{end}','LineWidth',3,'FontSize',14);
        %legend('Pontos da trajetória do centróide do alvo','Polinômio interpolante da trajetória')
        %title(['\fontsize{12} Trajetória do centróide do alvo ',num2str(p),' \fontsize{12} no plano da imagem (z=f)'],...
        %   ['\bf \fontsize{12} para a câmera ',num2str(n),'\bf \fontsize{12} dado em coordenadas globais {W}'])
        %title(['\fontsize{12} Centroid trajectory of target ',num2str(p),' \fontsize{12} on image plane (z=f)'],...
        %      ['\bf \fontsize{12} for camera ',num2str(n),'\bf \fontsize{12} in world coordinates'])
        legend('Target centroid trajectory','Interpolated trajectory','FontSize',12)
        xlabel('x(m)','Interpreter','latex','FontSize',14)
        ylabel('y(m)','Interpreter','latex','FontSize',14)
        xlim([min(f_xy(1,:))-1e-4 max(f_xy(1,:))+1e-4])
        ylim([min(f_xy(2,:))-1e-4 max(f_xy(2,:))+1e-4])
        grid on
        hold off
    end
    
end
