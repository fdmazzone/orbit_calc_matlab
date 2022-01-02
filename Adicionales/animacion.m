function animacion(pos_rot);

figure;
hold on
pos=squeeze(pos_rot(:,:,1));
l=size(pos);
color=rand([l(1),3]);

for j=1:l(1);
    
    h{j}=plot3(pos(j,1),pos(j,2),pos(j,3),...
        '.','MarkerSize',20,'Color',color(j,:));
    set(h{j},'Erase','xor');
end

long=1.5;
axis([-long long -long long -long long])
plot3(0,0,0,'.','MarkerSize',1,'Color','y')
set(gca,'Color','k')
axis square
view([45,45])
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
   for k=1:l(1);
    set(h{k},'XData',pos(:,1),'YData',pos(:,2),'Zdata',pos(:,3),'Color',color(k,:));
   end
%     
   nombrejpg=num2str(indice_cuadro);
   falta=5-length(nombrejpg);
   
   nombrejpg=[repmat('0',[1,falta]),nombrejpg,'.jpg'];
   eval(['print -djpeg ',nombrejpg]) ;
   indice_cuadro=indice_cuadro+1;
  % M(j) = getframe;

end
 %movie(M,1,100);
%movie2avi(M,'JupTroy.avi','compression','Cinepak');