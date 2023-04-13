% function [los,points] = fusion3DPoints( los, target, cs, ce )
% Input - 
% los - vetor de medidas de cada um dos alvos
% target - medidas dos pontos, no espaço 3D, obtidos por comparação das
% linhas de visadas
% cs - início do ciclo da janela temporal
% ce - final do ciclo da janela temporal
% Output - 
% los - vetor de medidas de cada um dos alvos preenchido
% points - pontos no espaço 3D que foram obtidos pela fusão dos diferentes
% pontos encontrados em um mesmo instante k-ésimo dentro da janela temporal
%
function [ los,points,transf3Dto2D ] = fusion3DPoints( los, transf3Dto2D, target, extrinsec, intrinsec, cs, ce )

points=[];
ncount = 1;
for tw = cs:ce% tw: time window
    idx = find(target(1,:) == tw);
    if ~isempty( idx )
        points = [points mean(target(:,idx(1):idx(end)),2,'omitnan')];
        los(:,points(1,ncount)) = points(:,ncount);
        transf3Dto2D(:,points(1,ncount)) = camCoordToPixels(worldToCamCoord(los(2:4,points(1,ncount)), extrinsec.R, extrinsec.C_t), intrinsec );
        ncount = ncount + 1;
    end
end

 