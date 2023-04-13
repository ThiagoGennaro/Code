% function pts3D = comparisionTargetLoS(psA,psB)
%
% Input-:
% psA: "sigma points" da i-ésima câmera para o t-ésimo alvo
% psB: "sigma points" da j-ésima câmera para o t-ésimo alvo
%
% Output-:
% pts3D: pontos obtidos no espaço 3D dados em coordenadas globais

function [ pts3D,flag ] = comparisionTargetLoS( psA,psB)

%% 49 comparações entre os cones de linhas de visadas (7 linhas de visadas por cone)

% alocação de memória
nz = 3;% ponto no3D 
sz_psA = size(psA,2);
sz_psB = size(psB,2);
pts3D = NaN(nz,sz_psA*sz_psB);
flag = 'notsaveMeas';

% contador de armazenamento
ncount = 1;

% para cada linha de visada dentro do cone de linhas de visada da
% i-ésima câmera (7 pontos de linhas de visada)
for is = 1:sz_psA 

    % para cada linha de visada dentro do cone de linhas de visada da
    % j-ésima câmera vizinha (7 pontos de linhas de visada)
    for is_ = 1:sz_psB

        % teste de comparação entre os alvos e obtenção da medida z
        [ Pz,Qz,dz ] = reversalLOSAndDistanceMinimization( psA(1:3,is), psA(4:6,is), psB(1:3,is_), psB(4:6,is_) );

        % testa se a medida obtida é z>0 e z<1.5m
        if ( Pz(3)>0 && Qz(3)>0 && Pz(3)<1.5 && Qz(3)<1.5 )

            % tolerância máxima de distância entre as linhas de visada
            if dz<=0.5
                pts3D(:,ncount) = Pz;
                ncount = ncount + 1;
                if ncount<=2
                    flag = 'saveMeas';
                end
            end 
        end
    end
end

