function neocp2ciel(archivo);

fid = fopen(archivo);
mpcorb= textscan(fid, '%[^\n]');
mpcorb=char(mpcorb{1});
H=mpcorb(:,9:13);
Cuerpos.H=str2num(H);
Cuerpos.nombres=mpcorb(:,1:7);
Cuerpos.G=str2num(mpcorb(:,14:18));
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
Cuerpos.epoca=epoca;
clear dia mes anio xmas;

Cuerpos.M=str2num(mpcorb(:,27:35));
Cuerpos.peri=str2num(mpcorb(:,38:46));
Cuerpos.node=str2num(mpcorb(:,49:57));
Cuerpos.incli=str2num(mpcorb(:,60:68));
Cuerpos.e=str2num(mpcorb(:,71:79));
Cuerpos.n=str2num(mpcorb(:,81:91));
Cuerpos.a=str2num(mpcorb(:,93:103));
fclose(fid);

cielwrite(Cuerpos.nombres,Cuerpos.H,Cuerpos.G,Cuerpos.epoca,Cuerpos.M,Cuerpos.peri,Cuerpos.node,Cuerpos.incli,Cuerpos.e,Cuerpos.a)