% Cuerpo = Vector Posicion Velocidad
function Pos=GrafOrb(Cuerpo)
GM=sistema(0);
GM=GM(1);
[a, e, incli, node, peri, M,n]=vector2kepler(Cuerpo,GM);
M=0:360;
tol=1E-4;
E=solkepler1(M',repmat(e(1),size(M')),tol);
f_cuerpo=2*atand(sqrt((1+e(1))/(1-e(1)))*tand(E/2));
r=a(1)*(1-e(1).^2)./(1+e(1)*cosd(f_cuerpo));
R=transf_esp(node(1),peri(1),incli(1));
Pos=R*[r'.*cosd(f_cuerpo'+peri(1));r'.*sind(f_cuerpo'+peri(1));zeros(size(r'))];
xmin=-5.5;%5/2*min(Pos(1,:));
xmax=5.5;%5/2*max(Pos(1,:));
ymin=-5.5;%5/2*min(Pos(2,:));
ymax=5.5;%5/2*max(Pos(2,:));
h1=(xmax-xmin)/100;
h2=(ymax-ymin)/100;

[X,Y]=meshgrid(xmin:h1:xmax,ymin:h2:ymax);
Z=zeros(size(X));
plot3(Pos(1,:),Pos(2,:),Pos(3,:))

set(gca,'DataAspectRatio',[1,1,1]);
hold on
plot3([0,Pos(1,:)],[0,Pos(2,:)],[0,Pos(3,:)]);
Ecli=mesh(X,Y,Z);
set(Ecli,'EdgeAlpha',0.5,'FaceAlpha',0.5);




function R=transf_esp(node,peri,incli)


R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];


