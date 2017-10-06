function orbit_calc_simulador_resume(archivo,cantidad_planetas,IndBloque,PasoEpoc,CantEpocPaso,cantidad_epocas);
%%archico =archivo de elementos keplerianos compatible con orbit_calc
%%PasoEpoc=long de un paso
%%CantEpocPaso =cuantas epocas entran en cada subarchivo
%%cantidad_epocas=cantidad total de epocas
%%%%%%%%%%%Configuracion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(archivo);
funcion=@fuerza_nb;

% Integrador=@colocacion_nb_adap; 
% parametros_Integrador.orden=12;
% parametros_Integrador.paso=.3;
% parametros_Integrador.tol=1e-21;
% parametros_Integrador.iter=2;

%%multipaso
Integrador=@multipaso_nb_implicito;
parametros_Integrador.paso=10;
parametros_Integrador.orden=12;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cantidad_cuerpos=size(PosHelio,1); 
cantidad_cuerpos_menores=cantidad_cuerpos-cantidad_planetas;

%%====================================================
[GM1,funcion_datos_sol,funcion_datos,~,~,~]= sistema_exterior(cantidad_cuerpos_menores);


%%==========Convertir coordenadas a baric�ntricas

pos0=PosHelio((cantidad_planetas+1):end,:,end)';
pos0=pos0(:)';
posdot0=VelHelio((cantidad_planetas+1):end,:,end)';
posdot0=posdot0(:)';

pos=squeeze(PosHelio(1:cantidad_planetas,:,end));
vel=squeeze(VelHelio(1:cantidad_planetas,:,end)); 
BariCentro=(-GM1(2:end)/GM1(1))*pos;
VelBariCentro=(-GM1(2:end)/GM1(1))*vel;
pos=pos-repmat(BariCentro,[cantidad_planetas,1,1]);
vel=vel-repmat(VelBariCentro,[cantidad_planetas,1,1]);
pos=pos';
vel=vel';
pos=pos(:)';
vel=vel(:)';
epoca=epocas(end);
clear PosHelio VelHelio epocas

[pos0,posdot0]=helio2bari(pos0,posdot0,pos,vel,GM1);
pos0=[pos,pos0];
vel0=[vel,posdot0];



LimGuardar=floor(cantidad_epocas/CantEpocPaso)+1;
PasoTot=LimGuardar*CantEpocPaso;
efemerides_epocas=epoca+(0:PasoEpoc:PasoEpoc*PasoTot-1);

efemerides_epocas=reshape(efemerides_epocas,[CantEpocPaso,LimGuardar]);


parametros_Integrador.mensaje='Integrando sistema solar...';
for j=1:LimGuardar;
    
    [pos_bari,vel_bari]=Integrador(funcion,funcion_datos,efemerides_epocas(:,j),pos0,vel0,epoca,parametros_Integrador);
    
    
   
    
    %%%% GM1 nuevo
    
    
    NombreBloque=num2str(IndBloque);
    Falta0=5-length(NombreBloque);
    NombreBloque=[repmat('0',[1,Falta0]),NombreBloque,'.mat'];
    AdSol(pos_bari,vel_bari,cantidad_cuerpos_menores,efemerides_epocas(:,j),NombreBloque,GM1,CantEpocPaso,cantidad_cuerpos);
%     cantidad_cuerpos_menores=length(I);
%     [GM1,funcion_datos_sol,funcion_datos,posicion_ini,velocidad_ini,Jini]= sistema(cantidad_cuerpos_menores);
%     cantidad_cuerpos=funcion_datos.cantidad_planetas+cantidad_cuerpos_menores; 

    
    IndBloque=IndBloque+1;
    
    
    pos0=pos_bari(end,:);
    vel0=vel_bari(end,:);
    epoca=efemerides_epocas(end,j);
    mensaje=sprintf('Proceso Global: %3.0f', 100*j/LimGuardar);
    clc;disp(mensaje);
end

function AdSol(pos_bari,vel_bari,cantidad_cuerpos_menores,epocas,NombreBloque,GM1,CantEpocPaso,cantidad_cuerpos)
GM1=[GM1,zeros(1,cantidad_cuerpos_menores)];
pos_bari=   permute(reshape(pos_bari,[CantEpocPaso,3,cantidad_cuerpos]),[3,2,1]);
vel_bari=   permute(reshape(vel_bari,[CantEpocPaso,3,cantidad_cuerpos]),[3,2,1]);

%%%%%Agregamos posicion del sol

R0=reshape((-GM1(2:end)/GM1(1))*pos_bari(:,:),[1,3,CantEpocPaso]);
V0=reshape((-GM1(2:end)/GM1(1))*vel_bari(:,:),[1,3,CantEpocPaso]);
pos_bari=cat(1,R0,pos_bari);
vel_bari=cat(1,V0,vel_bari);

PosHelio=pos_bari(2:end,:,:)-repmat(pos_bari(1,:,:),[cantidad_cuerpos,1,1]);
VelHelio=vel_bari(2:end,:,:)-repmat(vel_bari(1,:,:),[cantidad_cuerpos,1,1]);

save(NombreBloque,'PosHelio','VelHelio','epocas');
