% function [segmin, PA]=motion(AR1,DE1,AR2,DE2)
% AR1 and DE1 initial position of a list of objects. Column vector
% AR2 y DE2,idem with final positions
% segmin = angular distance between the points in arc seg
% PA = angle between the difference of the positions and the north
% direction. 0<=PA<=360. East=Increasing PA 
function varargout=motion(AR1,DE1,AR2,DE2)
AR1=15*AR1;
AR2=15*AR2;
P=cat(2,cosd(AR1).*cosd(DE1),sind(AR1).*cosd(DE1),sind(DE1));
Q=cat(2,cosd(AR2).*cosd(DE2),sind(AR2).*cosd(DE2),sind(DE2));

cos_ang_dist=sum(P.*Q,2);
ang_dist=acosd(cos_ang_dist);
varargout{1}=ang_dist*3600;
if nargout>1
    B=Q-P;
    normPQ=(sum(B.^2,2)).^(-.5);
    T=cat(2,-cosd(AR1).*sind(DE1),-sind(AR1).*sind(DE1),cosd(DE1));
    PA=acosd(sum(B.*T,2).*normPQ);
    varargout{2}=(1-sign(AR2-AR1))*0.5*360+sign(AR2-AR1).*PA;
end