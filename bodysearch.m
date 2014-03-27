function varargout=bodysearch(AR1,AR2,DE1,DE2, mag,elong_solarlim,elong_lunar_lim, varargin)
global asteroides
%% Cargando datos

progreso=waitbar(0,'Cargando bases de datos....');

switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end



load('obscod.mat');
waitbar(1);
delete(progreso);



%%Procesando opciones
progreso=waitbar(0,'Procesando opciones....');

is_ciel=false;
is_html=false;
is_silent=false;
size_mpc=length(asteroides.H);
filtro=1:size_mpc;
filtro_filtro=filtro;

donde_es_char=find(cellfun('isclass',varargin,'char')==1);
if nargin>7 && strcmp(varargin{1},'date');
        Anio=varargin{2};
        Mes=varargin{3};
        Dia=varargin{4};

        donde_es_char(1)=[];
else
        hoy=now;
        hoy=hoy+1721058.5-observador.UToffset/24;
        [Anio Mes Dia]=jul2gre(hoy);
end

for indices_var_char=1:length(donde_es_char)
    indice=donde_es_char(indices_var_char);
    switch varargin{indice}

        case  'ciel'
            is_ciel=1;
        case 'html'
            is_html=true;
        case 'silencioso'
            is_silent=true;
            
            
        case 'neos'
             clasedec=hex2dec(asteroides.clase(filtro,3:4));
             filtro_filtro=find(clasedec==2|clasedec==3|clasedec==4);
             filtro=filtro(filtro_filtro);
        case 'main belt'
             clasedec=hex2dec(asteroides.clase(filtro,3:4));
             filtro_filtro=find(clasedec==0|clasedec==1);
             filtro=filtro(filtro_filtro);   
        case 'mars cross'
             clasedec=hex2dec(asteroides.clase(filtro,3:4));
             filtro_filtro=find(clasedec==5|clasedec==6|clasedec==7);
             filtro=filtro(filtro_filtro);    
        case 'hilda'
             clasedec=hex2dec(asteroides.clase(filtro,3:4));
             filtro_filtro=find(clasedec==8);
             filtro=filtro(filtro_filtro); 
        case 'jupiter troyan'
              clasedec=hex2dec(asteroides.clase(filtro,3:4));
              filtro_filtro=find(clasedec==9);
              filtro=filtro(filtro_filtro);
        case 'centaur'
              clasedec=hex2dec(asteroides.clase(filtro,3:4));
              filtro_filtro=find(clasedec==10);
              filtro=filtro(filtro_filtro);    
        case 'TNO'
              clasedec=hex2dec(asteroides.clase(filtro,3:4));
              filtro_filtro=find(clasedec==14 | clasedec==15 | clasedec==16 | clasedec==17  );
              filtro=filtro(filtro_filtro);
        case 'last obs'
              filtro_filtro=find(asteroides.ult_obs(filtro)<=gre2jul(Dia,Mes,Anio)-varargin{indice+1}(2)*365.25...
                  & asteroides.ult_obs(filtro)>=gre2jul(Dia,Mes,Anio)-varargin{indice+1}(1)*365.25);
              filtro=filtro(filtro_filtro);   
        case 'num ops'
              filtro_filtro=find(asteroides.nroops(filtro)<=varargin{indice+1}(2)...
                  & asteroides.nroops(filtro)>=varargin{indice+1}(1));
              filtro=filtro(filtro_filtro);
        case 'U'
              filtro_U=strmatch('X',asteroides.U);
              filtro_U=union(strmatch('E',asteroides.U),filtro_U);
              filtro_U=union(strmatch('F',asteroides.U),filtro_U);
              filtro_U=union(strmatch('D',asteroides.U),filtro_U);
              filtro=setdiff(filtro,filtro_U);
              filtro_filtro=find(str2num(asteroides.U(filtro))>=varargin{indice+1}(1)...
                  & str2num(asteroides.U(filtro))<=varargin{indice+1}(2));
              filtro=filtro(filtro_filtro);
              clear filtro_U
        case 'a'
             filtro_filtro=find(asteroides.a(filtro)>=varargin{indice+1}(1) & asteroides.a(filtro)<=varargin{indice+1}(2));
             filtro=filtro(filtro_filtro);
        case 'e'
             filtro_filtro=find(asteroides.e(filtro)>=varargin{indice+1}(1) & asteroides.e(filtro)<=varargin{indice+1}(2));
             filtro=filtro(filtro_filtro);
        case 'incli'
             filtro_filtro=find(asteroides.incli(filtro)>=varargin{indice+1}(1) & asteroides.incli(filtro)<=varargin{indice+1}(2));
             filtro=filtro(filtro_filtro);
        case 'arc'
              filtro_filtro=find(asteroides.arc_obs(filtro)<=varargin{indice+1}(2)...
                  & asteroides.arc_obs(filtro)>=varargin{indice+1}(1));
              filtro=filtro(filtro_filtro);
        case 'IncrArc'
              DeltaArc=gre2jul(Dia,Mes,Anio)-asteroides.ult_obs;
              PorcentIncr=100*DeltaArc./asteroides.arc_obs;
              filtro_filtro=find(PorcentIncr(filtro)>=varargin{indice+1});
              filtro=filtro(filtro_filtro);
        case 'numerados'
              primer_num=varargin{indice+1}(1);
              segundo_num=varargin{indice+1}(2);
              filtro=intersect(filtro,primer_num:1:segundo_num);
