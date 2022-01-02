function animacion_2010TK7(pos_rot,T_lot1,intervalo,saltos,colores);
%saltos=12*3;
%intervalo=size(pos_helio,3);
% cuerpo=squeeze(pos_rot(nro_cuerpo,:,intervalo));
%  tierra=squeeze(pos_rot(4,:,intervalo));
%  T_lot1=T_lot1(intervalo);
%   [theta,psi,r]=cart2sph(cuerpo(1,:),cuerpo(2,:),cuerpo(3,:));
% I=find(theta<0);
% theta(I)=2*pi+theta(I);
% theta=180*theta/pi;
% 
% [aa mm dd]=jul2gre(T_lot1);
% T=aa+mm/12+dd/365.25;

%plot(T,theta);

t=(T_lot1-2011)/(1000);

%colores=rand(size(pos_rot,1),3);
figure;
hold on




for j=12:size(pos_rot,1)
    
    
    pos=squeeze(pos_rot(j,:,1:12));
    eval(['h',num2str(j),'=plot3(pos(1,:),pos(2,:),pos(3,:),''Color'',colores(j,:));']);
    eval(['set(','h',num2str(j),',''Erase''',',''xor''',')'] );


    
end


%h = plot3(squeeze(pos_rot(nro_cuerpo,1,1:12)),squeeze(pos_rot(nro_cuerpo,2,1:12)),squeeze(pos_rot(nro_cuerpo,3,1:12)),'Color','g');
%set(gca,'Color','k');
%h1=plot3(cuerpo(1,60),cuerpo(2,60),cuerpo(3,60),'.','MarkerSize',15,'Color','g');
h2=plot3(0,0,0,'.','MarkerSize',30,'Color','y');
h1=plot3(pos_rot(4,1,12),pos_rot(4,2,12),pos_rot(4,3,12),'.','MarkerSize',20,'Color','b');
pos_x=get(gca,'Xlim');
pos_y=get(gca,'Ylim');
etiqueta=sprintf('%4.1f  Ky',t(1));
h3=text(-1.4,-1.4,etiqueta);
set(h3,'Erase','xor');

hold off
axis([-1.5 1.5 -1.5 1.5])
axis square
view([0,90])
    
grid off

set(h1,'EraseMode','xor')

indice_cuadro=1;
nombrejpg=num2str(indice_cuadro);
falta=5-length(nombrejpg);

nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
eval(['print -djpeg ',nombrejpg]) ;
indice_cuadro=indice_cuadro+1;
   



%mov = avifile('animacion3.avi','compression','Cinepak');
for j=intervalo(1):saltos:(intervalo(end)-12);
   drawnow
   
   
   
   for i=12:size(pos_rot,1)
       pos=squeeze(pos_rot(i,:,1+j:12+j));
       eval(['set(h',num2str(i),',','''','XData','''',',pos(1,:),','''','YData','''',',pos(2,:),','''','Zdata','''',',pos(3,:))']);
   end
  % set(h,'XData',squeeze(pos_rot(nro_cuerpo,1,1+j:12+j)),'YData',squeeze(pos_rot(nro_cuerpo,2,1+j:12+j)),'ZData',squeeze(pos_rot(nro_cuerpo,3,1+j:12+j)));
   set(h1,'XData',squeeze(pos_rot(4,1,12+j)),'YData',squeeze(pos_rot(4,2,12+j)),'ZData',squeeze(pos_rot(4,3,12+j)));
   etiqueta=sprintf('%4.1f  Ky',t(j));
   set(h3,'String',etiqueta);
   
   nombrejpg=num2str(indice_cuadro);
   falta=5-length(nombrejpg);
   
   nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
   eval(['print -djpeg ',nombrejpg]) ;
   indice_cuadro=indice_cuadro+1;
   
   
   %     F = getframe(gca);
%     mov = addframe(mov,F);
end

% mov = close(mov);
% movie2avi(M,'animacion.avi','compression','Cinepak');