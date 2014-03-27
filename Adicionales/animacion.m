function animacion(pos_rot);

figure;
hold on
pos=squeeze(pos_rot(:,:,1));
h=plot3(pos(:,1),pos(:,2),pos(:,3),'.','MarkerSize',10);
set(h,'Erase','xor');

axis([-6 6 -6 6])
plot3(0,0,0,'.','MarkerSize',15,'Color','y')
axis square
view([0,90])
grid off
hold off
% indice_cuadro=1;
% nombrejpg=num2str(indice_cuadro);
% falta=5-length(nombrejpg);
% 
% nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
% eval(['print -djpeg ',nombrejpg]) ;
% indice_cuadro=indice_cuadro+1;


for j=1:size(pos_rot,3);
   drawnow
   pos=squeeze(pos_rot(:,:,j));
   
   set(h,'XData',pos(:,1),'YData',pos(:,2),'Zdata',pos(:,3));
%     
%    nombrejpg=num2str(indice_cuadro);
%    falta=5-length(nombrejpg);
%    
%    nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
%    eval(['print -djpeg ',nombrejpg]) ;
%    indice_cuadro=indice_cuadro+1;
   M(j) = getframe;

end
 movie(M,1,100);
movie2avi(M,'JupTroy.avi','compression','Cinepak');