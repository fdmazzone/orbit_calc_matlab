function [GM1,funcion_datos_sol,funcion_datos,posicion_ini,velocidad_ini,Jini]= sistema(cantidad_no_graves,varargin);
    
%%=============Posiciones y velocidades del sistema solar 1/1/2010===============
%%=Descripcion de la tabla
%%fila1:  epoca de la posici�n  completada a 6 columnas con ceros
%%fila2:mercurio
%%fila3:venus
%%fila4:tierra
%%fila5:luna
%%fila6:marte
%%fila7:jupiter
%%fila8:saturno
%%fila9:urano
%%fila10:neptuno
%%Datos extra�dos del Horizons JPL.
Jini=2456658.500000000 ;

posicion_ini=[1.207138059004780E-01 -4.365387430471273E-01 -4.656000296377556E-02...
              -4.889511788031933E-02  7.153265590363882E-01  1.261878164617234E-02...
             -1.746041985269436E-01  9.652755962354420E-01 -1.250716210353621E-04...
              -1.744550383424625E-01  9.628959708420888E-01  5.413634158577353E-05...
              -1.511451883723592E+00  6.945376382034075E-01  5.163099338957033E-02...
              -1.329810981509550E+00  5.016448283283742E+00  8.842369943464833E-03...
               -6.884203987934420E+00 -7.077755279209902E+00  3.970419929309678E-01...
               1.964599789584507E+01  3.920321937557051E+00 -2.399614066328041E-01...
                2.706443567654644E+01 -1.289413579129899E+01 -3.581970681231710E-01...
               6.257763030018006E+00 -3.192714660507040E+01  1.606288229467699E+00];



velocidad_ini=[ 2.148807180306500E-02  8.914250181959474E-03 -1.242939299365231E-03...
               -2.024042414890060E-02 -1.509141126076930E-03  1.147617329924402E-03...
               -1.720953677535424E-02 -3.134828358254410E-03 -3.741456402647257E-07...
               -1.657672781852536E-02 -3.081274583332751E-03  2.811555939833643E-05...
                -5.324872988676527E-03 -1.151220877060322E-02 -1.105462375644424E-04...
                 -7.385865467528752E-03 -1.575928145768227E-03  1.718226097102392E-04...
                3.695269638360193E-03 -3.904117171067821E-03 -7.917340067068690E-05...
                -7.984163751815460E-04  3.673731707295850E-03  2.399277992596198E-05...
                1.329295675647315E-03  2.852560246529022E-03 -8.937817157515599E-05...
                3.141412451173409E-03 -2.971840197673849E-05 -9.055025970043045E-04];


%% valores de GM 
%% Factores de conversi�n desde el jpl 
%UA=149597870.691;
%dia=86400;
%%  GM en km^3 s^(-2)
% G=6.672e-20;


     
    
 
gauss_cte=.01720209895^2;

GMS=gauss_cte;
GMmer=GMS/6023600;
GMven=GMS/408523.71;
GMSB=328900.5614;
GMem=81.30056;
GMtie=GMSB^(-1)*(1+GMem^(-1)).^(-1)*GMS;
GMlun=GMSB^(-1)*(1+GMem).^(-1)*GMS;
GMmar=GMS/3098708;
GMjup=GMS/1047.3486;
GMsat=GMS/3497.898;
GMura=GMS/22902.98;
GMnep=GMS/19412.24;
GMpluton=GMS/135200000;


GM1=[GMS,GMmer,GMven,GMtie,GMlun,GMmar,GMjup,GMsat,GMura,GMnep,GMpluton];


if nargin>1
    I=varargin{1};
    J=repshape([3*I-2;3*I-1;3*I],[1,3*length(I)]);
    posicion_ini=posicion_ini(J);
    velocidad_ini=velocidad_ini(J)
    GM1=GM1(I);
end








%%%% Definicion de parametros del sistema para la funcion fuerza
funcion_datos.cantidad_planetas=length(GM1)-1;
funcion_datos_sol.cantidad_planetas=funcion_datos.cantidad_planetas;
cantidad_cuerpos=funcion_datos.cantidad_planetas+cantidad_no_graves;


I=1:1:funcion_datos.cantidad_planetas+1;
funcion_datos.indices=nchoosek(I,2);
funcion_datos_sol.indices=funcion_datos.indices;


funcion_datos.Indicador=[];
for indi=2:funcion_datos.cantidad_planetas+1
    Iaux=find(funcion_datos.indices(:,1)==indi);
    Jaux=find(funcion_datos.indices(:,2)==indi);
    funcion_datos.Indicador=[funcion_datos.Indicador,[Jaux',Iaux']];
end
funcion_datos_sol.Indicador=funcion_datos.Indicador;

I=funcion_datos.cantidad_planetas+2:1:cantidad_cuerpos+1;

I=repmat(I,[funcion_datos.cantidad_planetas+1,1]);
I=reshape(I,[(funcion_datos.cantidad_planetas+1)*cantidad_no_graves,1]);
J=(1:1:funcion_datos.cantidad_planetas+1)';
J=repmat(J,[cantidad_no_graves,1]);
funcion_datos.indices=[funcion_datos.indices;[I,J]];

for indi=funcion_datos.cantidad_planetas+2:cantidad_cuerpos+1;
    Iaux=find(funcion_datos.indices(:,1)==indi);
    Jaux=find(funcion_datos.indices(:,2)==indi);
    funcion_datos.Indicador=[funcion_datos.Indicador,[Jaux',Iaux']];
end
    



funcion_datos.GM=zeros(cantidad_cuerpos,funcion_datos.cantidad_planetas^2+cantidad_no_graves*(funcion_datos.cantidad_planetas+1));
columna=1;
for j=1:funcion_datos.cantidad_planetas-1
    funcion_datos.GM(j,columna:columna+funcion_datos.cantidad_planetas-1)=[-GM1(1:j),GM1(j+2:end)];
    columna=columna+funcion_datos.cantidad_planetas;
end
funcion_datos.GM(funcion_datos.cantidad_planetas,columna:columna+funcion_datos.cantidad_planetas-1)=-GM1(1:end-1);
columna=columna+funcion_datos.cantidad_planetas;

for j=funcion_datos.cantidad_planetas+1:cantidad_cuerpos
    funcion_datos.GM(j,columna:columna+funcion_datos.cantidad_planetas)=GM1;
    columna=columna+funcion_datos.cantidad_planetas+1;
end
funcion_datos_sol.GM=funcion_datos.GM(1:funcion_datos.cantidad_planetas,1:funcion_datos.cantidad_planetas^2);


funcion_datos.GM=sparse(funcion_datos.GM);
funcion_datos_sol.GM=sparse(funcion_datos_sol.GM);


