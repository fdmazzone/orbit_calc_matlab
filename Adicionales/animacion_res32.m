function animacion_res32(IndCuerpo)
GM=sistema(0);
GM=GM(1,1);
Lapso=(0:2:365.25*2);

load('00300.mat');
[aaaa, ~, ~]=jul2gre(epocas(1));
Anio_ini=aaaa;
Cuerpo=squeeze(pos_helio(IndCuerpo,:,1));
VCuerpo=squeeze(vel_helio(IndCuerpo,:,1));
Tierra=squeeze(pos_helio(4,:,1));
VTierra=squeeze(vel_helio(4,:,1));
% Venus=squeeze(pos_helio(3,:,1));
% VVenus=squeeze(vel_helio(3,:,1));


[a, e, incli, node, peri,M,n]=vector2kepler([Cuerpo,VCuerpo],GM);
[a_tie, e_tie, incli_tie, node_tie, peri_tie, M_tie,n_tie]=vector2kepler([Tierra,VTierra],GM);
% [a_ven, e_ven, incli_ven, node_ven, peri_ven, M_ven,n_ven]=vector2kepler([Venus,VVenus],GM);


tol=1E-4;
M=M+Lapso*n*180/(pi*365.25);
M_tie=M_tie+Lapso*n_tie*180/(pi*365.25);
% M_ven=M_ven+Lapso*n_ven*180/(pi*365.25);
E=solkepler1(M',repmat(e,size(M')),tol);
E_tie=solkepler1(M_tie',repmat(e_tie,size(M_tie')),tol);
% E_ven=solkepler1(M_ven',repmat(e_ven,size(M_ven')),tol);

f_cuerpo=2*atand(sqrt((1+e)/(1-e))*tand(E/2));
f_tie=2*atand(sqrt((1+e_tie)/(1-e_tie))*tand(E_tie/2));
% f_ven=2*atand(sqrt((1+e_ven)/(1-e_ven))*tand(E_ven/2));

