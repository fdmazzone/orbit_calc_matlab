% function [pos_helio, vel_helio]=orbit_calc_simulador(archivo,efemerides_epocas);
% function orbit_calc_simulador(archivo,efemerides_epocas);
function simulacion_sistema_solar_ext
%%%%%%%%%%%Configuracion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load(archivo);
tic



funcion=@fuerza_nb;


%%%Colocacion
% Integrador=@colocacion_nb_adap; 
% parametros_Integrador.orden=12;
% parametros_Integrador.paso=.3;
% parametros_Integrador.tol=1e-21;
% parametros_Integrador.orden=12;
% parametros_Integrador.iter=2;

%%multipaso
Integrador=@multipaso_nb_implicito;
parametros_Integrador.paso=15;
parametros_Integrador.orden=12;
cantidad_cuerpos_menores=0;



PasoEpoc=10*365;
CantEpocPaso=10000;
LimGuardar=500;
PasoTot=LimGuardar*CantEpocPaso;







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%====================================================
[~,funcion_datos_sol,~,~,~,~]= sistema_exterior(0);
    



%cantidad_cuerpos=funcion_datos.cantidad_planetas+cantidad_cuerpos_menores; 

load('00144.mat');
posicion_ini=pos(end,:);
velocidad_ini=vel(end,:);
Jini=epocas(end);
efemerides_epocas=Jini+(0:PasoEpoc:PasoEpoc*PasoTot-1);
efemerides_epocas=reshape(efemerides_epocas,[CantEpocPaso,LimGuardar]);

clear pos vel epocas

%     posicion_ini=pos(end,1:end-3);
%     velocidad_ini=vel(end,1:end-3);
%     Jini=epocas(end);
%     clear pos vel epocas;
%%integrar el sistema solar hasta la epoca de los elementos del cuerpo
%parametros_Integrador.mensaje='Integrando sistema solar...';

%A los 25 millones de años empecé sin pluton
IndBloque=145;


for j=1:LimGuardar;


    [pos,vel]=Integrador(funcion,funcion_datos_sol,efemerides_epocas(:,j),posicion_ini,velocidad_ini,Jini,parametros_Integrador);
    

    
    NombreBloque=num2str(IndBloque);
    Falta0=5-length(NombreBloque);
    NombreBloque=[repmat('0',[1,Falta0]),NombreBloque,'.mat'];
    epocas=efemerides_epocas(:,j);
    save(NombreBloque,'pos','vel','epocas');
    IndBloque=IndBloque+1;
    posicion_ini=pos(end,:);
    velocidad_ini=vel(end,:);
    Jini=efemerides_epocas(end,j); 
    mensaje=sprintf('Proceso Global: %3.0f', 100*j/LimGuardar);
    clc;disp(mensaje);
end


toc



%%==========Convertir coordenadas a baricèntricas

% [pos0,posdot0]=helio2bari(pos,posdot0,pos,vel,GM1);
% pos=[pos,pos0];
% vel=[vel,posdot0];
