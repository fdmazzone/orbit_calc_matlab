function animacion_res_32(a, e, incli, node, peri,epocas,M,PosTierra)
GM1=sistema(0);
Anio_ini=2011;
Theta=0:3:720;

[ThetaTierra,~] = cart2pol(PosTierra(1,:),PosTierra(2,:))

Theta=0:3:720-e*sind(0:3:720);

figure;hold on
set(gca,'Color','k');
%%%Jupiter
r=a(1)*(1-e(1).^2)./(1+e(1)*cosd(Theta-peri(1)));
R=transf_esp(node(1),peri(1),incli(1));




PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
PosEspTrans(2,:,1)=PosTierra(1,:,1);

PosEsp=givens(PosEspTrans,2);
PosEsp=squeeze(PosEsp(1,:));

h=plot3(PosEsp(1,:),PosEsp(2,:),PosEsp(3,:),'LineWidth',2,'Color','b');


Anio=jul2gre(epocas(1));
Etiqueta=sprintf('%5.2f Años',Anio);
Htext=text(-53,-53,Etiqueta,'Color','w');


set(h,'Erase','xor');


axis([-2 2 -2 2 -2 2])
plot3(0,0,0,'.','MarkerSize',15,'Color','y')
axis square
view([0,90])
grid off
%set(gca,'DataAspectRatio',[1,1,.05]);
hold off

%IndiceFrame=1;

    for j=1:length(a)
        drawnow
        r=a(j)*(1-e(j).^2)./(1+e(j)*cosd(Theta-peri(j)));
        R=transf_esp(node(j),peri(j),incli(j));
        PosEspTrans(1,:,:)=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
        PosEspTrans(2,:,:)=PosTierra(1,:,j);

        PosEsp=givens(PosEspTrans,2);
        PosEsp=squeeze(PosEsp(1,:));
        
        
        
        
        
        set(h_jup,'XData',PosEsp(1,:),'YData',PosEsp(2,:),'ZData',PosEsp(3,:));
        
        
        Etiqueta=sprintf('%5.2f Años',Anio(j));
        set(Htext,'String',Etiqueta);
        
%         nombrejpg=num2str(IndiceFrame);
%         falta=5-length(num2str(IndiceFrame));
%         
%         nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
%         eval(['print -djpeg ',nombrejpg]) ;
% %         M(IndiceFrame) = getframe;
%         IndiceFrame=IndiceFrame+1;
   
        


end
%  movie(M,1,100);
% movie2avi(M,'SSE15MA.avi','compression','Cinepak');
function R=transf_esp(node,peri,incli)


R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];

function R=transf_esp(node,peri,incli)


R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];
function PosRot=rotacion(pos,angulos)
PosRot(1,:)=cosd(angulos).*pos(1,:)+sind(angulos).*pos(2,:);
PosRot(2,:)=cosd(angulos).*pos(2,:)-sind(angulos).*pos(1,:);
