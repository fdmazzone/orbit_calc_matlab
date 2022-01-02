function [GM1,funcion_datos_sol,funcion_datos]= sistema_exterior(GM1,cantidad_no_graves,varargin);
    
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
% Jini=0;

% posicion_ini=[  4.505316448014699E+00 -2.163554992150158E+00 -9.190506642404675E-02...
%                -9.468002747491772E+00  2.616170194615976E-01  3.722137409934489E-01...
%                ];%...
% %                1.624023439973141E+00 -3.158449831325791E+01  2.909973245858946E+00];



% velocidad_ini=[ 3.174272294118944E-03  7.161028472593621E-03 -1.007932634913023E-04...
%                 -4.520982009246061E-04 -5.588245900866611E-03  1.148907610664285E-04...
%                 ];%...
%      %           3.201285843237125E-03 -4.334750109871883E-04 -8.749408645446409E-04];


%% valores de GM 
%% Factores de conversi�n desde el jpl 
%UA=149597870.691;
%dia=86400;
%%  GM en km^3 s^(-2)
% G=6.672e-20;


     
    
 
% gauss_cte=.01720209895^2;
% 
% GMS=gauss_cte;
% % GMmer=GMS/6023600;
% % GMven=GMS/408523.71;
% % GMSB=328900.5614;
% % GMem=81.30056;
% % GMtie=GMSB^(-1)*(1+GMem^(-1)).^(-1)*GMS;
% % GMlun=GMSB^(-1)*(1+GMem).^(-1)*GMS;
% % GMmar=GMS/3098708;
% GMjup=GMS/1047.3486;
% GMsat=GMS/3497.898;
% GMura=GMS/22902.98;
% GMnep=GMS/19412.24;
% %GMpluton=GMS/135200000;


%GM1=[GMS,GMjup,GMsat];%,GMpluton];
% GM1=[
%     0.2760
%     0.6797
%     0.6551
%     0.1626
%     0.1190
%     0.4984
%     0.9597
%     0.3404
%     0.5853
%     0.2238]';
% posicion_ini=[
%         0.0788028192426359
%           -1.9989533074421
%                          0
%          -0.94942683118274
%           1.53849114749876
%                          0
%           1.39488829316884
%          -0.27248310888722
%                          0
%           1.76406510450023
%          -0.34327214474936
%                          0
%         -0.186583789281231
%         -0.716887859163287
%                          0
%          0.850195482557013
%            1.9621961593003
%                          0
%          -1.17260439085948
%         -0.235100856445353
%                          0
%        -0.0297012249389953
%          0.404421123109666
%                          0
%          -1.67346686096622
%         -0.332184635036815
%                          0
% ]';
     
% A=reshape(posicion_ini',[3,length(GM1)-1]);
% A=A([2 1 3],:);
% A(1,:)=-A(1,:);
% velocidad_ini=.25*A(:)';



if nargin>2
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