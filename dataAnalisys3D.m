% tentativa de obter todas as medidas dentro da janela temporal levando-se
% em conta as medidas obtidas no espaço 3D, sabendo-se que o modelo
% aplicado para os alvos rastreados é admitido ter velocidade constante.


function [ measLoS, ...
           meas3Dto2D, ...
           y, ...
           Y, ...
           x, ...
           x3Dto2D, ...
           xx, ...
           xx3Dto2D,...
           pf, ...
           pf_x, ...
           pf_xx, ...
           pf_cov, ...
           pf_x3Dto2D, ... 
           pf_xx3Dto2D, ...
           fz ] = dataAnalisys3D( measLoS, ...
                                  meas3Dto2D,  ...
                                  extrinsec, ...
                                  intrinsec, ...
                                  cs, ce, k_e, ...
                                  Pinv, ...
                                  fz, ...
                                  y, ...
                                  Y, ...
                                  x, ...
                                  x3Dto2D, ...
                                  xx, ...
                                  xx3Dto2D, ...
                                  pf, ...
                                  pf_x, ...
                                  pf_xx, ...
                                  pf_cov, ...
                                  pf_x3Dto2D,...
                                  pf_xx3Dto2D )

ts = 0.143; %tempo de amostragem das câmeras em ms
vel = [1 0.8 0.001]'; % velocidade média de 1m/s
kcs = cs:ce; % todo período da janela temporal
sz_kcs = size(kcs,2);

idx = find(~isnan(measLoS(1,kcs)));% índices diferentes de NaN
idx_ = find(isnan(measLoS(1,kcs)));% índices iguais a NaN

sz_idx_ = size(idx_,2);% quantidade de NaNs
sz_idx = size(idx,2);% quantidade diferente de NaNs

ncount = 1;% início do contador 

if sz_idx == 1% se houver somente um ponto no vetor de medidas no espaço 3D

    % backward - medidas obtidas antes do primeiro valor obtido dentro da
    % janela temporal
    for b = 1:sz_idx_
    
        if (idx_(b) - idx(1) < 0 )
    
            backward = idx_(b) - idx(1);
            vt = vel*backward*ts;
            measLoS(:,kcs(ncount)) = [kcs(ncount);measLoS(2:4,kcs(idx(1))) + vt];
            meas3Dto2D(:,kcs(ncount)) = camCoordToPixels(worldToCamCoord(measLoS(2:4,kcs(ncount)), extrinsec.R, extrinsec.C_t), intrinsec );
            ncount=ncount+1;
    
        end
    
    end
    
    % foward - medidas obtidas após o primeiro valor obtido dentro da janela
    % temporal
    for f = kcs(idx(1)):ce
        
        if (isnan(measLoS(1,f)))
            
            foward = 1;
            vt = vel*foward*ts;
            measLoS(:,kcs(ncount)) = [kcs(ncount);measLoS(2:4,kcs(ncount)-1) + vt];
            meas3Dto2D(:,kcs(ncount)) = camCoordToPixels(worldToCamCoord(measLoS(2:4,kcs(ncount)), extrinsec.R, extrinsec.C_t), intrinsec );
        end
        
         ncount = ncount+1;
        
    end

elseif sz_idx > 1% se houver mais de um ponto no espaço 3D
    
    flag = ismember(kcs,measLoS(1,kcs));
    flag_nan = nnz(~isnan(measLoS(1,kcs)));
    aux_measLoS = zeros(3,flag_nan);
    aux_kcs = zeros(1,flag_nan);
    nncount = 1;
    for iidx = 1:sz_kcs
        if flag(iidx) == 1
            aux_measLoS(:,nncount) = measLoS(2:4,kcs(iidx));
            aux_kcs(:,nncount) = kcs(:,iidx);
            nncount = nncount+1;
        end
    end

    for zz = 1:sz_kcs
        
        if flag(zz) == 0
            % pontos interpolados
            x_ = interp1(aux_kcs,aux_measLoS(1,:),kcs(zz),'linear','extrap');
            y_ = interp1(aux_kcs,aux_measLoS(2,:),kcs(zz),'linear','extrap');
            z_ = interp1(aux_kcs,aux_measLoS(3,:),kcs(zz),'linear','extrap');
            measLoS(:,kcs(zz)) = [ kcs(zz);x_;y_;z_ ];
        end

    end

end

if fz == 0
    %% inicialização do filtro BAF-2
    y(:,k_e) = Pinv*[measLoS(2:4,k_e); 0; 0; 0];
    Y(:,:,k_e) = Pinv;
    x(:,k_e) = Y(:,:,k_e)\y(:,k_e);
    x3Dto2D(:,k_e) = camCoordToPixels(worldToCamCoord(x(1:3,k_e), extrinsec.R, extrinsec.C_t), intrinsec );
    xx(:,k_e) = x(:,k_e);
    xx3Dto2D(:,k_e) = camCoordToPixels(worldToCamCoord(xx(1:3,k_e), extrinsec.R, extrinsec.C_t), intrinsec );


    %% inicialização do filtro de Partículas
    pf = stateEstimatorPF;
    pf.StateEstimationMethod = 'mean';
    pf.ResamplingMethod = 'systematic';

    % StateTransitionFcn defines how particles evolve without measurement
    pf.StateTransitionFcn = @trackPeopleStateTransition;

    % MeasurementLikelihoodFcn defines how measurement affect the our estimation
    pf.MeasurementLikelihoodFcn = @trackPeopleMeasurementLikelihood;

    % Sample 500 particles with an initial position and unit covariance
    % for position and 0.1 for velocity
    initialize(pf,500,[measLoS(2:4,k_e);0;0;0],diag([1 1 1 0.1 0.1 0.001]));
    pf_x(:,k_e) = pf.State;
    pf_x3Dto2D(:,k_e) = camCoordToPixels(worldToCamCoord(pf_x(1:3,k_e), extrinsec.R, extrinsec.C_t), intrinsec );
    pf_xx(:,k_e) = pf_x(:,k_e);
    pf_xx3Dto2D(:,k_e) = camCoordToPixels(worldToCamCoord(pf_xx(1:3,k_e), extrinsec.R, extrinsec.C_t), intrinsec );
    pf_cov(:,:,k_e) = pf.StateCovariance;

    % flag indicando que o alvo foi inicializado
    fz = 1;

end










