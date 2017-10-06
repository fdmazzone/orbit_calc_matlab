function orbit_calc_simulador(archivo,PasoEpoc,CantEpocPaso,cantidad_epocas);
%%archico =archivo de elementos keplerianos compatible con orbit_calc
%%PasoEpoc=long de un paso
%%CantEpocPaso =cuantas epocas entran en cada subarchivo
%%cantidad_epocas=cantidad total de epocas
%%%%%%%%%%%Configuracion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(archivo);
funcion=@fuerza_nb;


%%%Colocacion
% Integrador=@colocacion_nb_adap; 
% parametros_Integrador.orden=12;
% parametros_Integrador.paso=.3;
% parametros_Integrador.tol=1e-21;
% parametros_Integrador.iter=2;

%%multipaso
Integrador=@multipaso_nb_implicito;
parametros_Integrador.paso=15;
parametros_Integrador.orden=12;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
 epoca=asteroides.epoca(1);
%epoca=epocas(end);
cantidad_cuerpos_menores=size(asteroides.a,1);
% cantidad_cuerpos_menores=size(pos_helio,1);
%cantidad_epocas=length(efemerides_epocas);

% pos_helio=(squeeze(pos_helio(:,:,end)))';
% vel_helio=(squeeze(vel_helio(:,:,end)))';
% pos0=(pos_helio(:))';  
% posdot0=(vel_helio(:))';  

pos0=[];
posdot0=[];
for j=1:cantidad_cuerpos_menores;
    [pos0_t,posdot0_t]=kepler2vector(asteroides.M(j),asteroides.peri(j),asteroides.node(j),asteroides.incli(j),asteroides.e(j),asteroides.n(j),asteroides.a(j));
    pos0=[pos0,pos0_t'];
    posdot0=[posdot0,posdot0_t'];
end


%IndParticulasTest=1:cantidad_cuerpos_menores;


%%====================================================
[GM1,funcion_datos_sol,funcion_datos,posicion_ini,velocidad_ini,Jini]= sistema_exterior(cantidad_cuerpos_menores);
cantidad_cuerpos=funcion_datos.cantidad_planetas+cantidad_cuerpos_menores; 

%%integrar el sistema solar hasta la epoca de los elementos del cuerpo
parametros_Integrador.mensaje='Integrando sistema solar hasta epoca asteroides...';
[pos,vel]=Integrador(funcion,funcion_datos_sol,epoca,posicion_ini,velocidad_ini,Jini,parametros_Integrador);




%%==========Convertir coordenadas a baric�ntricas

[pos0,posdot0]=helio2bari(pos0,posdot0,pos,vel,GM1);
pos0=[pos,pos0];
vel0=[vel,posdot0];




%%% Integramos el sistema solar m�s el cuerpo, primera en la epoca futuras

%%PasoEpoc=efemerides_epocas(2)-efemerides_epocas(1);

%%CantEpocPaso=1000;
LimGuardar=floor(cantidad_epocas/CantEpocPaso)+1;
PasoTot=LimGuardar*CantEpocPaso;
efemerides_epocas=asteroides.epoca(1)-(0:PasoEpoc:PasoEpoc*PasoTot-1);

efemerides_epocas=reshape(efemerides_epocas,[CantEpocPaso,LimGuardar]);
IndBloque=1;

% pos_bari=zeros(CantEpocPaso,cantidad_cuerpos*3);
% vel_bari=zeros(CantEpocPaso,cantidad_cuerpos*3);
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
    
%     Quedan=[3*I-2;3*I-1;3*I];clc
%     
%     Quedan=[(1:30)';30+Quedan(:)];
%     
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

% Cuerpo=squeeze(pos_helio(12:end,:,end));
% VCuerpo=squeeze(vel_helio(12:end,:,end));
% a=vector2kepler([Cuerpo,VCuerpo],GM1(1,1));
% per=a.^1.5;
% I=find(per<(2/3+2/300) & per>(2/3-2/300));
% 
% IndParticulasTest=IndParticulasTest(I);

% pos_helio=pos_helio(I,:,:);
% vel_helio=vel_helio(I,:,:);

save(NombreBloque,'PosHelio','VelHelio','epocas');
