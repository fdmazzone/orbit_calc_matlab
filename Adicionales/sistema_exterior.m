function [GM1,funcion_datos_sol,funcion_datos,posicion_ini,velocidad_ini,Jini]= sistema_exterior(cantidad_no_graves,varargin);
    
%%=============Posiciones y velocidades del sistema solar 1/1/2010===============
%%=Descripcion de la tabla
%%fila1:  epoca de la posición  completada a 6 columnas con ceros
%%fila2:mercurio
%%fila3:venus
%%fila4:tierra
%%fila5:luna
%%fila6:marte
%%fila7:jupiter
%%fila8:saturno
%%fila9:urano
%%fila10:neptuno
%%Datos extraídos del Horizons JPL.
Jini=2455197.5 ;

posicion_ini=[  4.505316448014699E+00 -2.163554992150158E+00 -9.190506642404675E-02...
               -9.468002747491772E+00  2.616170194615976E-01  3.722137409934489E-01...
                2.003287142254730E+01 -1.529789587584767E+00 -2.652228371169991E-01...
                2.481342071982337E+01 -1.689466771579366E+01 -2.239283359739457E-01...
                1.624023439973141E+00 -3.158449831325791E+01  2.909973245858946E+00];



velocidad_ini=[ 3.174272294118944E-03  7.161028472593621E-03 -1.007932634913023E-04...
                -4.520982009246061E-04 -5.588245900866611E-03  1.148907610664285E-04...
                2.708536832422564E-04  3.738296124910372E-03  1.043945945010953E-05...
                1.746290591932061E-03  2.613664871606340E-03 -9.397396369692273E-05...
                3.201285843237125E-03 -4.334750109871883E-04 -8.749408645446409E-04];


%% valores de GM 
%% Factores de conversión desde el jpl 
%UA=149597870.691;
%dia=86400;
%%  GM en km^3 s^(-2)
% G=6.672e-20;


     
    
 
gauss_cte=.01720209895^2;

GMS=gauss_cte;
% GMmer=GMS/6023600;
% GMven=GMS/408523.71;
% GMSB=328900.5614;
% GMem=81.30056;
% GMtie=GMSB^(-1)*(1+GMem^(-1)).^(-1)*GMS;
% GMlun=GMSB^(-1)*(1+GMem).^(-1)*GMS;
% GMmar=GMS/3098708;
GMjup=GMS/1047.3486;
GMsat=GMS/3497.898;
GMura=GMS/22902.98;
GMnep=GMS/19412.24;
GMpluton=GMS/135200000;


GM1=[GMS,GMjup,GMsat,GMura,GMnep,GMpluton];


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