figure;hold on
set(gca,'Color','k');
%%%Posicion Cuerpo
r=a*(1-e.^2)./(1+e*cosd(f_cuerpo));
R=transf_esp(node,peri,incli);
PosEspCuerpo=R*[r'.*cosd(f_cuerpo'+peri);r'.*sind(f_cuerpo'+peri);zeros(size(r'))];


%%%Posicion Tierra
r=a_tie*(1-e_tie.^2)./(1+e_tie*cosd(f_tie));
R=transf_esp(node_tie,peri_tie,incli_tie);
PosEspTierra=R*[r'.*cosd(f_tie'+peri_tie);r'.*sind(f_tie'+peri_tie);zeros(size(r'))];


% r=a_ven*(1-e_ven.^2)./(1+e_ven*cosd(f_ven));
% R=transf_esp(node_ven,peri_ven,incli_ven);
% PosEspVenus=R*[r'.*cosd(f_ven'+peri_ven);r'.*sind(f_ven'+peri_ven);zeros(size(r'))];


% rotados=cat(3,PosEspTierra,PosEspCuerpo,PosEspVenus);
rotados=cat(3,PosEspTierra,PosEspCuerpo);
rotados=permute(rotados,[3,1,2]);
rotados=givens(rotados,1);


PosEsp=squeeze(rotados(2,:,:));
PosEspTie=squeeze(rotados(1,:,:));
%PosEspVen=squeeze(rotados(3,:,:));
h_cuerpo=plot3(PosEsp(1,:),PosEsp(2,:),PosEsp(3,:),'LineWidth',2,'Color','b');
%%%Saturno

h_tie=plot3(PosEspTie(1,:),PosEspTie(2,:),PosEspTie(3,:),'.','MarkerSize',20,'Color','r');
%h_venus=plot3(PosEspVen(1,:),PosEspVen(2,:),PosEspVen(3,:),'LineWidth',2,'Color','g');

Anio=jul2gre(epocas(1));
Etiqueta=sprintf('%10.2f Años',(Anio-Anio_ini));
Htext=text(-1.7,-1.7,Etiqueta,'Color','w');


set(h_cuerpo,'Erase','xor');
set(h_tie,'Erase','xor');
%set(h_venus,'Erase','xor');


axis([-2 2 -2 2])
plot3(0,0,0,'.','MarkerSize',15,'Color','y')
axis square
view([0,90])
grid off
%set(gca,'DataAspectRatio',[1,1,.05]);
hold off

IndiceFrame=1;

for k=300:400
    nombre=num2str(k);
    falta=5-length(nombre);
    nombre=[repmat('0',[1,falta]),nombre,'.mat'];
    load(nombre);
    Anio=jul2gre(epocas);
    clear epoca;
    Cuerpo=squeeze(pos_helio(IndCuerpo,:,:));
    VCuerpo=squeeze(vel_helio(IndCuerpo,:,:));
    Tierra=squeeze(pos_helio(4,:,:));
    VTierra=squeeze(vel_helio(4,:,:));
 %   Venus=squeeze(pos_helio(3,:,:));
  %  VVenus=squeeze(vel_helio(3,:,:));
    
    [a, e, incli, node, peri,M,n]=vector2kepler([Cuerpo',VCuerpo'],GM);
    [a_tie, e_tie, incli_tie, node_tie, peri_tie, M_tie,n_tie]=vector2kepler([Tierra',VTierra'],GM);
    
   % [a_ven, e_ven, incli_ven, node_ven, peri_ven, M_ven,n_ven]=vector2kepler([Venus',VVenus'],GM);

    


    
    
    
    for j=1:10:length(a)
        drawnow
        %%cuerpo
        
        M_cuerpo=M(j)+Lapso*n(j)*180/(pi*365.25);
        M_tie_trans=M_tie(j)+Lapso*n_tie(j)*180/(pi*365.25);
    %    M_ven_trans=M_ven(j)+Lapso*n_ven(j)*180/(pi*365.25);
        E=solkepler1(M_cuerpo',repmat(e(j),size(M_cuerpo')),tol);
        E_tie=solkepler1(M_tie_trans',repmat(e_tie(j),size(M_tie_trans')),tol);
     %   E_ven=solkepler1(M_ven_trans',repmat(e_ven(j),size(M_ven_trans')),tol);
        
        f_cuerpo=2*atand(sqrt((1+e(j))/(1-e(j)))*tand(E/2));
        f_tie=2*atand(sqrt((1+e_tie(j))/(1-e_tie(j)))*tand(E_tie/2));
      %   f_ven=2*atand(sqrt((1+e_ven(j))/(1-e_ven(j)))*tand(E_ven/2));
       r=a(j)*(1-e(j).^2)./(1+e(j)*cosd(f_cuerpo));
       R=transf_esp(node(j),peri(j),incli(j));
       PosEspCuerpo=R*[r'.*cosd(f_cuerpo'+peri(j));r'.*sind(f_cuerpo'+peri(j));zeros(size(r'))];
       
       
       %%%Posicion Tierra
       r=a_tie(j)*(1-e_tie(j).^2)./(1+e_tie(j)*cosd(f_tie));
       R=transf_esp(node_tie(j),peri_tie(j),incli_tie(j));
       PosEspTierra=R*[r'.*cosd(f_tie'+peri_tie(j));r'.*sind(f_tie'+peri_tie(j));zeros(size(r'))];
       
       %r=a_ven(j)*(1-e_ven(j).^2)./(1+e_ven(j)*cosd(f_ven));
       %R=transf_esp(node_ven(j),peri_ven(j),incli_ven(j));
       %PosEspVenus=R*[r'.*cosd(f_ven'+peri_ven(j));r'.*sind(f_ven'+peri_ven(j));zeros(size(r'))];
       
       
       
       
       
%        rotados=cat(3,PosEspTierra,PosEspCuerpo,PosEspVenus);
        rotados=cat(3,PosEspTierra,PosEspCuerpo);
       rotados=permute(rotados,[3,1,2]);
       rotados=givens(rotados,1);
       
       
       PosEsp=squeeze(rotados(2,:,:));
       PosEspTie=squeeze(rotados(1,:,:));
       set(h_cuerpo,'XData',PosEsp(1,:),'YData',PosEsp(2,:),'ZData',PosEsp(3,:));
       set(h_tie,'XData',PosEspTie(1,:),'YData',PosEspTie(2,:),'ZData',PosEspTie(3,:));
       %set(h_venus,'XData',PosEspVen(1,:),'YData',PosEspVen(2,:),'ZData',PosEspVen(3,:));
       
       Etiqueta=sprintf('%10.2f Años',(Anio(j)-Anio_ini));
       set(Htext,'String',Etiqueta);
%         
%         nombrejpg=num2str(IndiceFrame);
%         falta=5-length(num2str(IndiceFrame));
%         
%         nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
%         eval(['print -djpeg ',nombrejpg]) ;
% %         M(IndiceFrame) = getframe;
%         IndiceFrame=IndiceFrame+1;
   
        
    end

end
%  movie(M,1,100);
% movie2avi(M,'SSE15MA.avi','compression','Cinepak');
function R=transf_esp(node,peri,incli)


R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];

