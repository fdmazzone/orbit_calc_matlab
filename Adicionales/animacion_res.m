function animacion_res(pos_rot,T_lot1,saltos1,saltos2,nro_cuerpo);



t=(T_lot1-T_lot1(1))/(365.25);


figure;
hold on



colores=rand(size(pos_rot,1),3);


for j=1:size(pos_rot,1)
    
    
    pos=squeeze(pos_rot(j,:,1:saltos1));
    eval(['h',num2str(j),'=plot3(pos(1,:),pos(2,:),pos(3,:),''Color'',colores(j,:),''Linewidth'',4);']);
    eval(['set(','h',num2str(j),',''Erase''',',''xor''',')'] );


    
end
set(gca,'Color','k')
pos_x=get(gca,'Xlim');
pos_y=get(gca,'Ylim');
etiqueta=sprintf('%5.1f  Años',t(1));
h0=text(-34,-34,etiqueta);
set(h0,'Erase','xor','Color','w');

hold off
axis([-35 35 -35 35])
axis square
view([0,90])
    
grid off

% indice_cuadro=1;
% nombrejpg=num2str(indice_cuadro);
% falta=5-length(nombrejpg);
% 
% nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
% eval(['print -djpeg ',nombrejpg]) ;
% indice_cuadro=indice_cuadro+1;
   

indice_cuadro=1;

%mov = avifile('animacion3.avi','compression','Cinepak');
for j=0:saltos2:size(T_lot1)-saltos2;
   drawnow
   
   
  for i=1:size(pos_rot,1)
       pos=squeeze(pos_rot(i,:,1+j:saltos1+j));
       eval(['set(h',num2str(i),',','''','XData','''',',pos(1,:),','''','YData','''',',pos(2,:),','''','Zdata','''',',pos(3,:))']);
   end
   etiqueta=sprintf('%5.1f  a',t(j+1));
   set(h0,'String',etiqueta);
   
   nombrejpg=num2str(indice_cuadro);
%    falta=5-length(nombrejpg);
%    
%    nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
    nombrejpg=['res-',nombrejpg,'.jpg'];
   eval(['print -djpeg ',nombrejpg]) ;
   indice_cuadro=indice_cuadro+1;
   
   
   %     F = getframe(gca);
%     mov = addframe(mov,F);
end

% mov = close(mov);
% movie2avi(M,'animacion.avi','compression','Cinepak');