% function [pos_helio, vel_helio]=orbit_calc_simulador(archivo,efemerides_epocas);
% function orbit_calc_simulador(archivo,efemerides_epocas);
function [pos,vel]=simulacion_sistema_solar(efemerides_epocas);
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
parametros_Integrador.paso=2;
parametros_Integrador.orden=12;
cantidad_cuerpos_menores=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%====================================================
[GM1,funcion_datos_sol,funcion_datos,posicion_ini,velocidad_ini,Jini]= sistema(cantidad_cuerpos_menores);
cantidad_cuerpos=funcion_datos.cantidad_planetas+cantidad_cuerpos_menores; 

%%integrar el sistema solar hasta la epoca de los elementos del cuerpo
parametros_Integrador.mensaje='Integrando sistema solar...';
[pos,vel]=Integrador(funcion,funcion_datos_sol,efemerides_epocas,posicion_ini,velocidad_ini,Jini,parametros_Integrador);
toc



%%==========Convertir coordenadas a baricèntricas

% [pos0,posdot0]=helio2bari(pos,posdot0,pos,vel,GM1);
% pos=[pos,pos0];
% vel=[vel,posdot0];
