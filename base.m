%Funcio base: transforma la base de datos MPCORB.dat en un archivo *.mat.
%El archico se llama asteroides.mat y guarda la estructura asteroides.
function varargout=base(varargin)
switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
        esta_mpcorb=dir([observador.directorio,'\mpcorb.dat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
        esta_mpcorb=dir([observador.directorio,'/mpcorb.dat']);
end

if isempty(esta_mpcorb)
    disp('mpcorb.dat no fue hallado');
    return
end
cantidad_estimativa_lineas=0.005*esta_mpcorb.bytes;
%%abrimos archivo
leyenda_barra=sprintf('%d %s',0,'asteroides leidos....');
progreso=waitbar(0,leyenda_barra);

switch true
    case ispc
        fid = fopen([observador.directorio,'\mpcorb.dat']);
    case isunix
        fid = fopen([observador.directorio,'/mpcorb.dat']);
end


%funcion auxiliar
xmas=@(x) max(x,0);
%parametros de lectura
largo_bloque = 10000;
bloques_leidos=0;
formato = '%[^\n]';
%%inicializaciones 
asteroides.nombres=char([]);
asteroides.H=double([]);
asteroides.G=double([]);
asteroides.epoca=double([]);
asteroides.M=double([]);
asteroides.peri=double([]);
asteroides.node=double([]);
asteroides.incli=double([]);
asteroides.e=double([]);
asteroides.n=double([]);
asteroides.a=double([]);
asteroides.U=char([]);
asteroides.ult_obs=double([]);
asteroides.clase=char([]);
asteroides.designacion=char([]);
asteroides.nroops=double([]);
asteroides.numer=double([]);
asteroides.arc_obs=double([]);

%%Leemos mpcorb de a bloques 
while ~feof(fid)
    %%%lee el bloque
    if not(bloques_leidos)
        mpcorb = textscan(fid, formato, largo_bloque,'headerLines',41); 
    else
        mpcorb = textscan(fid, formato, largo_bloque);
    end
    bloques_leidos=bloques_leidos+1;   
    mpcorb=char(mpcorb{1});
    %%%primer campo
    asteroides.nombres=[asteroides.nombres;mpcorb(:,1:7)];
    %%% H G, cuidado pueden no estar
    Haux=mpcorb(:,9:13);
    Gaux=mpcorb(:,15:19);
    I=strmatch('     ',Haux);
    H(I)=NaN;
    G(I)=NaN;
    IH=setdiff((1:size(mpcorb,1))',I);
    H(IH)=str2num(Haux(IH,:))';
    G(IH)=str2num(Gaux(IH,:))';
    asteroides.H=[asteroides.H;H'];
    asteroides.G=[asteroides.G;G'];
    clear Haux Gaux H I G IH;
    
    
    epoca=mpcorb(:,21:25);
    depocaJ=strmatch('J',epoca(:,1));
    anio=2000+str2num(epoca(:,2:3));
    anio(depocaJ)=1900+str2num(epoca(depocaJ,2:3));
    mes=char(epoca(:,4))+0;
    dia=char(epoca(:,5))+0;
    dia=xmas(dia-48)-xmas(dia-57)+xmas(dia-64);
    mes=xmas(mes-48)-xmas(mes-57)+xmas(mes-64);
    epoca=gre2jul(dia,mes,anio);
    asteroides.epoca=[asteroides.epoca;epoca];
    clear epoca;
    
    
    asteroides.M=[asteroides.M;str2num(mpcorb(:,27:35))];
    asteroides.peri=[asteroides.peri;str2num(mpcorb(:,38:46))];
    asteroides.node=[asteroides.node;str2num(mpcorb(:,49:57))];
    asteroides.incli=[asteroides.incli;str2num(mpcorb(:,60:68))];
    asteroides.e=[asteroides.e;str2num(mpcorb(:,71:79))];
    asteroides.n=[asteroides.n;str2num(mpcorb(:,81:91))];
    asteroides.a=[asteroides.a;str2num(mpcorb(:,93:103))];
    
    U=mpcorb(:,106);
    Uelim1=strmatch(' ',U);
    U(Uelim1)='X';
    asteroides.U=[asteroides.U;U];
    %%%Detectamos la cantidad de numerados;
    if isempty(asteroides.numer)
        numer=mpcorb(:,173);
        I=strmatch(' ',numer);
        if not(isempty(I))
           asteroides.numer=(bloques_leidos-1)*largo_bloque+I(1)-1;
        end
    end
   
    ult_obs(:,1)=str2num(mpcorb(:,195:198));%a�o
    ult_obs(:,2)=str2num(mpcorb(:,199:200));%mes
    ult_obs(:,3)=str2num(mpcorb(:,201:202));%dia
    ult_obs=gre2jul(ult_obs(:,3),ult_obs(:,2),ult_obs(:,1));
    asteroides.ult_obs=[asteroides.ult_obs;ult_obs];
    clear ult_obs
    
    asteroides.clase=[asteroides.clase;mpcorb(:,162:165)];
    asteroides.designacion=[asteroides.designacion;mpcorb(:,167:194)];
    asteroides.nroops=[asteroides.nroops;str2num(mpcorb(:,124:127))];
    

    arc_obs_dia=strmatch('days',mpcorb(:,133:136)); 
    arc_obs_anio=setdiff((1:1:size(mpcorb,1)),arc_obs_dia);
    arc_obs(arc_obs_dia)=str2num(mpcorb(arc_obs_dia,128:131));
    arc_obs(arc_obs_anio)=(str2num(mpcorb(arc_obs_anio,133:136))-str2num(mpcorb(arc_obs_anio,128:131))+1)*365.25;
    
    asteroides.arc_obs=[asteroides.arc_obs;arc_obs'];
    clear arc_obs arc_obs_s;
    
    
    
   leyenda_barra=sprintf('%d %s',largo_bloque*bloques_leidos,'asteroides leidos....');
    waitbar(largo_bloque*bloques_leidos/cantidad_estimativa_lineas,progreso,leyenda_barra);

    
end

clasedec=hex2dec(asteroides.clase(:,3:4));
neos=length(find(clasedec==2|clasedec==3|clasedec==4));
tnos=length(find(clasedec==14 | clasedec==15 | clasedec==16 | clasedec==17  ));
hoy=now;
hoy=hoy+1721058.5;
[Anio Mes Dia]=jul2gre(hoy);

quincena=['A';
           'B';
           'C';
           'D';
           'E';
           'F';
           'G';
           'H';
           'J';
           'K';
           'L';
           'M';
           'N';
           'O';
           'P';
           'Q';
           'R';
           'S';
           'T';
           'U';
           'V';
           'W';
           'X';
           'Y'];
   
  if Dia>15
      I=0;
  else
      I=-1;
  end
  I=2*Mes+I;
  Anio=num2str(Anio);
  descubiertos=length(strmatch(['K',Anio(3:4),quincena(I)],asteroides.nombres(asteroides.numer+1:end,1:4)));
  




fprintf('%s\n','ESTADISTICAS');
fprintf('%d %s\n',length(asteroides.a), 'asteroides procesados');                               
fprintf('%d %s\n',asteroides.numer, 'asteroides numerados');
fprintf('%d %s\n',neos, 'NEO');
fprintf('%d %s\n',tnos, 'TNO');
fprintf('%d %s\n',descubiertos, 'asteroides descubiertos durante esta quincena');
if nargin>0 & varargin{1}=='estadisticas'
    NombresBaseAnterior=DatosComparacion;
    I=(asteroides.numer+1):size(asteroides.a,1);
    [~,IndNuevos]=setdiff(asteroides.designacion(I,10:end),NombresBaseAnterior,'rows');
    varargout{1}=I(IndNuevos);
    IndNuevos=I(IndNuevos);
end

switch true
    case ispc
        save([observador.directorio1,'\asteroides.mat'],'asteroides');
    case isunix
        save([observador.directorio1,'/asteroides.mat'],'asteroides');
end

close(progreso);
fclose(fid);



function NombresBaseAnterior=DatosComparacion
load('asteroides');
NombresBaseAnterior=asteroides.designacion(:,10:end);


































