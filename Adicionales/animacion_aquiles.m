function animacion_aquiles(pos_rot,t);

t=(t-t(1))/365;
posA=squeeze(pos_rot(2,:,:));
figure;
hold on
pos=squeeze(pos_rot(:,:,1));
plot3(posA(1,:),posA(2,:),posA(3,:))

h=plot3(pos(:,1),pos(:,2),pos(:,3),'.','MarkerSize',20,'color','r');
set(h,'Erase','xor');

etiqueta=[sprintf('%3.0f ',t(1)),'A\~nos'];
h3=text(-5,-5,etiqueta,'Interpreter','latex','FontUnits','points','FontSize',24);
set(h3,'Erase','xor');


axis([-6 6 -6 6])
plot3(0,0,0,'.','MarkerSize',30,'Color','y')

axis square
view([0,90])
grid off
hold off
indice_cuadro=1;
nombrejpg=num2str(indice_cuadro);
falta=5-length(nombrejpg);

nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
eval(['print -djpeg ',nombrejpg]) ;
indice_cuadro=indice_cuadro+1;


for j=1:size(pos_rot,3);
   drawnow
   pos=squeeze(pos_rot(:,:,j));
   
   set(h,'XData',pos(:,1),'YData',pos(:,2),'Zdata',pos(:,3));
   
   etiqueta=[sprintf('%3.0f ',t(j)),'A\~nos'];
   set(h3,'String',etiqueta,'Interpreter','latex','FontUnits','points','FontSize',24);

    
   nombrejpg=num2str(indice_cuadro);
   falta=5-length(nombrejpg);
   
   nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
   eval(['print -djpeg ',nombrejpg]) ;
   indice_cuadro=indice_cuadro+1;
  % M(j) = getframe;

end
% movie(M,1,100);
%movie2avi(M,'JupTroy.avi','compression','Cinepak');