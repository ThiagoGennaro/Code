function [tracks,bufferLoS, sendCamera] = sendLoS( tracks, bufferLoS, sendCamera, LTicks_t, camera, k )

% momento de transmissão dado pela linha de relógio na função ClockCamerasGenerator
if (LTicks_t(camera,k) == 1)
    
    % número de alvos no k-ésimo instante
    PP = length(tracks);
    
    % para cada um dos p alvos
    for p = 1:PP
        % teste para verificar se o alvo está presente no k_e-ésimo
        % instante
        if ( tracks(p).bufferLoS(1,k) ~= 0 )
            % envio da LoS pertinente ao alvo no k_e-ésimo instante para as
            % j-ésimas câmeras vizinhas para p-ésimos alvos
            bufferLoS(:,p,camera,k) = tracks(p).bufferLoS(:,k);
        end
    end
    if PP~=0
        sendCamera{k} = [sendCamera{k} camera];
    end
end




