function [pos, posdot]=kepler2vector(M,peri,node,incli,e,n,a)
n=pi*n/(180);
%%Matríz de rotaciones
R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];
E=solkepler1(M,e,1e-13);
pos=[a.*(cosd(E)-e);a.*sqrt(1-e.^2).*sind(E);0];
posdot=[-(n.*a.*sind(E))./(1-e.*cosd(E));(n.*a.*sqrt(1-e.^2).*cosd(E))./(1-e.*cosd(E));0];
pos=R*pos;
posdot=R*posdot;