%               filtro=filtro(filtro_filtro);
            
    end
end
waitbar(1);
close(progreso);
%% Reasignando variables y calculando algunasnuevas y faciles

progreso=waitbar(0,'Calculando....');
pv=0.154; %Albedo
nombres=asteroides.nombres(filtro,1:7);
H=asteroides.H(filtro);
G=asteroides.G(filtro);
epoca=asteroides.epoca(filtro);
M=asteroides.M(filtro);
peri=asteroides.peri(filtro);
node=asteroides.node(filtro);
incli=asteroides.incli(filtro);
e=asteroides.e(filtro);
n=asteroides.n(filtro);
a=asteroides.a(filtro);
clase=asteroides.clase(filtro,:);
designacion=asteroides.designacion(filtro,:);
ultobs=asteroides.ult_obs(filtro);
U=asteroides.U(filtro);
nroops=asteroides.nroops(filtro);
arc_obs=asteroides.arc_obs(filtro);

waitbar(.1);


% Posicion de laorbita en el espacio.

sine=3.977771559319137e-001;
cose= 9.174820620691818e-001;
F1=cosd(node);
G1=cose*sind(node);
H1=sine*sind(node);
P1=-sind(node).*cosd(incli);
Q1=cosd(node).*cosd(incli)*cose-sind(incli)*sine;
R1=cosd(node).*cosd(incli)*sine+sind(incli)*cose;
a1=sqrt(F1.^2+P1.^2);
b1=sqrt(G1.^2+Q1.^2);
c1=sqrt(H1.^2+R1.^2);
A1=atan2(F1,P1)*180/pi;
B1=atan2(G1,Q1)*180/pi;
C1=atan2(H1,R1)*180/pi;



%%Tiempo juliano inicial
JD=gre2jul(Dia,Mes,Anio);
t=JD;
%%Posici�n de la tierra en coordenadas ecuatoriales
pos_tie=efemvsop87jul([t;t+1/(24*60)],'ear');
pos_emb=efemvsop87jul(t,'emb');
mu=81.300604267196;
pos_luna=pos_emb+mu*(pos_emb-pos_tie(1,:));
pos_sol=ecli2ecua(-pos_tie);
xsol=pos_sol(:,1); ysol=pos_sol(:,2); zsol=pos_sol(:,3);
R2=norm(pos_sol(1,:));
ARsol=atan2(ysol(1),xsol(1));
k=floor(ARsol/(2*pi));
ARsol=(ARsol-k*2*pi)*12/pi;

waitbar(.3);

[AR,DE,Delta,r,x,y,z]=kepler_solucion(t,epoca,M,peri,e,n,a,A1,B1,C1,a1,b1,c1,xsol(1),ysol(1),zsol(1),0.001);

waitbar(.6);

