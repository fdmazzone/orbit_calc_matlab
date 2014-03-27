function dat2mat(archivo);

fid = fopen(archivo);
mpcorb= textscan(fid, '%[^\n]');
mpcorb=char(mpcorb{1});
H=mpcorb(:,9:13);
asteroides.H=str2num(H);
asteroides.nombres=mpcorb(:,1:7);
asteroides.G=str2num(mpcorb(:,15:19));
xmas=@(x) max(x,0);
epoca=mpcorb(:,22:25);
depocaJ=strmatch('J',mpcorb(:,21));
anio=2000+str2num(epoca(:,1:2));
anio(depocaJ)=1900+str2num(epoca(depocaJ,1:2));
mes=char(epoca(:,3))+0;
dia=char(epoca(:,4))+0;
dia=xmas(dia-48)-xmas(dia-57)+xmas(dia-64);
mes=xmas(mes-48)-xmas(mes-57)+xmas(mes-64);
epoca=gre2jul(dia,mes,anio);
asteroides.epoca=epoca(1);
clear dia mes anio xmas;

asteroides.M=str2num(mpcorb(:,27:35));
asteroides.peri=str2num(mpcorb(:,38:46));
asteroides.node=str2num(mpcorb(:,49:57));
asteroides.incli=str2num(mpcorb(:,60:68));
asteroides.e=str2num(mpcorb(:,71:79));
asteroides.n=str2num(mpcorb(:,81:91));
asteroides.a=str2num(mpcorb(:,93:103));
fclose(fid);
[nombre_archivo, camino]=uiputfile('base.mat','Guardar Archivo de Elementos');
switch true
    case ispc
        save([camino,'\',nombre_archivo],'asteroides');
    case isunix
        save([camino,'/',nombre_archivo],'asteroides');
end

