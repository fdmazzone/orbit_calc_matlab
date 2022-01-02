%%Calcula la distancia orbital mínima entre dos órbitas. Los argumentos son
%%el semiejemayor a, excentricidad e, longitud nodo ascendente node y
%%argmento del perihelio peri. Esto tanto del cuerpo como del planeta
%%principal. Las del planeta tienen sufijo _tie.

function moid(a, e, incli, node, peri,a_tie, e_tie, incli_tie, node_tie, peri_tie)
GM=sistema(0);
GM=GM(1,1);

global Parametros

Parametros=[a, e, incli, node, peri;...
           a_tie, e_tie, incli_tie, node_tie, peri_tie];

M=[0:359];       

% tol=1E-10;
% E=solkepler1(M',repmat(e,size(M')),tol);
% E_tie=solkepler1(M',repmat(e_tie,size(M')),tol);


Dist=DistCuerpos([M;M]);

E=2*atand( sqrt((1-Parametros(1,2))/(1+Parametros(1,2))).*tand(M(1,:)/2 ));
E_tie=2*atand( sqrt((1-Parametros(2,2))/(1+Parametros(2,2))).*tand(M(1,:)/2) );

E=E-floor(E/360)*360;
E_tie=E_tie-floor(E_tie/360)*360;


% M(1,:)=2*atand(sqrt((1+Parametros(1,2))/(1-Parametros(1,2)))*tand(M(1,:)/2));
% M(2,:)=2*atand(sqrt((1+Parametros(2,2))/(1-Parametros(2,2)))*tand(M(2,:)/2));


[X,Y]=meshgrid(E_tie',E');

subplot(2,1,1);mesh(Y,X,Dist);
axis([0 360 0 360]);
set(gca,'DataAspectRatio',[1,1,1]);

subplot(2,1,2);contour(Y,X,Dist);hold on
axis([0 360 0 360]);
set(gca,'DataAspectRatio',[1,1,1]);

[X,Y]=meshgrid(M(1,:),M(1,:));

MinVal=min(min(Dist));
I=find(Dist==MinVal);
Val(1,:)=X(I(1));
Val(2,:)=Y(I(1));

rf2 = @DistCuerpos; % objective
x0 = Val; % start point away from the minimum
problem = createOptimProblem('fmincon','objective',rf2,...
    'x0',x0);
gs = GlobalSearch;
[MOID ValMOID] = run(gs,problem);



%[MOID ValMOID flf of] = patternsearch(@DistCuerpos,Val);

E=2*atand( sqrt((1-Parametros(1,2))/(1+Parametros(1,2))).*tand(MOID(1)/2) );
E_tie=2*atand( sqrt((1-Parametros(2,2))/(1+Parametros(2,2))).*tand(MOID(2)/2) );


if E<0
    E=E+360;
end
if E_tie<0
    E_tie=E_tie+360;
end
ValMOID=DistCuerpos(MOID);

subplot(2,1,2); plot3(E,E_tie,100,'.','MarkerSize',20,'Color','k');hold off;


MOID=MOID-floor(MOID/360)*360;
texto=sprintf('MOID=%6.4f',ValMOID);

texto2=sprintf('Anomalías Exéntricas T-O=%6.4f - %6.4f ',[E,E_tie]);
disp(texto)
disp(texto2)


function Dist=DistCuerpos(M);

global Parametros




r=Parametros(1,1)*(1-Parametros(1,2).^2)./(1+Parametros(1,2)*cosd(M(1,:)));
R=transf_esp(Parametros(1,4),Parametros(1,5),Parametros(1,3));
PosEspCuerpo=R*[r.*cosd(M(1,:));r.*sind(M(1,:));zeros(size(r))];


%%%Posicion Tierra
r=Parametros(2,1)*(1-Parametros(2,2).^2)./(1+Parametros(2,2)*cosd(M(2,:)));
R=transf_esp(Parametros(2,4),Parametros(2,5),Parametros(2,3));
PosEspTierra=R*[r.*cosd(M(2,:));r.*sind(M(2,:));zeros(size(r))];


PosEspCuerpo=repmat(PosEspCuerpo,[1,1,size(PosEspCuerpo,2)]);
PosEspTierra=repmat(PosEspTierra,[size(PosEspCuerpo,2),1]);

PosEspTierra=reshape(PosEspTierra,[3,size(PosEspCuerpo,2),size(PosEspCuerpo,2)]);
PosRel=PosEspCuerpo-PosEspTierra;
Dist=squeeze(sqrt(sum(PosRel.^2,1)));




function R=transf_esp(node,peri,incli)
R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];