%%Magnitud
beta=acosd((r.^2+Delta.^2-R2.^2)./(2*(r.*Delta)));
phi1=exp(-3.33*(tand(beta/2)).^(0.63));
phi2=exp(-1.87*(tand(beta/2)).^(1.22));
mag1=H+5*log10(r.*Delta)-2.5*log10((1-G).*phi1+G.*phi2);
%%Buscando los cuerpos en el campo especificado
angulo=[x,y,z]*pos_sol(1,:)';
angulon=sqrt(sum([x y z].^2,2))*norm(pos_sol(1,:));
angulo=(angulon.^(-1)).*angulo;
elong_solar=acosd(angulo);
angulo=[x,y,z]*(pos_luna(1,:)-pos_tie(1,:))';
angulon=sqrt(sum([x y z].^2,2))*norm(pos_luna(1,:)-pos_tie(1,:));
angulo=(angulon.^(-1)).*angulo;
elong_lunar=acosd(angulo);

if AR1<=AR2
    Indices=find(AR1<AR & AR<AR2 & DE1<DE& DE<DE2 & mag1<mag & elong_solar>elong_solarlim & elong_lunar>=elong_lunar_lim);
else
    Indices=find((AR1<AR | AR<AR2) & DE1<DE& DE<DE2 & mag1<mag & elong_solar>elong_solarlim & elong_lunar>=elong_lunar_lim);
end




if isempty(Indices)
    waitbar(1);
    close(progreso);
    varargout{1}=0;
    disp('Ningun asteroide hallado');
    return;
end
%%%%Recalculamos las �rbitas, repetimos todo el proceso para los asterides
%%%%en Indices, con correcci�n por la finitud de la velocidad de la luz y
%%%%con una tolerancia menor en la soluci�n ecuaciones de Kepler


luztiempo=0.0057755183*Delta(Indices);
clear AR DE mag1 Delta r x y z


tiempo(:,1)=t-luztiempo;
tiempo(:,2)=tiempo(:,1)+1/(24*60);
t=tiempo;
for indi=1:1:2
    [AR_b,DE_b,Delta_b,r_b]=kepler_solucion(t(:,indi),epoca(Indices),M(Indices),peri(Indices),...
        e(Indices),n(Indices),a(Indices),A1(Indices),B1(Indices),C1(Indices),a1(Indices),b1(Indices),...
        c1(Indices),xsol(indi),ysol(indi),zsol(indi),0.0000000001);
    AR(:,indi)=AR_b;
    DE(:,indi)=DE_b;
    Delta(:,indi)=Delta_b;
    r(:,indi)=r_b;

end
clear AR_b DE_b Delta_b r_b

waitbar(1);
delete(progreso);

progreso=waitbar(0,'Preparando resultados....');
[~, Indices2]=sort(AR(:,1),'ascend');
correctorIndices=find(AR(Indices2,1)>=ARsol);
Indices2=[Indices2(correctorIndices);setdiff(Indices2,Indices2(correctorIndices))];

Indices=Indices(Indices2);

AR=AR(Indices2,:);
DE=DE(Indices2,:);
Delta=Delta(Indices2,:);
r=r(Indices2,:);

if is_ciel==1
    cielwrite(designacion(Indices,:),H(Indices),G(Indices),epoca(Indices),M(Indices),peri(Indices),node(Indices),incli(Indices),e(Indices),a(Indices))
end   



elong_solar=elong_solar(Indices);
elong_lunar=elong_lunar(Indices);
nombres=nombres(Indices,1:7);
H=H(Indices);
G=G(Indices);
clase=clase(Indices,:);
designacion=designacion(Indices,:);
ultobs=ultobs(Indices);
U=U(Indices);
nroops=nroops(Indices);
arc_obs=arc_obs(Indices);
diametro=1329000*pv^(-.5).*10.^(-H/5);
aj=5.204267;
tj=aj./a(Indices)+ 2*sqrt((a(Indices)/aj).*(1-e(Indices).^2)).*cosd(incli(Indices));

clear a M e incli peri node aj n


%Magnitud
beta=acosd((r(:,1).^2+Delta(:,1).^2-R2.^2)./(2*(r(:,1).*Delta(:,1))));
phi1=exp(-3.33*(tand(beta/2)).^(0.63));
phi2=exp(-1.87*(tand(beta/2)).^(1.22));
mag1=H+5*log10(r(:,1).*Delta(:,1))-2.5*log10((1-G).*phi1+G.*phi2);
control_geo=strmatch('500',observador.cod);
control_geo=isempty(control_geo);
%correccion por paralaje
if control_geo==1
[ARp DEp]=correcparal(AR(:,1),DE(:,1),Delta(:,1),JD,observador.Longitude,observador.pcos,observador.psin);
AR(:,1)=ARp;
DE(:,1)=DEp;
[ARp DEp]=correcparal(AR(:,2),DE(:,2),Delta(:,2),JD+1/(24*60),observador.Longitude,observador.pcos,observador.psin);
AR(:,2)=ARp;
DE(:,2)=DEp;
end

