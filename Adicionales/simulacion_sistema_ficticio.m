% function [pos_helio, vel_helio]=orbit_calc_simulador(archivo,efemerides_epocas);
% function orbit_calc_simulador(archivo,efemerides_epocas);
function [pos,vel]=simulacion_sistema_ficticio(efemerides_epocas,posicion_ini,GM)
%%%%%%%%%%%Configuracion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load(archivo);



funcion=@fuerza_nb;


%%%Colocacion
Integrador=@colocacion_nb_adap; 
parametros_Integrador.orden=12;
parametros_Integrador.paso=.0001;
parametros_Integrador.tol=1e-19;
parametros_Integrador.orden=10;
parametros_Integrador.iter=2;

%%multipaso
% Integrador=@multipaso_nb_implicito;
% parametros_Integrador.paso=.01;
% parametros_Integrador.orden=12;
% cantidad_cuerpos_menores=0;

parametros_Integrador.mensaje='Integrando';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%====================================================
[~,funcion_datos_sol,~]= sistema_ficticio(GM,0);

Jini=efemerides_epocas(1);



A=reshape(posicion_ini',[3,length(GM)-2]);
A=A([2 1 3],:);
A(1,:)=-A(1,:);
velocidad_ini=.75*A(:)';
posicion_ini=[posicion_ini,[0,0,0]];
velocidad_ini=[velocidad_ini,[0 0 1]];

%posicion_ini=[5 0 0 10 0 0];
%velocidad_ini=[0 .005  0 0 .00005  0];
% efemerides_epocas=Jini+(0:1:3600)';
[pos,vel]=Integrador(funcion,funcion_datos_sol,efemerides_epocas,posicion_ini,velocidad_ini,Jini,parametros_Integrador);
pos=pos';
l3=length(efemerides_epocas);
l2=funcion_datos_sol.cantidad_planetas;
q=reshape(pos,[3,l2,l3]);
pos=permute(q,[2 1 3]);
M=repmat(GM(2:end)',[1,3,l3]);
pos=cat(1,-sum(M.*pos,1)/GM(1),pos);

vel=vel';
l3=length(efemerides_epocas);
l2=funcion_datos_sol.cantidad_planetas;
q=reshape(vel,[3,l2,l3]);
vel=permute(q,[2 1 3]);
vel=cat(1,-sum(M.*vel,1)/GM(1),vel);

%%==========Convertir coordenadas a baric�ntricas

% [pos0,posdot0]=helio2bari(pos,posdot0,pos,vel,GM1);
% pos=[pos,pos0];
% vel=[vel,posdot0];
