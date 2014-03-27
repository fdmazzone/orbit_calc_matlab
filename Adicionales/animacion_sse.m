function animacion_sse
GM1=sistema(0);
Anio_ini=2011;
load('00001.mat');
Theta=0:3:360;
[a_jup, e_jup, incli_jup, node_jup, peri_jup]=vector2kepler([pos(:,1:3),vel(:,1:3)],GM1(1));
[a_sat, e_sat, incli_sat, node_sat, peri_sat]=vector2kepler([pos(:,4:6),vel(:,4:6)],GM1(1));
[a_ura, e_ura, incli_ura, node_ura, peri_ura]=vector2kepler([pos(:,7:9),vel(:,7:9)],GM1(1));
[a_nep, e_nep, incli_nep, node_nep, peri_nep]=vector2kepler([pos(:,10:12),vel(:,10:12)],GM1(1));
[a_plu, e_plu, incli_plu, node_plu, peri_plu]=vector2kepler([pos(:,13:15),vel(:,13:15)],GM1(1));


figure;hold on
set(gca,'Color','k');
%%%Jupiter
r=a_jup(1)*(1-e_jup(1).^2)./(1+e_jup(1)*cosd(Theta-peri_jup(1)));
R=transf_esp(node_jup(1),peri_jup(1),incli_jup(1));
PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
h_jup=plot3(PosEsp(1,:),PosEsp(2,:),PosEsp(3,:),'LineWidth',2,'Color','b');
%%%Saturno
r=a_sat(1)*(1-e_sat(1).^2)./(1+e_sat(1)*cosd(Theta-peri_sat(1)));
R=transf_esp(node_sat(1),peri_sat(1),incli_sat(1));
PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
h_sat=plot3(PosEsp(1,:),PosEsp(2,:),PosEsp(3,:),'LineWidth',2,'Color','r');
%%%Urano
r=a_ura(1)*(1-e_ura(1).^2)./(1+e_ura(1)*cosd(Theta-peri_ura(1)));
R=transf_esp(node_ura(1),peri_ura(1),incli_ura(1));
PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
h_ura=plot3(PosEsp(1,:),PosEsp(2,:),PosEsp(3,:),'LineWidth',2,'Color','g');
%%%Neptuno
r=a_nep(1)*(1-e_nep(1).^2)./(1+e_nep(1)*cosd(Theta-peri_nep(1)));
R=transf_esp(node_nep(1),peri_nep(1),incli_nep(1));
PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
h_nep=plot3(PosEsp(1,:),PosEsp(2,:),PosEsp(3,:),'LineWidth',2,'Color','c');
%%Pluton
r=a_plu(1)*(1-e_plu(1).^2)./(1+e_plu(1)*cosd(Theta-peri_plu(1)));
R=transf_esp(node_plu(1),peri_plu(1),incli_plu(1));
PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
h_plu=plot3(PosEsp(1,:),PosEsp(2,:),PosEsp(3,:),'LineWidth',2,'Color','m');

Anio=jul2gre(epocas(1));
Etiqueta=sprintf('%5.2f MegaAños',(Anio-Anio_ini)/1e6);
Htext=text(-53,-53,Etiqueta,'Color','w');


set(h_jup,'Erase','xor');
set(h_sat,'Erase','xor');
set(h_ura,'Erase','xor');
set(h_nep,'Erase','xor');
set(h_plu,'Erase','xor');
set(Htext,'Erase','xor');

axis([-55 55 -55 55])
plot3(0,0,0,'.','MarkerSize',15,'Color','y')
axis square
view([0,90])
grid off
set(gca,'DataAspectRatio',[1,1,.05]);
hold off

IndiceFrame=1;

for k=1:156
    nombre=num2str(k);
    falta=5-length(nombre);
    nombre=[repmat('0',[1,falta]),nombre,'.mat'];
    load(nombre);
    Anio=jul2gre(epocas);
    clear epoca;
    [a_jup, e_jup, incli_jup, node_jup, peri_jup]=vector2kepler([pos(:,1:3),vel(:,1:3)],GM1(1));
    [a_sat, e_sat, incli_sat, node_sat, peri_sat]=vector2kepler([pos(:,4:6),vel(:,4:6)],GM1(1));
    [a_ura, e_ura, incli_ura, node_ura, peri_ura]=vector2kepler([pos(:,7:9),vel(:,7:9)],GM1(1));
    [a_nep, e_nep, incli_nep, node_nep, peri_nep]=vector2kepler([pos(:,10:12),vel(:,10:12)],GM1(1));
    [a_plu, e_plu, incli_plu, node_plu, peri_plu]=vector2kepler([pos(:,13:15),vel(:,13:15)],GM1(1));
    clear pos vel;
    for j=1:500:length(a_jup)
        drawnow
        %%jupiter
        r=a_jup(j)*(1-e_jup(j).^2)./(1+e_jup(j)*cosd(Theta-peri_jup(j)));
        R=transf_esp(node_jup(j),peri_jup(j),incli_jup(j));
        PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
        set(h_jup,'XData',PosEsp(1,:),'YData',PosEsp(2,:),'ZData',PosEsp(3,:));
        %%saturno
        r=a_sat(j)*(1-e_sat(j).^2)./(1+e_sat(j)*cosd(Theta-peri_sat(j)));
        R=transf_esp(node_sat(j),peri_sat(j),incli_sat(j));
        PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
        set(h_sat,'XData',PosEsp(1,:),'YData',PosEsp(2,:),'ZData',PosEsp(3,:));
        %%Urano
        r=a_ura(j)*(1-e_ura(j).^2)./(1+e_ura(j)*cosd(Theta-peri_ura(j)));
        R=transf_esp(node_ura(j),peri_ura(j),incli_ura(j));
        PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
        set(h_ura,'XData',PosEsp(1,:),'YData',PosEsp(2,:),'ZData',PosEsp(3,:));
        %%Neptuno
        r=a_nep(j)*(1-e_nep(j).^2)./(1+e_nep(j)*cosd(Theta-peri_nep(j)));
        R=transf_esp(node_nep(j),peri_nep(j),incli_nep(j));
        PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
        set(h_nep,'XData',PosEsp(1,:),'YData',PosEsp(2,:),'ZData',PosEsp(3,:));
        %%Pluton
        r=a_plu(j)*(1-e_plu(j).^2)./(1+e_plu(j)*cosd(Theta-peri_plu(j)));
        R=transf_esp(node_plu(j),peri_plu(j),incli_plu(j));
        PosEsp=R*[r.*cosd(Theta);r.*sind(Theta);zeros(size(r))];
        set(h_plu,'XData',PosEsp(1,:),'YData',PosEsp(2,:),'ZData',PosEsp(3,:));
        
        Etiqueta=sprintf('%5.2f MegaAños',(Anio(j)-Anio_ini)/1e6);
        set(Htext,'String',Etiqueta);
        
        nombrejpg=num2str(IndiceFrame);
        falta=5-length(num2str(IndiceFrame));
        
        nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
        eval(['print -djpeg ',nombrejpg]) ;
%         M(IndiceFrame) = getframe;
        IndiceFrame=IndiceFrame+1;
   
        
    end

end
%  movie(M,1,100);
% movie2avi(M,'SSE15MA.avi','compression','Cinepak');
function R=transf_esp(node,peri,incli)


R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];