%movimiento
[motion1, PA]=motion(AR(:,1),DE(:,1),AR(:,2),DE(:,2));
tiempo_expo_max=observador.res*motion1.^(-1)*60;
waitbar(2/10);



%Extrayendo clase
[claseb, isneo]=traducir_clase(clase);
waitbar(3/10);
%ultima observacion
[AAAA,MM,DD]=jul2gre(ultobs);

%armando matriz de resultados;
signosaux=sign(DE(:,1));
signosmas=find(signosaux==1 | signosaux==0);
signosmenos=find(signosaux==-1);
signos(signosmas)='+';
signos(signosmenos)='-';
clear signosaux signosmas signosmenos
pos=[degree2dms(AR(:,1)),...
    degree2dms(DE(:,1)),...
    mag1,...
    Delta(:,1),...
    motion1,...
    PA,...
    tiempo_expo_max,...
    diametro,...
    elong_solar,...
    elong_lunar,...
    [AAAA MM DD],...
    nroops,...
    arc_obs,...
    tj];
waitbar(5/10)


long_muestra=length(signos);
muestra=[designacion(:,1:28)...%nombre
    ,repmat('\t%02.0f %02.0f %05.2f  \t ',[long_muestra,1])...%AR
    ,signos'...
    ,repmat('%02.0f %02.0f %05.2f\t',[long_muestra,1])...%DE
    ,repmat('  %5.2f\t',[long_muestra,1])...%mag
    ,repmat('  %7.4f\t',[long_muestra,1])...%Delta
    ,repmat('  %8.3f\t',[long_muestra,1])...%Motion
    ,repmat('  %8.4f\t',[long_muestra,1])...%PA
    ,repmat('  %6.0f\t',[long_muestra,1])...%Tiempo max
    ,repmat('  %7.0f\t  ',[long_muestra,1])...%diametro
    ,U...%U
    ,repmat('  %4.0f\t',[long_muestra,1])...%elong solar
    ,repmat('  %4.0f    ',[long_muestra,1])...%elong lunar
    ,claseb...%clase
    ,repmat('  \t',[long_muestra,1])...
    ,repmat('  %5.0f/%02.0f/%02.0f\t',[long_muestra,1])...%ultima obs
    ,repmat('  %4.0f\t',[long_muestra,1])...%numero opsiciones 
    ,repmat('  %6.0f\t',[long_muestra,1])...%arco
     ,repmat('  %6.3f\t',[long_muestra,1])...%tisserand
      ,repmat('\n',[long_muestra,1])...%fin
      ];

texto_resultados=sprintf(muestra',pos');
clc

    
    
    fprintf('%s\n','Lista de Objetos');
        fprintf('%s%7.4f%s%7.4f\n','Intervalo de declinaciones:  ',DE1,' y ',DE2);
    hh=(Dia-floor(Dia))*24;
    mm=(hh-floor(hh))*60;

    fprintf('%s%6.0f%s%02.0f%s%02.0f%s%02.0f%s%02.0f\n','Fecha (UT): ',Anio,'/' ,Mes,'/', floor(Dia),'  ',floor(hh),':',floor(mm));
    fprintf('%s%5.2f\n','Magnitud l�mite:', mag);
    fprintf('%s%4.1f%s\n','Elongaci�n solar m�nima : ', elong_solarlim, ' grados.');
    fprintf( '%s%s%s%s\n','Posiciones respecto al observatorio:  MPC  ', observador.cod,', ', observador.name_obs);
    fprintf( '%s%4.2f%s\n','Tiempo m�ximo de exposici�n calculado para una resoluci�n de: ', observador.res,' arco seg/pixel');
    fprintf('%s %7.0f\n','Cantidad de cuerpos:',length(Indices));
    fprintf( '%s\n','Planilla generada por <a href="http://astrosurf.com/salvador/Programas.html"> orbit_calc</a> ');
    disp('========================================================================================================================================================================================================================')



