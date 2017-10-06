%%Esta funci�n sirve para convertir las entradas de mpcorb.dat 
%%en entradas validas para Carts du Ciel. El output es el archivo
%% asteroides.dat
function cielwrite(nombres,H,G,epoca,M,peri,node,incli,e,a)
% global directorio1
% switch true
%     case ispc
%         load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
%         fid=fopen([observador.directorio_ciel,'\asteroides.dat'],'w');
%     case isunix
%         load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
%         fid=fopen([observador.directorio_ciel,'/asteroides.dat'],'w');
% end

fid=fopen('asteroides.dat','w');

n=length(H);
[anio, mes, dia]=jul2gre(epoca);
muestra1=repmat('|%4.0f %02.0f %06.3f|%6.6f  |%8.6f|%8.4f|%8.4f |%8.4f | 2000|%8.4f  |%4.1f | %4.2f|   0.00\n',[n,1]);
muestra=[nombres,muestra1];
fprintf(fid,muestra',[anio,mes,dia,e,a,incli,node,peri,M,H,G]');
fclose(fid);