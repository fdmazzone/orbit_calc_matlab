function [pos, posdot]=kepler2vector_m(M,peri,node,incli,e,n,a)
n=pi*n/(180);
cant_bod=length(a);
%%Matríz de rotaciones
R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];
% R=reshape(R',[3*length(a),3])';
E=solkepler1(M,e,1e-10);
pos=zeros(3,cant_bod);
posdot=pos;
pos(1:2,:)=[a'.*(cosd(E')-e');a'.*sqrt(1-e'.^2).*sind(E')];
posdot(1:2,:)=[-(n'.*a'.*sind(E'))./(1-e'.*cosd(E'));(n'.*a'.*sqrt(1-e'.^2).*cosd(E'))./(1-e'.*cosd(E'))];
% pos=reshape(pos,[3*length(a),1]);
% posdot=reshape(posdot,[3*length(a),1]);
for j=1:cant_bod
    R1=[R(j,:);R(j+cant_bod,:);R(j+2*cant_bod,:)];
    pos(:,j)=R1*pos(:,j);
    posdot(:,j)=R1*posdot(:,j);
end