disp('Numeracion-Designacion              AR               DE            Mag.    Delta         "/min     P.A.         T. Max      Diam.     U   E.Sol  E.Luna   Clase                Ult. Obs.        #Opos.   Arco      T_j')
disp('========================================================================================================================================================================================================================')

disp(texto_resultados);
varargout{1}=size(muestra,1);



close(progreso);
if is_html==1;
    clear muestra;
    for j=1:length(Indices);
        if isneo(j)==1
          muestra(j,:)=['<tr><td nowrap><input type="checkbox" name="Obj" value="',nombres(j,1:7),'" checked >',... %link mpc
              '  <a href="http://newton.dm.unipi.it/neodys/index.php?pc=1.1.0&n=',designacion(j,9:28),'">',designacion(j,1:28),'</a></td>',... %link neodys
              '<td align="center" nowrap> \t%02.0f %02.0f %05.2f \t </td>',...%AR
              '<td align="center" nowrap> ', signos(j),' %02.0f %02.0f\t%05.2f </td>',... %DE
              '\t <td align="center" nowrap> %5.2f </td>',... %mag
              '\t<td align="center" nowrap>%7.4f </td>\t',... %Delta
              '<td align="center" nowrap> %9.4f </td>',... %Motion
              '<td align="center" nowrap> %8.4f </td>',... %PA
              '\t<td align="center" nowrap> %6.0f </td>',...%Tiempo max
              '\t<td align="center" nowrap> %5.0f</td>\t',...%diametro
              '<td align="center" nowrap>',U(j), '</td> ',...%U
              '<td align="center" nowrap>%4.0f </td> ',...%elong solar
              '<td align="center" nowrap>%4.0f </td> ',...%elong moon
              ' <td align="center" nowrap>  ', claseb(j,:),'</td>',...%class
              '<td align="left" nowrap>%5.0f/%02.0f/%02.0f</td> ',...%last obs
              '<td align="center" nowrap>%4.0f </td> ',...%number opos.
              '<td align="center" nowrap>%6.0f </td> ',...%obs arco.
              '<td align="center" nowrap>%6.3f </td> ',...%tisserand jupiter parameter
               '</tr>','\n'];
        else
         muestra(j,:)=['<tr><td nowrap><input type="checkbox" name="Obj" value="',nombres(j,1:7),'" checked >',... %link mpc
              '<a href="http://hamilton.dm.unipi.it/astdys/index.php?pc=1.1.0&n=',designacion(j,9:28),'">',designacion(j,1:28),'</a></td>',... %link neodys
              '<td align="center" nowrap> \t%02.0f %02.0f %05.2f \t </td>',...%AR
              '<td align="center" nowrap> ', signos(j),' %02.0f %02.0f\t%05.2f </td>',... %DE
              '\t <td align="center" nowrap> %5.2f </td>',... %mag
              '\t<td align="center" nowrap>%7.4f </td>\t',... %Delta
              '<td align="center" nowrap> %9.4f </td>',... %Motion
              '<td align="center" nowrap> %8.4f </td>',... %PA
              '\t<td align="center" nowrap> %6.0f </td>',...%Tiempo max
              '\t<td align="center" nowrap> %5.0f</td>\t',...%diametro
              '<td align="center" nowrap>',U(j),'</td> ',...%U
              '<td align="center" nowrap>%4.0f </td> ',...%elong solar
              '<td align="center" nowrap>%4.0f </td> ',...%elong moon
              ' <td align="center" nowrap>  ', claseb(j,:),'</td>',...%class
              '<td align="left" nowrap>%5.0f/%02.0f/%02.0f</td> ',...%last obs
              '<td align="center" nowrap>%4.0f </td> ',...%number opos.
              '<td align="center" nowrap>%6.0f </td> ',...%obs arco.
              '<td align="center" nowrap>%6.3f </td> ',...%tisserand jupiter parameter
               '</tr>','\n'];
        end
    end
  
    webcount=fopen('busqueda.html','w');
    fprintf(webcount,'%s\n','<html>');
    fprintf(webcount,'%s\n','<FORM METHOD=POST ACTION="http://scully.harvard.edu/~cgi/MPEph.COM" TARGET="_NEW"><pre>');



    fprintf(webcount,'%s\n','<title>Tabla</title>');
    fprintf(webcount,'%s\n','<body bgcolor="#E0F8F7">');
    fprintf(webcount,'%s\n','<center><p style="font-family: impact;font-size:30pt">Lista de Objetos</center>');
    fprintf(webcount,'%s','<p style="font-family: times, serif; font-size:14pt; font-style:italic">');
    fprintf(webcount,'%s%7.4f%s%7.4f%s\n','Intervalo de declinaciones: <font color=#DF0174,style=normal>: ',DE1,' y ',DE2,'</font>');
    hh=(Dia-floor(Dia))*24;
    mm=(hh-floor(hh))*60;

    fprintf(webcount,'%s%6.0f%s%02.0f%s%02.0f%s%02.0f%s%02.0f\n','Fecha (UT): <font color=#DF0174,style=normal>',Anio,'/' ,Mes,'/', floor(Dia),'  ',floor(hh),':',floor(mm),'</font>');
    fprintf(webcount,'%s%5.2f%s\n','Magnitud l&iacute;mite:<font color=#DF0174,style=normal>', mag,'</font>');
    fprintf(webcount,'%s%4.1f%s\n','Elongaci&oacute;n solar m&iacute;nima : <font color=#DF0174,style=normal> ', elong_solarlim, ' grados.</font>');
    fprintf(webcount, '%s%s%s%s%s\n','Posiciones respecto al observatorio: <font color=#DF0174,style=normal> MPC  ', observador.cod,', ', observador.name_obs,' </font>');
    fprintf(webcount, '%s%4.2f%s\n','Tiempo m&aacute;ximo de exposici&oacute;n calculado para una resoluci&oacute;n de:<font color=#DF0174,style=normal> ', observador.res,' arco seg/pixel</font>');
    fprintf(webcount,'%s %7.0f%s\n','Cantidad de cuerpos:<font color=#DF0174,style=normal> ',length(Indices),'</font>');
    fprintf(webcount, '%s%4.2f%s\n','Planilla generada por <a href="http://astrosurf.com/salvador/Programas.html"> orbit_calc</a> </font>');


    fprintf(webcount,'%s','</p>');

    fprintf(webcount,'%s\n','<P>');
    fprintf(webcount,'%s\n','<center>');
    fprintf(webcount,'%s\n','<table border="1" cellpadding="5" cellspacing="0" bgcolor="#FFFFFF">');
    fprintf(webcount,'%s\n','<tr valign="bottom" bgcolor="#CCCCCC"> ');
        fprintf(webcount,'%s\n','<td nowrap> Asteroide </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>AR </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap> DE </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap> Mag.</td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>Delta </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap> "/min </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap> P.A.</td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>T. max(s)</td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap> diam.(m) </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>U </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>E. Solar </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>E. Lunar </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap> Clase </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>Ult. Obs. </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap># opos. </td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>arco(d)</td>');
        fprintf(webcount,'%s\n','<td align="center" nowrap>T_j </td>');
    fprintf(webcount,'%s\n','</tr> ');
    fprintf(webcount,muestra', pos');
    fprintf(webcount,'%s\n','</table>');
    fprintf(webcount,'%s\n','</center>');
    fprintf(webcount,'%s\n','<center><input type=submit value=" Efem&eacute;rides/&oacute;rbitas "> <input type=reset value=" Limpiar forma "><p></center>');
    fprintf(webcount,'%s\n','<p><hr><p>');
    fprintf(webcount,'%s\n','<center>');
    fprintf(webcount,'%s\n','Opciones:');
    fprintf(webcount,'%s\n','<p>Comienzo efemerides: <input name="d" maxlength=20 size=17 VALUE="',[num2str(Anio),' ',num2str(Mes),' ',num2str(floor(Dia))],'">  N&uacute;mero de &eacute;pocas en efem&eacute;rides <input name="l" maxlength=4 size=4 VALUE="24">');
    fprintf(webcount,'%s\n','<p>Separacion de epocas: <input name="i" maxlength=3 size=3 VALUE="1"> ');
    fprintf(webcount,'%s\n','Unidades');
    fprintf(webcount,'%s\n','<input type="radio" name="u" value="d"> d&iacute;as  <input type="radio" name="u" value="h" CHECKED> horas <input type="radio" name="u" value="m" > min.');
    fprintf(webcount,'%s\n','<input type="radio" name="u" value="s"> seg');
    fprintf(webcount,'%s\n','<p><a href="http://cfa-www.harvard.edu/iau/lists/ObsCodes.html">C&oacute;digo de observatorio </a>: <input name="c" maxlength=3 size=3 VALUE="',observador.cod,'">');
    fprintf(webcount,'%s\n','<p>Mostrar posiciones R.A./Decl. como: <input type="radio" name="raty" value="h">Sexagesimal truncado ');
    fprintf(webcount,'%s\n','<input type="radio" name="raty" value="a" CHECKED>Sexagesimal ');
    fprintf(webcount,'%s\n','<input type="radio" name="raty" value="d"> Unidades decimales  ');
    fprintf(webcount,'%s\n','<p>Mostrar movimientos como:  <input type="radio" name="m" VALUE="s"> "/seg  <input type="radio" name="m" VALUE="m" CHECKED> "/min  <input type="radio" name="m"');
    fprintf(webcount,'%s\n','VALUE="h"> "/hr  <input type="radio" name="m" VALUE="d"> "/day');
    fprintf(webcount,'%s\n','<p><input type="radio" name="s" VALUE="t" CHECKED> Movimiento total y direcci&oacute;n');
    fprintf(webcount,'%s\n','  <input type="radio" name="s" VALUE="s"> Separar movimiento en AR y DE ');
    fprintf(webcount,'%s\n','<p><input type="checkbox" name="igd" value="y" > Suprimir la salida si el sol est&aacute; arriba del horizonte local');
    fprintf(webcount,'%s\n','<p><input type="checkbox" name="ibh" value="y" > Suprimir la salida si el objeto est&aacute; debajo del horizonte local');
    fprintf(webcount,'%s\n','<p><input type="checkbox" name="fp" value="y"> Generar efem&eacute;rides perturbadas para &oacute;rbitas imperturbadas ');
    fprintf(webcount,'%s\n','<p>Mostrar elementos keplerianos para la &eacute;poca <input name="oed" maxlength=20 size=17 VALUE="">');
    fprintf(webcount,'%s\n','<p>');
    fprintf(webcount,'%s\n','<table border="0" cellpadding="5" cellspacing="0" width="100%">');
    fprintf(webcount,'%s\n','<tr>');
    fprintf(webcount,'%s\n','<td width="33%"><input type="radio" name="e" VALUE="-2"> Ninguno</td>');
    fprintf(webcount,'%s\n','<td width="33%"><input type="radio" name="e" VALUE="-1"> MPC 1-l&iacute;nea</td>');
    fprintf(webcount,'%s\n','<td width="33%"><input type="radio" name="e" VALUE="0" CHECKED> MPC 8-líneas</td>');
    fprintf(webcount,'%s\n','</tr><tr><td width="33%"><input type="radio" name="e" VALUE="1"> SkyMap (SkyMap Software)</td><td width="33%"><input type="radio" name="e" VALUE="2"> Guide');
    fprintf(webcount,'%s\n','(Project Pluto)</td><td width="33%"><input type="radio" name="e" VALUE="12"> MegaStar V4.x (E.L.B. Software)</td></tr><tr><td width="33%"><input type="radio"');
    fprintf(webcount,'%s\n','name="e" VALUE="6"> Carts du Ciel</TD>');
    fprintf(webcount,'%s\n','</tr>');
    fprintf(webcount,'%s\n','</table>');
    fprintf(webcount,'%s\n',' </center>');
    fprintf(webcount,'%s\n','<p>');
    fprintf(webcount,'%s\n','Si eliges el formato MPC 8-l&iacute;neas tambi�n puedes mostrar los bloques de residuos para los objetos seleccionados: ');
    fprintf(webcount,'%s\n','<p>');
    fprintf(webcount,'%s\n','<input type="checkbox" name="res" VALUE="y" > Mostrar los bloques de residuos. Mostrar los bloques de residuos para observaciones del observatorio c&oacute;digo  <input type="input" name="resoc" size=3 maxlength=3 VALUE="">.');
    fprintf(webcount,'%s\n','<p>');
    fprintf(webcount,'%s\n','<center><input type=submit value=" Efem&eacute;rides/&oacute;rbitas "> <input type=reset value=" Limpiar forma "><p></center>');
    fprintf(webcount,'%s\n','<p><hr><p>');
    fprintf(webcount,'%s\n','</html>');
    fclose(webcount);
    if ~is_silent
        switch true
            case ispc
                winopen('busqueda.html')
            case isunix
                web('busqueda.html')
        end
    end
