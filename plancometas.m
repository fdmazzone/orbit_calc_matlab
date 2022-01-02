function plancometas(ARLim,DELim,MagLim,ElongSLim,ElongLLim)

load('cometas.mat');
switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end



if nargin>5 && strcmp(varargin{1},'date');
        Anio=varargin{2};
        Mes=varargin{3};
        Dia=varargin{4};
else
        hoy=now;
        hoy=hoy+1721058.5-observador.UToffset/24;
        [Anio Mes Dia]=jul2gre(hoy);
end
EpocEfemer=gre2jul(Dia, Mes, Anio);
EpocEfemer=[EpocEfemer;EpocEfemer+1/(24*60)];
EpocEfemer=EpocEfemer(:);
CantEpoc=2;





%[Anio Mes Dia]=jul2gre(tfin);

Pos0=cometas.posiciones';
PosDot0=cometas.velocidades';
CantCuerposMenores=size(Pos0,2);
Pos0=(Pos0(:));
PosDot0=(PosDot0(:));
Epoca=cometas.epocas;
H=cometas.H;
G=cometas.G;
Nombres=cometas.nombres;
Designacion=cometas.designacion;

%%%% Elegimos el metodo

Integrador=@colocacion_nb_adap;
IntegraParam.tol=1e-20;
IntegraParam.orden=10;
IntegraParam.iter=3;
IntegraParam.paso=0.3;
        
NombreMet='Colocacion Adaptativo';

%%%% Elegimos la funcion fuerzas dejado para mas adelante poder elegir
%%%% modelos alternativos de sistema solar

funcion=@fuerza_nb;
   



[GM1,FuncionDatosSol,FuncionDatos,PosIni,VelIni,Jini]= sistema(CantCuerposMenores);
CantCuerpos=FuncionDatos.cantidad_planetas+CantCuerposMenores;

IntegraParam.mensaje='Integrando sistema solar...';
[Pos,Vel]=Integrador(funcion,FuncionDatosSol,Epoca,PosIni,VelIni,Jini,IntegraParam);




%%==========Convertir coordenadas a baric�ntricas

[Pos0,PosDot0]=helio2bari(Pos0',PosDot0',Pos,Vel,GM1);
Pos=[Pos,Pos0];
Vel=[Vel,PosDot0];