end








function [AR,DE,Delta,r,x,y,z]=kepler_solucion(t,epoca,M,peri,e,n,a,A1,B1,C1,a1,b1,c1,xsol,ysol,zsol,tol)
    M1=M+n.*(t-epoca);
    E=solkepler1(M1,e,tol);
    v=2*atand(sqrt((1+e)./(1-e)).*tand(E/2));
    k=floor(v/360);
    v=v-k*360;
    r=a.*(1.-e.*cosd(E));
    x=r.*(a1.*sind(A1+peri+v))+xsol;
    y=r.*(b1.*sind(B1+peri+v))+ysol;
    z=r.*(c1.*sind(C1+peri+v))+zsol;
    Delta=sqrt(sum([x, y, z].^2,2));
    AR=atan2(y,x);
    k=floor(AR/(2*pi));
    AR=(AR-k*2*pi)*12/pi;
    DE=asind(z./Delta);
    Delta=sqrt(sum([x, y, z].^2,2));

function [claseb, isneo]=traducir_clase(clase)
    is_main_belt=strmatch('00',clase(:,3:4));
    is_aten=strmatch('02',clase(:,3:4));
    is_apolo=strmatch('03',clase(:,3:4));
    is_amor=strmatch('04',clase(:,3:4));
    is_mars1=strmatch('05',clase(:,3:4));
    is_hung=strmatch('06',clase(:,3:4));
    is_phoc=strmatch('07',clase(:,3:4));
    is_hilda=strmatch('08',clase(:,3:4));
    is_troyan=strmatch('09',clase(:,3:4));
    is_centaur=strmatch('0A',clase(:,3:4));
    is_plutino=strmatch('0E',clase(:,3:4));
    is_otros=strmatch('0F',clase(:,3:4));
    is_cube=strmatch('10',clase(:,3:4));
    is_disper=strmatch('11',clase(:,3:4));
    is_pha=strmatch('8',clase(:,1));
    isneo=strmatch('8',clase(:,2));
    claseb=repmat('            ',[size(clase,1),1]);
    if ~isempty(is_main_belt);
        claseb(is_main_belt,:)=repmat('Cint. Pr.   ',[length(is_main_belt),1]);
    end
    if ~isempty(is_aten);
        claseb(is_aten,:)=repmat('Aten        ',[length(is_aten),1]);
    end
    if ~isempty(is_apolo);
        claseb(is_apolo,:)=repmat('Apolo       ',[length(is_apolo),1]);
    end
    if ~isempty(is_amor);
        claseb(is_amor,:)=repmat('Amor        ',[length(is_amor),1]);
    end
    if ~isempty(is_mars1);
         claseb(is_mars1,:)=repmat('q<1.665     ',[length(is_mars1),1]);
    end
    if ~isempty(is_hung);
         claseb(is_hung,:)=repmat('Hungaria    ',[length(is_hung),1]);
    end
    if ~isempty(is_phoc);
         claseb(is_phoc,:)=repmat('Phocaea     ',[length(is_phoc),1]);
    end
        
    if ~isempty(is_hilda);
        claseb(is_hilda,:)=repmat('Hilda       ',[length(is_hilda),1]);
    end
    if ~isempty(is_troyan);
        claseb(is_troyan,:)=repmat('Jup. Troyan ',[length(is_troyan),1]);
    end
    if ~isempty(is_centaur);
        claseb(is_centaur,:)=repmat('Centaur     ',[length(is_centaur),1]);
    end
    if ~isempty(is_plutino);
        claseb(is_plutino,:)=repmat('Plutino     ',[length(is_plutino),1]);
    end
    if ~isempty(is_otros);
        claseb(is_otros,:)=repmat('Other TNO   ',[length(is_otros),1]);
    end
    if ~isempty(is_cube);
        claseb(is_cube,:)=repmat('Cubewano    ',[length(is_cube),1]); 
    end
    if isempty(is_disper)==0;
        claseb(is_disper,:)=repmat('Disp. Disk  ',[length(is_disper),1]); 
    end
    if ~isempty(is_pha);
        claseb(is_pha,:)=repmat('PHA         ',[length(is_pha),1]); 
    end
    Arreglo=false([size(clase,1),1]);
    Arreglo(isneo)=true
    isneo=Arreglo;
    