IndEpocFut=find(EpocEfemer>=Epoca);
IndEpocPas=setdiff((1:1:length(EpocEfemer))',IndEpocFut);

PosFut=[];
VelFut=[];
PosPas=[];
VelPas=[];

%%% Integramos el sistema solar m�s el cuerpo, primera en la epoca futuras
%%% y luego en las pasadas.

if ~isempty(IndEpocFut)
    IntegraParam.mensaje='Integrando hacia el futuro...';
    [PosFut,VelFut]=Integrador(funcion,FuncionDatos,EpocEfemer(IndEpocFut),Pos,Vel,Epoca,IntegraParam);
end

if ~isempty(IndEpocPas)
    IndEpocPas=sort(IndEpocPas,'descend');
    IntegraParam.mensaje='Integrando hacia el pasado...';
    [PosPas,VelPas]=Integrador(funcion,FuncionDatos,EpocEfemer(IndEpocPas),Pos,Vel,Epoca,IntegraParam);
    I=size(PosPas,1):-1:1;
    PosPas=PosPas(I,:);
    VelPas=VelPas(I,:);
end


PosBari=[PosPas;PosFut];
VelBari=[VelPas;VelFut];
clear PosPas PosFut VelPas VelFut;

%%%La ponemos en las dimensiones standard (CantCuerpos x 3 x
%%%CantEpoc)
PosBari=   permute(reshape(PosBari,[CantEpoc,3,CantCuerpos]),[3,2,1]);
VelBari=   permute(reshape(VelBari,[CantEpoc,3,CantCuerpos]),[3,2,1]);



%%%% GM1 nuevo
GM1=[GM1,zeros(1,CantCuerposMenores)];

%%%%%Agregamos posicion del sol

R0=reshape((-GM1(2:end)/GM1(1))*PosBari(:,:),[1,3,CantEpoc]);
V0=reshape((-GM1(2:end)/GM1(1))*VelBari(:,:),[1,3,CantEpoc]);
PosBari=cat(1,R0,PosBari);
VelBari=cat(1,V0,VelBari);


switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end


cuerpo_observador=4;%%%%lo vamos a usar solo con la tierra
luna_observador=5;
cantidad_planetas=FuncionDatos.cantidad_planetas;


[CantCuerpos,NoSirve,CantEpoc]=size(PosBari);

PosHelio=PosBari-repmat(PosBari(1,:,:),[CantCuerpos,1,1]);
VelHelio=VelBari-repmat(VelBari(1,:,:),[CantCuerpos,1,1]);







Observador_Objetos=repmat(PosBari(cuerpo_observador,:,:),[CantCuerpos,1,1])-PosBari;


Delta=sqrt(sum(Observador_Objetos.^2,2));



%% tiempo que demora la luz en llegar al observador en dias
luz_tiempo=-0.0057755183*Delta(2:end,:,:);
luz_tiempo=repmat(luz_tiempo,[1,3,1]);

%%% correciones de posiciones por la velocidad de la  luz
pos_bari_aux=permute(PosBari(2:end,:,:),[3,2,1]);
vel_bari_aux=permute(VelBari(2:end,:,:),[3,2,1]);
luz_tiempo=permute(luz_tiempo,[3,2,1]);
pos_bari_aux=pos_bari_aux(:,:);
vel_bari_aux=vel_bari_aux(:,:);
luz_tiempo=luz_tiempo(:,:);


pos_bari_corr=pos_bari_aux+luz_tiempo.*vel_bari_aux...
    +0.5*luz_tiempo.^2.*funcion(pos_bari_aux,FuncionDatos);
vel_bari_corr=vel_bari_aux+luz_tiempo.*funcion(pos_bari_aux,FuncionDatos);

pos_bari_corr=   permute(reshape(pos_bari_corr,[CantEpoc,3,CantCuerpos-1]),[3,2,1]);
vel_bari_corr=   permute(reshape(vel_bari_corr,[CantEpoc,3,CantCuerpos-1]),[3,2,1]);




%%%%%Agregamos posicion del sol
luz_tiempo_sol=-0.0057755183*Delta(1,:,:);
luz_tiempo_sol=repmat(luz_tiempo_sol,[CantCuerpos-1,1,1]);
luz_tiempo_sol=repmat(luz_tiempo_sol,[1,3,1]);
luz_tiempo_sol=permute(luz_tiempo_sol,[3,2,1]);
luz_tiempo_sol=luz_tiempo_sol(:,:);

pos_bari_corr_sol=pos_bari_aux+luz_tiempo_sol.*vel_bari_aux...
    +0.5*luz_tiempo_sol.^2.*funcion(pos_bari_aux,FuncionDatos);
vel_bari_corr_sol=vel_bari_aux+luz_tiempo_sol.*funcion(pos_bari_aux,FuncionDatos);

clear pos_bari_aux vel_bari_aux;

pos_bari_corr_sol=   permute(reshape(pos_bari_corr_sol,[CantEpoc,3,CantCuerpos-1]),[3,2,1]);
vel_bari_corr_sol=   permute(reshape(vel_bari_corr_sol,[CantEpoc,3,CantCuerpos-1]),[3,2,1]);

pos_bari_corr_sol=reshape((-GM1(2:end)/GM1(1))*pos_bari_corr_sol(:,:),[1,3,CantEpoc]);
vel_bari_corr_sol=reshape((-GM1(2:end)/GM1(1))*vel_bari_corr_sol(:,:),[1,3,CantEpoc]);
pos_bari_corr=cat(1,pos_bari_corr_sol,pos_bari_corr);
vel_bari_corr=cat(1,vel_bari_corr_sol,vel_bari_corr);

clear pos_bari_corr_sol vel_bari_corr_sol;

%%%%%%%%Transformamos heliocentricas
pos_helio_corr=pos_bari_corr-repmat(pos_bari_corr(1,:,:),[CantCuerpos,1,1]);
clear pos_bari_corr ;

%%heliocentricas,eclipticas, corregidas -> ecuatoriales
[pos_helio_ecua]=ecli2ecua(pos_helio_corr);
%[vel_helio_ecua]=ecli2ecua(vel_helio_corr);

clear pos_helio_corr vel_helio_corr;


%%% Distancia tierra_sol y tierra_objetos corregida por la velocidad de la luz
I=setdiff((1:CantCuerpos),cuerpo_observador);
Observador_Objetos=pos_helio_ecua(I,:,:)-repmat(pos_helio_ecua(cuerpo_observador,:,:),[length(I),1,1]);
%Observador_Objetos_vel=vel_helio_ecua(I,:,:)-repmat(vel_helio_ecua(cuerpo_observador,:,:),[length(I),1,1]);
Delta_corr=sqrt(sum(Observador_Objetos.^2,2));










%%Ecuatoriales -> Esfericas

DE=asind(Observador_Objetos(:,3,:)./Delta_corr);


AR=atan2(Observador_Objetos(:,2,:),Observador_Objetos(:,1,:));
    
impar=1:2:length(EpocEfemer);
par=2:2:length(EpocEfemer);



redond=floor(AR/pi);
AR=AR-redond*2*pi;
AR=12*AR/pi;
[AR DE]=correcparal(AR,DE,Delta_corr,EpocEfemer,observador.Longitude,observador.pcos,observador.psin);


[mov_apar, PA]=motion(AR(:,:,impar), DE(:,:,impar),AR(:,:,par), DE(:,:,par) );

AR=AR(:,:,impar);
DE=DE(:,:,impar);
Delta=Delta(:,:,impar);




Observador_Objetos=Observador_Objetos(:,:,impar);
Delta_corr=Delta_corr(:,:,impar);

R_corr=Delta_corr(1,:,:);
I=setdiff(I,1); %%%%I no tiene ni la tierra ni el sol
r_corr=sqrt(sum(pos_helio_ecua(I,:,impar).^2 ,2));




% %%%Elongacion solar

elong_sol=motion(AR,DE, repmat(AR(1,:,:),[size(AR,1),1,1]),repmat(DE(1,:,:),[size(AR,1),1,1]) )/3600;
% %%Elongacion Lunar

elong_luna=motion(AR,DE,...
    repmat(AR(luna_observador-1,:,:),[size(AR,1),1,1]),repmat(DE(luna_observador-1,:,:),[size(AR,1),1,1]) )/3600;



AngHorario=repmat(reshape(lst(EpocEfemer(impar),observador.Longitude),[1 1 CantEpoc/2]),[CantCuerpos-1,1,1])-15*AR;
Latitud=atand(1.00673949539932*observador.psin/observador.pcos);

Altitud= asind(sind(Latitud).*sind(DE)+cosd(Latitud)*cosd(DE).*cosd(AngHorario));

Azimut= atan2(sind(AngHorario),(cosd(AngHorario).*sind(Latitud)-tand(DE).*cosd(Latitud)))*180/pi;

I=find(Azimut<0);
Azimut(I)=360+Azimut(I);

beta=acosd((r_corr.^2 ...
    +Delta_corr(2:end,:,:).^2 ...
    -repmat(R_corr,[size(r_corr,1),1,1]).^2)...
    ./(2*(r_corr.*Delta_corr(2:end,:,:))));

beta_luna=beta(3,:,:);
beta=beta(cantidad_planetas:end,:,:);
FracIlumLuna=squeeze((1+cosd(beta_luna))/2);
mag=repmat(H,[1,1,size(AR,3)])+5*log10(Delta_corr(cantidad_planetas+1:end,:,:))+2.5*repmat(G,[1,1,size(AR,3)]).*log10(r_corr(cantidad_planetas:end,:,:));


% %%%Elongacion solar

elong_sol=motion(AR,DE, repmat(AR(1),size(AR)),repmat(DE(1),size(AR)) )/3600;
% %%Elongacion Lunar

elong_luna=motion(AR,DE,...
    repmat(AR(luna_observador-1),size(AR)),repmat(DE(luna_observador-1),size(AR)) )/3600;

ARSol=AR(1);
DESol=DE(1);

AR=AR(cantidad_planetas+1:end);
DE=DE(cantidad_planetas+1:end);
Altitud=Altitud(cantidad_planetas+1:end);
Azimut=Azimut(cantidad_planetas+1:end);
Delta=Delta(cantidad_planetas+2:end);
AngHorario=AngHorario(cantidad_planetas+1:end);
PA=PA(cantidad_planetas+1:end);
mov_apar=mov_apar(cantidad_planetas+1:end);

elong_sol=elong_sol(cantidad_planetas+1:end);
elong_luna=elong_luna(cantidad_planetas+1:end);
if ARLim(1)<=ARLim(2)
    Indices=find(ARLim(1)<AR & AR<ARLim(2) & DELim(1)<DE& DE<DELim(2)...
        & MagLim>mag & elong_sol>ElongSLim & elong_luna>=ElongLLim);
else
    Indices=find((ARLim(1)<AR | AR<ARLim(2)) & DELim(1)<DE& DE<DELim(2)...
        & MagLim>mag & elong_sol>ElongSLim & elong_luna>=ElongLLim);
end


[borrar, correctorIndices]=sort(AR(Indices),'ascend');
Indices=Indices(correctorIndices);
correctorIndices1=find(AR(Indices,1)<=ARSol);
correctorIndices2=find(AR(Indices,1)>ARSol);
Indices=[Indices(correctorIndices2);Indices(correctorIndices1)];




%=========================================================================
%=========================================================================

 
  pos=[degree2dms(AR(Indices)),degree2dms(DE(Indices)),mag(Indices),Delta(Indices),mov_apar(Indices),...
      PA(Indices),elong_sol(Indices), elong_luna(Indices), Altitud(Indices),...
      Azimut(Indices),AngHorario(Indices)/15];

signosaux=sign(DE(Indices));
signosmas=find(signosaux==1 | signosaux==0);
signosmenos=find(signosaux==-1);
signos(signosmas)='+';
signos(signosmenos)='-';
clear signosaux signosmas signosmenos
 


for j=1:length(Indices);
    muestra(j,:)=['<tr><td nowrap><input type="checkbox" name="Obj" value="',...
        cometas.nombres(Indices(j),:),'">',cometas.designacion(Indices(j),:),...
        '</a></td>','<td align="center" nowrap> \t%02.0f %02.0f %05.2f \t</td><td align="center" nowrap> ',...
        signos(j),' %02.0f %02.0f\t%05.2f </td> \t <td align="center" nowrap> %5.2f </td> \t<td align="center" nowrap>%7.4f </td>\t<td align="center" nowrap> %7.2f </td>\t<td align="center" nowrap> %7.3f </td> <td align="center" nowrap> %4.0f </td><td align="center" nowrap> %4.0f </td><td align="center" nowrap> %5.1f </td><td align="center" nowrap> %5.1f </td><td align="center" nowrap> %5.1f </td></tr>\n'];
end


webcount=fopen('cometas.html','w');


fprintf(webcount,'%s\n','<FORM METHOD=POST ACTION="http://scully.cfa.harvard.edu/cgi-bin/mpeph.cgi" TARGET="_NEW"><pre>');
fprintf(webcount,'%s\n','<title>Seguimiento Cometas</title>');
fprintf(webcount,'%s\n','<body bgcolor="#E0F8F7">');
fprintf(webcount,'%s\n','<center><p style="font-family: impact;font-size:30pt">Cometas</center>');

fprintf(webcount,'%s','<p style="font-family: times, serif; font-size:14pt; font-style:italic">');

fprintf(webcount,'%s%7.4f%s%7.4f%s\n','Rango de declinaciones:<font color=#DF0174,style=normal>: ',-90,' y ',DELim,'</font>');

[Anio, Mes, Dia]=jul2gre(EpocEfemer(1));
hh=(Dia-floor(Dia))*24;
mm=(hh-floor(hh))*60;

fprintf(webcount,'%s%02.0f%s%02.0f%s%04.0f%s%02.0f%s%02.0f%s%s\n','Fecha de posiciones:<font color=#DF0174,style=normal> ',floor(Dia),'-',floor(Mes),'-',Anio,'  ', floor(hh),':', floor(mm),' (UT)','</font>');
fprintf(webcount,'%s%5.2f%s\n','Magnitud l&iacute;mite<font color=#DF0174,style=normal>:', MagLim,'</font>');
fprintf(webcount,'%s%4.1f%s\n','Elongaci&oacute;n solar  m&iacute;nima: <font color=#DF0174,style=normal>:', ElongSLim, ' grados. </font>');
fprintf(webcount, '%s%s%s%s%s\n','Posiciones respecto al observatorio: <font color=#DF0174,style=normal> MPC  ', observador.cod,', ', observador.name_obs,' </font>');
fprintf(webcount, '%s%4.2f%s\n','Planilla generada por <a href="http://www.aoacm.com.ar/images/stories/I20/Tutorial.pdf"> orbit_calc</a> </font>');

fprintf(webcount,'%s\n','<P>');
fprintf(webcount,'%s\n','<center>');
fprintf(webcount,'%s\n','<table border="1" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF">');
fprintf(webcount,'%s\n','<tr valign="bottom" bgcolor="#CCCCCC"> ');
    fprintf(webcount,'%s\n','<td nowrap> Designaci&oacute;n </td>');
    fprintf(webcount,'%s\n','<td align="center" nowrap>AR </td>');
    fprintf(webcount,'%s\n','<td align="center" nowrap> DE </td>');
    fprintf(webcount,'%s\n','<td align="center" nowrap> Mag. m1</td>');
    fprintf(webcount,'%s\n','<td align="center" nowrap>Delta </td>');
    fprintf(webcount,'%s\n','<td align="center" nowrap> "/min </td>');
     fprintf(webcount,'%s\n','<td align="center" nowrap> P.A. </td>');
    fprintf(webcount,'%s\n','<td align="center" nowrap>E. Solar </td>');
fprintf(webcount,'%s\n','<td align="center" nowrap>E. Lunar </td>');
fprintf(webcount,'%s\n','<td align="center" nowrap>Altitud </td>');
fprintf(webcount,'%s\n','<td align="center" nowrap>Azimut </td>');
fprintf(webcount,'%s\n','<td align="center" nowrap>Ang. Horario </td>');
fprintf(webcount,'%s\n','</tr> ');

fprintf(webcount,muestra', pos');
fprintf(webcount,'%s\n','</table>');
fprintf(webcount,'%s\n','</center>');

fprintf(webcount,'%s\n','<center><input type=submit value=" Obtener Efem&eacute;rides/&oacute;rbitas "> <input type=reset value=" Limpiar forma "><p></center>');
fprintf(webcount,'%s\n','<p><hr><p>');
fprintf(webcount,'%s\n','<center>');
fprintf(webcount,'%s\n','Opciones:');
fprintf(webcount,'%s\n','<p>Fecha inicio efem&eacute;rides: <input name="d" maxlength=20 size=17 VALUE="">  N&uacute;mero de &eacute;pocas en efem&eacute;rides <input name="l" maxlength=4 size=4 VALUE="24">');
fprintf(webcount,'%s\n','<p>Intervalo de las efem&eacute;rides: <input name="i" maxlength=3 size=3 VALUE="1">  Efem&eacute;rides');
fprintf(webcount,'%s\n','unidad: <input type="radio" name="u" value="d"> d&iacute;as  <input type="radio" name="u" value="h" CHECKED> horas <input type="radio" name="u" value="m"> minutos');
fprintf(webcount,'%s\n','<input type="radio" name="u" value="s"> segundos');
fprintf(webcount,'%s\n','<p><a href="http://cfa-www.harvard.edu/iau/lists/ObsCodes.html">C&oacute;digo de observatorio </a>: <input name="c" maxlength=3 size=3 VALUE="',observador.cod,'">');
fprintf(webcount,'%s\n','<p>Mostrar posiciones en: <input type="radio" name="raty" value="h">sexagecimal truncadas o');
fprintf(webcount,'%s\n','<input type="radio" name="raty" value="a" CHECKED>sexagesimal completas o');
fprintf(webcount,'%s\n','<input type="radio" name="raty" value="d"> decimal ');
fprintf(webcount,'%s\n','<p>Mostrar movimiento en: <input type="radio" name="m" VALUE="s"> "/sec  <input type="radio" name="m" VALUE="m" CHECKED> "/min  <input type="radio" name="m"');
fprintf(webcount,'%s\n','VALUE="h"> "/hr  <input type="radio" name="m" VALUE="d"> "/d&iacute;a');
fprintf(webcount,'%s\n','<p><input type="radio" name="s" VALUE="t" CHECKED> Movimiento total y direcci&oacute;n');
fprintf(webcount,'%s\n','  <input type="radio" name="s" VALUE="s"> Separados R.A. and Decl. Movimiento en el cielo');
fprintf(webcount,'%s\n','  <input type="radio" name="s" VALUE="c"> Separados R.A. and Decl. Movimiento en coordenadas');
fprintf(webcount,'%s\n','<p><input type="checkbox" name="igd" value="y" > Suprimir la salida si el sol est&aacute; arriba del horizonte local');
fprintf(webcount,'%s\n','<p><input type="checkbox" name="ibh" value="y" > Suprimir la salida si el objeto est&aacute; debajo del horizonte local');
fprintf(webcount,'%s\n','<p><input type="checkbox" name="fp" value="y"> Generar efem&eacute;rides perturbadas para &oacute;rbitas imperturbadas');
fprintf(webcount,'%s\n','<p>Mostrar los elementos para la &eacute;poca <input name="oed" maxlength=20 size=17 VALUE="">');
fprintf(webcount,'%s\n','<p><a href="#formats">Formatos</a> :');
fprintf(webcount,'%s\n','<p>');
fprintf(webcount,'%s\n','<table border="0" cellpadding="5" cellspacing="0" width="100%">');
fprintf(webcount,'%s\n','<tr>');
fprintf(webcount,'%s\n','<td width="33%"><input type="radio" name="e" VALUE="-2"> ninguno</td>');
fprintf(webcount,'%s\n','<td width="33%"><input type="radio" name="e" VALUE="-1"> MPC 1-linea</td>');
fprintf(webcount,'%s\n','<td width="33%"><input type="radio" name="e" VALUE="0" CHECKED> MPC 8-lineas</td>');
fprintf(webcount,'%s\n','</tr><tr><td width="33%"><input type="radio" name="e" VALUE="1"> SkyMap (SkyMap Software)</td><td width="33%"><input type="radio" name="e" VALUE="2"> Guide');
fprintf(webcount,'%s\n','(Project Pluto)</td><td width="33%"><input type="radio" name="e" VALUE="12"> MegaStar V4.x (E.L.B. Software)</td></tr><tr><td width="33%"><input type="radio"');
fprintf(webcount,'%s\n','name="e" VALUE="6"> Carts du Ciel</TD>');
fprintf(webcount,'%s\n','</tr>');
fprintf(webcount,'%s\n','</table>');
fprintf(webcount,'%s\n',' </center>');
fprintf(webcount,'%s\n','<p>');
fprintf(webcount,'%s\n','<center><input type=submit value=" Obtener efem&eacute;rides/&oacute;rbitas "> <input type=reset value=" Limpiar forma "><p></center>');
fprintf(webcount,'%s\n','<p><hr><p>');





fclose(webcount);







