function varargout = Efemerides(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Efemerides_OpeningFcn, ...
                   'gui_OutputFcn',  @Efemerides_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function Efemerides_OpeningFcn(hObject, eventdata, handles, varargin)

switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end



hoy=now;
hoy=hoy+1721058.5-observador.UToffset/24;
[Anio Mes Dia]=jul2gre(hoy);
[dias horas minutos nosirve]=d2dhs(Dia);
Anio=num2str(Anio);
Mes=num2str(Mes);
dias=num2str(dias);
horas=num2str(horas);
minutos=num2str(minutos);
segundos='0';
set(handles.edit_ano,'String',Anio);
set(handles.edit_mes,'String',Mes);
set(handles.edit_dia,'String',dias);
set(handles.edit_hora,'String',horas);
set(handles.edit_min,'String',minutos);
set(handles.edit_seg,'String',segundos);

load('asteroides.mat');
load('cometas.mat');


handles.output = hObject;
handles.base=asteroides;
% handles.ruta_archivo_elementos=100001;
% handles.ruta_archivo_elementos=[];
clear asteroides;
handles.base_com=cometas;

% Update handles structure
guidata(hObject, handles);

function varargout = Efemerides_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function edit_ano_Callback(hObject,  eventdata, handles)

anio=str2double(get(hObject,'String'));
if anio~=fix(anio)
    sound(sin(1000*(1:0.1:100)),10000)
    set(hObject,'String','');
end

function edit_ano_CreateFcn(hObject,  eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_mes_Callback(hObject, eventdata, handles)
mes=str2double(get(hObject,'String'));
if mes~=floor(mes) || mes<1 || mes>12
    sound(sin(1000*(1:0.1:100)),10000)
    set(hObject,'String','');
end

function edit_mes_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_dia_Callback(hObject, eventdata, handles)
dia=str2double(get(hObject,'String'));
if dia~=floor(dia) | dia<1 | dia>31
    sound(sin(1000*(1:0.1:100)),10000)
    set(hObject,'String','');
end

function edit_dia_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_hora_Callback(hObject, eventdata, handles)
hora=str2double(get(hObject,'String'));
if hora~=floor(hora) | hora<0 | hora>24
    sound(sin(1000*(1:0.1:100)),10000)
    set(hObject,'String','');
end


function edit_hora_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_min_Callback(hObject, eventdata, handles)
min=str2double(get(hObject,'String'));
if min~=floor(min) | min<0 | min>60
    sound(sin(1000*(1:0.1:100)),10000)
    set(hObject,'String','');
end

function edit_min_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_seg_Callback(hObject, eventdata, handles)
seg=str2double(get(hObject,'String'));
if seg~=floor(seg) | seg<0 | seg>60
    sound(sin(1000*(1:0.1:100)),10000)
    set(hObject,'String','');
end


function edit_seg_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_sep_Callback(hObject, eventdata, handles)
sep=str2double(get(hObject,'String'));
if sep~=floor(sep) | sep<0 
    sound(sin(1000*(1:0.1:100)),10000);
    set(hObject,'String','');
end

function edit_sep_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_cant_Callback(hObject, eventdata, handles)
cant=str2double(get(hObject,'String'));
if cant~=floor(cant) | cant<0 
    sound(sin(1000*(1:0.1:100)),10000);
    set(hObject,'String','');
end


function edit_cant_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function pm_orden_col_Callback(hObject, eventdata, handles)


function pm_orden_col_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function pm_tol_col_Callback(hObject, eventdata, handles)

function pm_tol_col_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function pm_iter_col_Callback(hObject, eventdata, handles)

function pm_iter_col_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function pm_orden_mul_Callback(hObject, eventdata, handles)

function pm_orden_mul_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function pm_paso_mul_Callback(hObject, eventdata, handles)
function pm_paso_mul_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pm_metodo_Callback(hObject, eventdata, handles)
metodo_elegido=get(hObject,'Value');

switch metodo_elegido
    case 1
        set(handles.pm_orden_mul,'Visible','off');
        set(handles.pm_paso_mul,'Visible','off');
        set(handles.text15,'Visible','off');
        set(handles.text16,'Visible','off');
        set(handles.pm_orden_col,'Visible','on');
        set(handles.pm_tol_col,'Visible','on');
        set(handles.pm_iter_col,'Visible','on');
        set(handles.text11,'Visible','on');
        set(handles.text12,'Visible','on');
        set(handles.text13,'Visible','on');
        set(handles.text14,'Visible','on');
    case 2
        set(handles.pm_orden_mul,'Visible','on');
        set(handles.text15,'Visible','on');
        set(handles.text16,'Visible','on');
        set(handles.pm_paso_mul,'Visible','on');
        set(handles.pm_orden_col,'Visible','off');
        set(handles.pm_tol_col,'Visible','off');
        set(handles.pm_iter_col,'Visible','off');
        set(handles.text11,'Visible','off');
        set(handles.text12,'Visible','off');
        set(handles.text13,'Visible','off');
        set(handles.text14,'Visible','off');
end

function pm_metodo_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end






function edit_objeto_Callback(hObject, eventdata, handles)

function edit_objeto_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function pb_obtener_Callback(hObject, eventdata, handles)
tic;
Anio=str2double(get(handles.edit_ano,'String'));
Mes=str2double(get(handles.edit_mes,'String'));
Dia=str2double(get(handles.edit_dia,'String'));

%%Chequeamos si dia mes y a�o son posibles.
JD_ini=gre2jul(Dia,Mes,Anio);
[AAAA MM DD]=jul2gre(JD_ini);

Hora=str2double(get(handles.edit_hora,'String'));
Min=str2double(get(handles.edit_min,'String'));
Seg=str2double(get(handles.edit_seg,'String'));
Dia=Dia+Hora/24+Min/(24*60)+Seg/(24*3600);
PrimeraEpoca=gre2jul(Dia,Mes,Anio);
CantEpoc=str2double(get(handles.edit_cant,'String'));
SaltoEpoc=str2double(get(handles.edit_sep,'String'));




%%%%Construimos la epocas de las efemerides
switch true
    case get(handles.rb_seg,'Value');
        SaltoEpoc=SaltoEpoc/(24*3600);
    case get(handles.rb_min,'Value');
        SaltoEpoc=SaltoEpoc/(24*60);
    case get(handles.rb_hora,'Value');
        SaltoEpoc=SaltoEpoc/24;
    case get(handles.rb_dia,'Value');
        SaltoEpoc=SaltoEpoc;
    case get(handles.rb_ano,'Value');
        SaltoEpoc=SaltoEpoc*365;

    otherwise
        
end


%%%%% Definimos los tiempos de las efemerides, le agregamos 1 minuto a cada
%%%%% una para calcular mov y PA.

EpocEfemer=(PrimeraEpoca:SaltoEpoc:(PrimeraEpoca+(CantEpoc-1)*SaltoEpoc));
EpocEfemer=[EpocEfemer;EpocEfemer+1/(24*60)];
EpocEfemer=EpocEfemer(:);
CantEpoc=2*CantEpoc;
 

%%%% Elegimos el metodo

[Integrador,IntegraParam,NombreMet]=eleccion_metodo(handles);


%%%% Elegimos la funcion fuerzas dejado para mas adelante poder elegir
%%%% modelos alternativos de sistema solar

funcion=@fuerza_nb;
   

%%% Cargamos base de datos de asteroides

Cuerpo=get(handles.edit_objeto,'String');

if strcmp(Cuerpo,'Sistema Solar')
    CantCuerposMenores=0;
    [GM1,~,FuncionDatos,Pos,Vel,Epoca]= sistema(0);
    CantCuerpos=FuncionDatos.cantidad_planetas;
    is_comet=false;
    set(handles.checkbox_pantalla,'Value',false);
else
    [Pos0,PosDot0,Epoca,H,G,Designacion,Nombres,CantCuerposMenores,is_comet]=buscar_cuerpo(Cuerpo,handles);

    %%%=================================================================
    %%%%%Comienzo del algoritmo
    %%% Construimos los parametros del sistema
    %%=====================================================

    %%====================================================
    [GM1,FuncionDatosSol,FuncionDatos,PosIni,VelIni,Jini]= sistema(CantCuerposMenores);
    CantCuerpos=FuncionDatos.cantidad_planetas+CantCuerposMenores; 

    %%integrar el sistema solar hasta la epoca de los elementos del cuerpo
    IntegraParam.mensaje='Integrando sistema solar...';
    [Pos,Vel]=Integrador(funcion,FuncionDatosSol,Epoca,PosIni,VelIni,Jini,IntegraParam);




    %%==========Convertir coordenadas a baric�ntricas
    
    [Pos0,PosDot0]=helio2bari(Pos0',PosDot0',Pos,Vel,GM1);
    Pos=[Pos,Pos0];
    Vel=[Vel,PosDot0];
end
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

MostrarBari=get(handles.checkbox_bari,'Value');
if MostrarBari
    assignin('base', 't', EpocEfemer(1:2:end));
    assignin('base', 'PosBari', PosBari(:,:,1:2:end));
    assignin('base', 'VelBari', VelBari(:,:,1:2:end));
end

%%===============Observador===================

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


MostrarBari=get(handles.checkbox_heliocentricas,'Value');
if MostrarBari
    assignin('base', 't', EpocEfemer(1:2:end));
    assignin('base', 'PosHelio', PosHelio(:,:,1:2:end));
    assignin('base', 'VelHelio', VelHelio(:,:,1:2:end));
end





MostrarRot=get(handles.checkbox_rotantes,'Value');
if MostrarRot
    valor_elegido=get(handles.pop_planetas,'Value');
    switch  valor_elegido
        case 1
            nro_cuerpo=3;
        case 2
            nro_cuerpo=1;
        case 3
            nro_cuerpo=2;
        otherwise
            nro_cuerpo=valor_elegido+1;
    end
    PosRot=givens(PosHelio(2:end,:,1:2:end),nro_cuerpo);
    VelRot=givens(VelHelio(2:end,:,1:2:end),nro_cuerpo);
    assignin('base', 't', EpocEfemer(1:2:end));
    assignin('base', 'PosRot', PosRot);
    assignin('base', 'VelRot', VelRot);
    
end


MostrarEcua=get(handles.checkbox_ecua,'Value');
if MostrarEcua
    PosEcua=ecli2ecua(PosHelio(:,:,1:2:end));
    VelEcua=ecli2ecua(VelHelio(:,:,1:2:end));
    assignin('base', 't', EpocEfemer(1:2:end));
    assignin('base', 'PosEcua', PosEcua);
    assignin('base', 'VelEcua', VelEcua);
end





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
clc
IsImpAnalisis=get(handles.checkbox_impact,'Value');
if IsImpAnalisis && CantCuerposMenores==1
    AltitudAtm=str2num(get(handles.edit_imp,'String'));
    impacto(EpocEfemer(impar),squeeze(AR(end,:,impar)),...
        squeeze(DE(end,:,impar)),squeeze(Delta(end,:,impar)),AltitudAtm);
end

if IsImpAnalisis && CantCuerposMenores>1
    AltitudAtm=str2num(get(handles.edit_imp,'String'));
    impacto_masa(EpocEfemer(impar),squeeze(AR((cantidad_planetas+1):end,:,impar)),...
        squeeze(DE((cantidad_planetas+1):end,:,impar)),...
        squeeze(Delta((cantidad_planetas+2):end,:,impar)),Nombres);
end



MostrarPantalla=get(handles.checkbox_pantalla,'Value');
MostrarMapa=get(handles.checkbox_mapa,'Value');
if ~MostrarPantalla && ~MostrarMapa 
    return
end





redond=floor(AR/pi);
AR=AR-redond*2*pi;
AR=12*AR/pi;
[AR DE]=correcparal(AR,DE,Delta_corr,EpocEfemer,observador.Longitude,observador.pcos,observador.psin);







%%movimiento y PA
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


% beta=acosd((r_corr(cantidad_planetas:end,:,:).^2 ...
%     +Delta_corr(cantidad_planetas+1:end,:,:).^2 ...
%     -repmat(R_corr,[CantCuerposMenores,1,1]).^2)...
%     ./(2*(r_corr(cantidad_planetas:end,:,:).*Delta_corr(cantidad_planetas+1:end,:,:))));


beta=acosd((r_corr.^2 ...
    +Delta_corr(2:end,:,:).^2 ...
    -repmat(R_corr,[size(r_corr,1),1,1]).^2)...
    ./(2*(r_corr.*Delta_corr(2:end,:,:))));

beta_luna=beta(3,:,:);
beta=beta(cantidad_planetas:end,:,:);
FracIlumLuna=squeeze((1+cosd(beta_luna))/2);



    if ~is_comet
        phi1=exp(-3.33*(tand(beta/2)).^(0.63));
        phi2=exp(-1.87*(tand(beta/2)).^(1.22));
        G=repmat(G,[1,1,size(AR,3)]);
        mag=repmat(H,[1,1,size(AR,3)])+5*log10(r_corr(cantidad_planetas:end,:,:).*Delta_corr(cantidad_planetas+1:end,:,:))...
            -2.5*log10((1-G).*phi1+G.*phi2);
    
    
    elseif is_comet
       mag=H+5*log10(Delta_corr(end,:,:))+2.5*G.*log10(r_corr(end,:,:));
    end
 
 %%Para un asteroide
    
    if MostrarPantalla & CantCuerposMenores==1;
        %% fix(DE)+0.1*sign(DE) para hacer que redondee bien
        [anios meses dias]=jul2gre(EpocEfemer(impar));
        [dias horas minutos segundos]=d2dhs(dias);
        AR=squeeze(AR(end,:,:));
        DE=squeeze(DE(end,:,:));
        
        
        DEg=fix(DE);
        mant=abs(DE-DEg);
        DEmin=fix(mant*60);
        mant=mant*60-DEmin;
        DEseg=mant*60;
        
        ARg=fix(AR);
        mant=abs(AR-ARg);
        ARmin=fix(mant*60);
        mant=mant*60-ARmin;
        ARseg=mant*60;
        
        mag=squeeze(mag);
        Delta=squeeze(Delta(end,:,:));
        PA=squeeze(PA(end,:,:));
        mov_apar=squeeze(mov_apar(end,:,:));
        elong_luna=squeeze(elong_luna(end,:,:));
        elong_sol=squeeze(elong_sol(end,:,:));
        beta=squeeze(beta(end,:,:));
        AltitudL=squeeze(Altitud(4,:,:));
        AltitudS=squeeze(Altitud(1,:,:));
        Altitud=squeeze(Altitud(end,:,:));
        Azimut=squeeze(Azimut(end,:,:));

   
      
        
        
        pos=[anios, meses, dias,horas,minutos,segundos,floor(AR),ARmin,ARseg,fix(DE)+0.1*sign(DE),DEmin,DEseg,mag, Delta,mov_apar,PA, Altitud,Azimut, beta ,  elong_luna,FracIlumLuna, AltitudL, elong_sol, AltitudS];
        
        formato='%4.0f %02.0f %02.0f  %02.0f %02.0f %02.0f   %02.0f %02.0f %05.2f  %0+3.0f %02.0f %05.2f   %6.2f   %10.6f %10.4f  %7.3f    %5.1f   %5.1f %6.2f    %5.1f  %4.2f  %6.2f  %5.1f  %6.2f\n';
        
        

        texto1=sprintf('%s %s','Efem�rides perturbadas generadas por orbit_calc para:',Designacion);
        texto2=sprintf('%s %s','Observatorio:',observador.name_obs);
        texto3=sprintf('%s %s','Integrador:',NombreMet);
        texto4=sprintf( '%s%16.2f %s','Tiempo de Computo',toc, 'seg');
        texto5=sprintf('%s ','aaaa mm dd  hh mm ss       AR           DE           Mag       Delta       "/min     PA        Alt.    Az.   Fase     |Elong| Fase|  Alt. | Elong | Alt.       ');
        
        
        
        texto6=sprintf(formato,pos');
        
        disp(texto1);
        disp(texto2);
        disp(texto3);
        disp(texto4)
        disp('========================================================================================================================================================');
        disp('                                                                                                                      |        Luna       |     Sol      |');
        disp(texto5);
        disp(texto6);
        
        
        if MostrarMapa
%             AR=squeeze(AR(end,:,:));
%             DE=squeeze(DE(end,:,:));
            Largo=str2num(get(handles.edit_largo_mapa,'String'));
            Largo2=Largo;
            Largo1= min(Largo/(cosd(DE(1))+eps),43200);
            
            switch observador.cat_activo
                case 'UCAC2'
                    [XPlaca, YPlaca, ~, DatosEstrellas]=ucac2_lector(AR(1),DE(1), Largo1/60,Largo2/60);
                case 'UCAC3'
                    [XPlaca, YPlaca, ~, DatosEstrellas]=ucac3_lector(AR(1),DE(1), Largo1/60,Largo2/60);
                otherwise
                    Catalogo=observador.cat_activo(10:end);
                    [XPlaca, YPlaca, ~, DatosEstrellas]=internet_cat_lector(Catalogo,AR(1),DE(1), Largo1/60,Largo2/60);
            end
            CantEst=size(DatosEstrellas,1);
            
            SegPlaca=0.00029089/60;
            MinPlaca=0.00029089;
            
            XLim=[min(XPlaca),max(XPlaca)];
            YLim=[min(YPlaca),max(YPlaca)];
            
            DivCuadro=(XLim(2)-XLim(1))/600;
            
            X=XLim(1):DivCuadro:XLim(2);
            Y=YLim(1):DivCuadro:YLim(2);
            [X,Y] = meshgrid(X,Y);
            
            Z=zeros(size(X));
            
            H=(18-DatosEstrellas(:,3))/4;
            Sigma=(8/3)*SegPlaca*H*(Largo/20).^0.8;
            for j=1:CantEst;
                
                PSF=H(j)*exp( -((X-XPlaca(j)).^2+(Y-YPlaca(j)).^2)/(4*Sigma(j)^2) );
                Z=Z+PSF;
            end
            
            figure;
            I=uint8(ones(size(Z)));
            J = imnoise(I,'poisson');
            Z=Z+double(J)/25;
            
            PSF=1*exp( -((X).^2+(Y).^2)/(300*SegPlaca^2) );

            [U,V]=foto(15*AR(1:end),DE(1:end),15*AR(1),DE(1));
            
            
            Sigma=(10/3)*SegPlaca*(Largo/20).^0.8;

            for j=1:size(U,1)
                 PSF=PSF+exp( -((U(j)-X).^2+(V(j)-Y).^2)/(4*Sigma^2) );
            end
            I=size(Z,1):-1:1;
            Z=Z(I,:);
            Z=cat(3,Z+PSF(I,:),Z+PSF(I,:),Z);
           

            imshow(Z)
            
            

            
        end
        
    end
%%%Cuando hay m�s de un asteroide
    if MostrarPantalla && CantCuerposMenores>1;
        %% fix(DE)+0.1*sign(DE) para hacer que redondee bien
        [~, ~, dias]=jul2gre(EpocEfemer(1));
        [~, ~ , ~, segundos]=d2dhs(dias);
        AR=squeeze(AR(cantidad_planetas+1:end,:,1));
        DE=squeeze(DE(cantidad_planetas+1:end,:,1));
        DEg=fix(DE);
        mant=abs(DE-DEg);
        DEmin=fix(mant*60);
        mant=mant*60-DEmin;
        DEseg=mant*60;
        ARg=fix(AR);
        mant=abs(AR-ARg);
        ARmin=fix(mant*60);
        mant=mant*60-ARmin;
        ARseg=mant*60;
        mag=squeeze(mag(:,:,1));
        Delta=squeeze(Delta((end-CantCuerposMenores+1):end,:,1));
        PA=squeeze(PA((end-CantCuerposMenores+1):end,:,1));
        mov_apar=squeeze(mov_apar((end-CantCuerposMenores+1):end,:,1));
        elong_luna=squeeze(elong_luna((end-CantCuerposMenores+1):end,:,1));
        elong_sol=squeeze(elong_sol((end-CantCuerposMenores+1):end,:,1));
        beta=squeeze(beta(:,:,1));
        Altitud=squeeze(Altitud((end-CantCuerposMenores+1):end,:,1));
        Azimut=squeeze(Azimut((end-CantCuerposMenores+1):end,:,1));
        
        CentroAR=median(AR);
        CentroDE=median(DE);  
        
        [XAst,YAst]=foto(15*AR(:,1),DE(:,1),15*CentroAR,CentroDE);
        MinPlaca=0.00029089;
        Diametro=(max(max(XAst)-min(XAst),max(YAst)-min(YAst)))/(60*MinPlaca);
        if Diametro>300
            
            disp('La region excede los 100, el analisis es finalizado');
            return
        end
        
        Fov1=observador.fov(1)*MinPlaca;
        Fov2=observador.fov(2)*MinPlaca;
        IndMax=cubrir_rect([XAst,YAst],3*Fov1/7,3*Fov2/7);

        if MostrarMapa
            
          

            Largo=str2num(get(handles.edit_largo_mapa,'String'));
            Largo2=Largo;
            Largo1= min(Largo/(cosd(CentroDE)+eps),43200);
            
          
            
            switch observador.cat_activo
                case 'UCAC2'
                    [XPlaca, YPlaca, ~, DatosEstrellas]=ucac2_lector(CentroAR,CentroDE, Largo1/60,Largo2/60);
                case 'UCAC3'
                    [XPlaca, YPlaca, ~, DatosEstrellas]=ucac3_lector(CentroAR,CentroDE, Largo1/60,Largo2/60);
                otherwise
                    Catalogo=observador.cat_activo(10:end);
                    [XPlaca, YPlaca, ~, DatosEstrellas]=internet_cat_lector(Catalogo,CentroAR,CentroDE, Largo1/60,Largo2/60);
            end
            
            
           
            CantEst=size(DatosEstrellas,1);
            

            SegPlaca=MinPlaca/60;
            
            
            XLim=[min(XPlaca),max(XPlaca)];
            YLim=[min(YPlaca),max(YPlaca)];
            
            DivCuadro1=(XLim(2)-XLim(1))/600;
            DivCuadro2=(YLim(2)-YLim(1))/600;
            
            X=XLim(1):DivCuadro1:XLim(2);
            Y=YLim(1):DivCuadro2:YLim(2);
            [X,Y] = meshgrid(X,Y);
            
            Z=zeros(size(X));
            
            H=(18-DatosEstrellas(:,3))/4;
             Sigma=(8/3)*SegPlaca*H*(Largo/20).^0.8;
            for j=1:CantEst;
                
                PSF=H(j)*exp( -((X-XPlaca(j)).^2+(Y-YPlaca(j)).^2)/(4*Sigma(j)^2) );
                Z=Z+PSF;
            end
            I=uint8(ones(size(Z)));
            J = imnoise(I,'poisson');
            Z=Z+double(J)/25;
            PSF=zeros(size(Z));
            for j=1:CantCuerposMenores;
                
                PSF=PSF+exp( -((X-XAst(j)).^2+(Y-YAst(j)).^2)/(300*SegPlaca^2) );
            end


            MaxPlaca=max(max(Z));
            PSF2=zeros(size(Z));
            
             for j=1:size(IndMax,2)
                 
                  I=find((abs(X-Fov1/2-XAst(IndMax(j)))<DivCuadro1 & abs(Y-YAst(IndMax(j)))< Fov2/2) |...
                         (abs(X+Fov1/2-XAst(IndMax(j)))<DivCuadro1 & abs(Y-YAst(IndMax(j)))< Fov2/2) |...
                         (abs(Y-Fov2/2-YAst(IndMax(j)))< DivCuadro2 & abs(X-XAst(IndMax(j)))< Fov1/2) |...
                         (abs(Y+Fov2/2-YAst(IndMax(j)))<DivCuadro2 &  abs(X-XAst(IndMax(j)))< Fov1/2));

                  PSF2(I)=MaxPlaca;
                 
    
             end
             
            I=size(Z,1):-1:1;
            Z=cat(3,Z(I,:)+PSF(I,:)+PSF2(I,:),Z(I,:)+PSF(I,:)+PSF2(I,:),Z(I,:));
            figure;
            imshow(Z)
            

            
        end

        
        pos=[floor(AR),ARmin,ARseg,fix(DE)+0.1*sign(DE),DEmin,DEseg,mag, Delta,mov_apar,PA, Altitud,Azimut,  elong_luna,elong_sol,beta ];
        
        formato='%02.0f %02.0f %05.2f  %0+3.0f %02.0f %05.2f   %6.2f   %10.6f %10.4f  %7.3f    %4.1f   %5.1f    %5.1f   %5.1f   %6.2f\n';
        texto0a=num2str((1:length(IndMax))');
        texto0=repmat(' ',[CantCuerposMenores,size(texto0a,2)]);
        formato=repmat(formato,[CantCuerposMenores,1]);
        texto0(IndMax,:)=texto0a;
        texto0=[texto0,repmat(' ',[CantCuerposMenores,4-size(texto0,2)])];
        formato=[texto0,Nombres, formato];
        
        
       
        texto1=sprintf('%s','Efemerides perturbadas generadas por orbit_calc');
        texto2=sprintf('%s %s','Observatorio:',observador.name_obs);
        texto3=sprintf('%s %s','Integrador:',NombreMet);
        texto4=sprintf( '%s%16.2f %s','Tiempo de Computo',toc, 'seg');
        texto5=sprintf('%s ','#   Aster.      AR           DE           Mag       Delta       "/min     PA       Alt.    Az.    E.Luna  E. Sol    Fase   ');
        texto7='La primera columna # indica el orden en que hay que elegir los asteroides para recorrer la curva';
        
        
        texto6=sprintf(formato',pos');
        
        disp(texto1);
        disp(texto2);
        disp(texto3);
        disp(texto4);
        disp(texto7);
        disp('===========================================================================================================');
        disp(texto5);
        disp(texto6);
        
        
                
    end    




function pb_salir_Callback(hObject, eventdata, handles)

close(mfilename)



function figure1_CreateFcn(hObject, eventdata, handles)

function figure1_WindowButtonDownFcn(hObject, eventdata, handles)

function checkbox_pantalla_Callback(hObject, eventdata, handles)

function checkbox_bari_Callback(hObject, eventdata, handles)

function checkbox_heliocentricas_Callback(hObject, eventdata, handles)

function checkbox_delta_Callback(hObject, eventdata, handles)





function handles=pushbutton_archivo_Callback(hObject, eventdata, handles)

[archivo_elementos,directorio_archivo]= uigetfile({'*.dat';'*.mat';'*.txt'},'Base Elementos Asteroides');
set(handles.edit_objeto,'String',[directorio_archivo,archivo_elementos]);
guidata(hObject, handles);

function [XPlaca, YPlaca, NombresEstrellas, DatosEstrellas]=ucac3_lector(AR,DE, Ancho,Alto);
AR=15*AR;

switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
        eval(['[CantEstrellas, Mensaje]=system(''',observador.directorio1,'\u3test ',num2str(AR),' ', num2str(DE),' ',num2str(Ancho),' ',num2str(Alto),' ',observador.directorio_ucac3,''');']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
        eval(['[CantEstrellas, Mensaje]=system(''',observador.directorio1,'/u3test ',num2str(AR),' ', num2str(DE),' ',num2str(Ancho),' ',num2str(Alto),' ',observador.directorio_ucac3,''');']);
end


CurDir=cd;

if ~strcmp(CurDir,observador.directorio1)
    movefile('ucac3.txt',observador.directorio1);
end
fid=fopen([observador.directorio1,'\ucac3.txt']);
S=textscan(fid,'%s%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%*s%f%*[^\n]');
fclose(fid);
NombresEstrellas=char(S{1});
DatosEstrellas=[S{2},S{3},S{4},S{5},S{6}];
V=0.531*(DatosEstrellas(:,4)-DatosEstrellas(:,5))+0.906*DatosEstrellas(:,3)+0.95;

[nosirve,I]=sort(V);
I=I(1:min(length(I),2000));
J=find(V(I)>-3 & V(I)<18);
I=I(J);

V=V(I);
DatosEstrellas=[DatosEstrellas(I,1:2),V];
[XPlaca,YPlaca]=foto(DatosEstrellas(:,1),DatosEstrellas(:,2),AR,DE);


function [XPlaca, YPlaca, NombresEstrellas, DatosEstrellas]=ucac2_lector(AR,DE, Ancho,Alto);
AR=15*AR;

switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end

eval(['[CantEstrellas, Mensaje]=system(''',observador.directorio1,'\UCAC2 ',num2str(AR),' ', num2str(DE),' ',num2str(Ancho),' ',num2str(Alto),' ',observador.directorio_ucac2,''');']);
CurDir=cd;

if ~strcmp(CurDir,observador.directorio1)
    movefile('ucac2.txt',observador.directorio1);
end
fid=fopen([observador.directorio1,'\ucac2.txt']);
S=textscan(fid,'%s%f%f%f%*[^\n]');
fclose(fid);
NombresEstrellas=char(S{1});
DatosEstrellas=[S{2},S{3},S{4}];
V=S{4};

[nosirve,I]=sort(V);
I=I(1:min(length(I),2000));
J=find(V(I)>-3 & V(I)<18);
I=I(J);

V=V(I);
DatosEstrellas=[DatosEstrellas(I,1:2),V];
[XPlaca,YPlaca]=foto(DatosEstrellas(:,1),DatosEstrellas(:,2),AR,DE);


function [XPlaca, YPlaca, NombresEstrellas, DatosEstrellas]=internet_cat_lector(Catalogo,AR,DE, Ancho,Alto);

Ancho=floor(Ancho*60);
Alto=floor(Alto*60);

Horas=floor(AR);
Min=floor((AR-Horas)*60);
Segundos =floor(((AR-Horas)*60-Min)*60);

if (Catalogo=='CMC14' & (DE<-30 || DE>50))
    Catalogo='UCAC3';
    disp('CMC14 disponible para -30< DE< 50, cambiamos al UCAC3')
end


if DE>=0
    Signo='+';
else
    Signo='-';
end

Grados=floor(abs(DE));
MinArc=floor((abs(DE)-Grados)*60);
switch Catalogo
    case 'UCAC3'
        Query=['http://vizier.u-strasbg.fr/cgi-bin/asu-txt?-source=',Catalogo,...
            '&-c=',num2str(Horas),'%3A',num2str(Min),'%3A',num2str(Segundos),Signo,num2str(Grados),'%3A',num2str(MinArc),'&-c.bm=',...
            num2str(Ancho),'/',num2str(Ancho), '&-out=*ID_MAIN%20_RA%20_DE%20*PHOT_MAG_OPTICAL&-out.max=2000&-out.form=tsv'];
    case 'CMC14'
        Query=['http://vizier.u-strasbg.fr/cgi-bin/asu-txt?-source=',Catalogo,...
            '&-c=',num2str(Horas),'%3A',num2str(Min),'%3A',num2str(Segundos),Signo,num2str(Grados),'%3A',num2str(MinArc),'&-c.bm=',...
            num2str(Ancho),'/',num2str(Ancho), '&-out=*ID_MAIN%20_RA%20_DE%20*PHOT_SDSS_R&-out.max=2000&-out.form=tsv'];
    case 'USNOA2'
        Query=['http://vizier.u-strasbg.fr/cgi-bin/asu-txt?-source=',Catalogo,...
            '&-c=',num2str(Horas),'%3A',num2str(Min),'%3A',num2str(Segundos),Signo,num2str(Grados),'%3A',num2str(MinArc),'&-c.bm=',...
            num2str(Ancho),'/',num2str(Ancho), '&-out=*ID_MAIN%20_RA%20_DE%20*PHOT_PHG_R%20*PHOT_PHG_B&-out.max=2000&-out.form=tsv'];
    case 'PPMXL'
        Query=['http://vizier.u-strasbg.fr/cgi-bin/asu-txt?-source=',Catalogo,...
            '&-c=',num2str(Horas),'%3A',num2str(Min),'%3A',num2str(Segundos),Signo,num2str(Grados),'%3A',num2str(MinArc),'&-c.bm=',...
            num2str(Ancho),'/',num2str(Ancho), '&-out=*ID_MAIN%20_RA%20_DE%20*PHOT_PHG_I&-out.max=2000&-out.form=tsv'];
    case 'UCAC4'
        Query=['http://vizier.u-strasbg.fr/cgi-bin/asu-txt?-source=',Catalogo,...
            '&-c=',num2str(Horas),'%3A',num2str(Min),'%3A',num2str(Segundos),Signo,num2str(Grados),'%3A',num2str(MinArc),'&-c.bm=',...
            num2str(Ancho),'/',num2str(Ancho), '&-out=*ID_MAIN%20_RA%20_DE%20*PHOT_MAG_OPTICAL&-out.max=2000&-out.form=tsv'];

     
end
fid=urlread(Query);

S=textscan(fid,'%[^\n]');
dat=char(S{:});

Imin=strmatch('---',dat(:,1:3))+1;

S=S{:};
Imin=Imin(end);
Imax=strmatch('#END#',dat(:,1:5))-1;
dat=dat(Imin:Imax,:);
Imax=strmatch('#INFO',dat(:,1:5));
if ~isempty(Imax)
    dat=dat(1:Imax-2,:);
end

switch Catalogo
    case 'UCAC3'
  
        NombresEstrellas=dat(:,1:10);
        
        DatosEstrellas(:,1)=str2num(dat(:,12:21));
        DatosEstrellas(:,2)=str2num(dat(:,23:32));
        

        fMag=str2num(dat(:,34:39));
        V = fMag;
        [nosirve,I]=sort(V);
        I=I(1:min(length(I),2000));
        J=find(V(I)>-3 & V(I)<18);
        I=I(J);
        
        V=V(I);
        DatosEstrellas=[DatosEstrellas(I,1:2),V];
        [XPlaca,YPlaca]=foto(DatosEstrellas(:,1),DatosEstrellas(:,2),15*AR,DE);
    case 'CMC14'
        

        NombresEstrellas=dat(:,1:15);
        
        DatosEstrellas(:,1)=str2num(dat(:,17:26));
        DatosEstrellas(:,2)=str2num(dat(:,28:37));
        
        %K=str2num(dat(:,211:216));
        rMag=str2num(dat(:,39:44));
        V = rMag;%0.531*(J-K) + 0.906*fMag+0.95;
        
        [nosirve,I]=sort(V);
        I=I(1:min(length(I),2000));
        J=find(V(I)>-3 & V(I)<18);
        I=I(J);
        
        V=V(I);
        DatosEstrellas=[DatosEstrellas(I,1:2),V];
        [XPlaca,YPlaca]=foto(DatosEstrellas(:,1),DatosEstrellas(:,2),15*AR,DE);
case 'USNOA2'
        disp('Catalogo activo USNOA2 (Internet)');
        NombresEstrellas=dat(:,1:13);
        
        DatosEstrellas(:,1)=str2num(dat(:,15:24));
        DatosEstrellas(:,2)=str2num(dat(:,26:35));
        
        
        RMag=str2num(dat(:,37:40));
        BMag=str2num(dat(:,42:45));
        V = (0.556*RMag+0.444*BMag);
        [nosirve,I]=sort(V);
        I=I(1:min(length(I),2000));
        J=find(V(I)>-3 & V(I)<22);
        I=I(J);
        
        V=V(I);
        DatosEstrellas=[DatosEstrellas(I,1:2),V];
        [XPlaca,YPlaca]=foto(DatosEstrellas(:,1),DatosEstrellas(:,2),15*AR,DE);
    case 'PPMXL'
        disp('Catalogo activo PPMXL (Internet)');
        IMag=dat(:,43:47);
        Ivacio=strmatch('     ',IMag);
        I=setdiff((1:size(IMag,1)), Ivacio);
        dat=dat(I,:);
        
        
        NombresEstrellas=dat(:,1:19);
        
        DatosEstrellas(:,1)=str2num(dat(:,21:30));
        DatosEstrellas(:,2)=str2num(dat(:,32:41));
        V=str2num(IMag(I,:));
        
        [nosirve,I]=sort(V);
        I=I(1:min(length(I),2000));
        J=find(V(I)>-3 & V(I)<22);
        I=I(J);
        
        V=V(I);
        DatosEstrellas=[DatosEstrellas(I,1:2),V];
        [XPlaca,YPlaca]=foto(DatosEstrellas(:,1),DatosEstrellas(:,2),15*AR,DE);

    case 'UCAC4'
  
        NombresEstrellas=dat(:,1:10);
        
        DatosEstrellas(:,1)=str2num(dat(:,12:21));
        DatosEstrellas(:,2)=str2num(dat(:,23:32));
        

        fMag=str2num(dat(:,34:39));
        V = fMag;
        [nosirve,I]=sort(V);
        I=I(1:min(length(I),2000));
        J=find(V(I)>-3 & V(I)<18);
        I=I(J);
        
        V=V(I);
        DatosEstrellas=[DatosEstrellas(I,1:2),V];
        [XPlaca,YPlaca]=foto(DatosEstrellas(:,1),DatosEstrellas(:,2),15*AR,DE);
  

end





function checkbox_mapa_Callback(hObject, eventdata, handles)




function edit_largo_mapa_Callback(hObject, eventdata, handles)

function edit_largo_mapa_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [Pos0,PosDot0,Epoca,H,G,Designacion,Nombres,CantCuerposMenores,is_comet]=buscar_cuerpo(cuerpo,handles)
HalloPto=find('.'==cuerpo);
if isempty(HalloPto)
    %%Buscamos el cuerpo en la base de datos
    CantCuerposMenores=1;


    entradas1=[];
    is_comet=logical(0);
    largo_cuerpo=length(cuerpo);

    %%% El objeto es entrado por su numeracion 
    if largo_cuerpo<5
        cuerpo2=cuerpo;
        for j=1:5-largo_cuerpo;
        cuerpo2=['0',cuerpo2];
        end
    else
        cuerpo2=cuerpo;
    end


    if largo_cuerpo<=7
    entradas1=strmatch(cuerpo2,handles.base.nombres(:,1:7));
        if ~isempty(entradas1);
            Designacion=handles.base.designacion(entradas1,:);
            [Pos0,PosDot0]=kepler2vector(handles.base.M(entradas1),handles.base.peri(entradas1),...
                handles.base.node(entradas1),handles.base.incli(entradas1),...
                handles.base.e(entradas1),handles.base.n(entradas1),handles.base.a(entradas1));
            Epoca=handles.base.epoca(entradas1);
            H=handles.base.H(entradas1);
            G=handles.base.G(entradas1);
            Nombres=handles.base.nombres(entradas1,:);
            clear cuerpo cuerpo2;
        end
    end
    if isempty(entradas1) & largo_cuerpo<=6;
        entradas1=strmatch(['(',cuerpo,')'],handles.base.designacion(:,7-largo_cuerpo:8));
        if ~isempty(entradas1);
            entradas=entradas1(1);
            [Pos0,PosDot0]=kepler2vector(handles.base.M(entradas),handles.base.peri(entradas),...
                handles.base.node(entradas),handles.base.incli(entradas),...
                handles.base.e(entradas),handles.base.n(entradas),handles.base.a(entradas));
            Designacion=handles.base.designacion(entradas,:);
            Epoca=handles.base.epoca(entradas);
            H=handles.base.H(entradas);
            G=handles.base.G(entradas);
            Nombres=handles.base.nombres(entradas,:);
            clear cuerpo cuerpo2;
        end
    end
    if isempty(entradas1);
        entradas1=strmatch(cuerpo,handles.base.designacion(:,10:28), 'exact');
        if ~isempty(entradas1);
            entradas=entradas1(1);
            [Pos0,PosDot0]=kepler2vector(handles.base.M(entradas),handles.base.peri(entradas),...
                handles.base.node(entradas),handles.base.incli(entradas),handles.base.e(entradas),...
                handles.base.n(entradas),handles.base.a(entradas));
            Designacion=handles.base.designacion(entradas,:);
            Epoca=handles.base.epoca(entradas);
            H=handles.base.H(entradas);
            G=handles.base.G(entradas);
            Nombres=handles.base.nombres(entradas,:);
            clear   cuerpo cuerpo2;
        end
    end
    if isempty(entradas1) && largo_cuerpo<=8;
        entradas1=strmatch(cuerpo,handles.base_com.nombres(:,1:largo_cuerpo), 'exact');
        if ~isempty(entradas1);
            is_comet=true;
            Pos0=handles.base_com.posiciones(entradas1,:)';
            PosDot0=handles.base_com.velocidades(entradas1,:)';
            Designacion=handles.base_com.designacion(entradas1,:);
            Epoca=handles.base_com.epocas(entradas1(1));
            H=handles.base_com.H(entradas1(1));
            G=handles.base_com.G(entradas1(1));
        end
    end    
    if isempty(entradas1);
        entradas1=strmatch(cuerpo,handles.base_com.designacion(:,1:largo_cuerpo), 'exact');
        if ~isempty(entradas1);
            is_comet=true;
            Pos0=handles.base_com.posiciones(entradas1,:)';
            PosDot0=handles.base_com.velocidades(entradas1,:)';
            Designacion=handles.base_com.designacion(entradas1,:);
            Nombres=Designacion;
            Epoca=handles.base_com.epocas;
            H=handles.base_com.H(entradas1(1));
            G=handles.base_com.G(entradas1(1));
        end
    end 
    if isempty(entradas1);
        disp('Cuerpo no hallado en bases de datos');
        return;
end

elseif ~isempty(HalloPto) 
    ruta_archivo=get(handles.edit_objeto,'String');
    Cuerpos=mpc2orbitcalc(ruta_archivo);
    [Pos0, PosDot0]=kepler2vector_m(Cuerpos.M,Cuerpos.peri,Cuerpos.node,Cuerpos.incli,Cuerpos.e,Cuerpos.n,Cuerpos.a);
    CantCuerposMenores=size(Pos0,2);
    Pos0=(Pos0(:));
    PosDot0=(PosDot0(:));
    Epoca=Cuerpos.epoca;
    H=Cuerpos.H;
    G=Cuerpos.G;
    Nombres=Cuerpos.nombres;
    Designacion=Nombres;
    is_comet=false;
   
end

function [Integrador,IntegraParam, NombreMet]=eleccion_metodo(handles)
IndMet=get(handles.pm_metodo,'Value');
NombreMet=get(handles.pm_metodo,'String');
NombreMet=NombreMet{IndMet};
switch IndMet
    case 1
        Integrador=@colocacion_nb_adap;
        IntegraParam.paso=.3;
        
        valor_elegido_tol=get(handles.pm_tol_col,'Value');
        valor_elegido_orden=get(handles.pm_orden_col,'Value');
        valor_elegido_iter=get(handles.pm_iter_col,'Value');
        
        
        IntegraParam.tol=get(handles.pm_tol_col,'String');
        IntegraParam.orden=get(handles.pm_orden_col,'String');
        IntegraParam.iter=get(handles.pm_iter_col,'String');
        
        IntegraParam.tol=10^(-str2double(IntegraParam.tol{valor_elegido_tol}));
        IntegraParam.orden=str2double(IntegraParam.orden{valor_elegido_orden});
        IntegraParam.iter=str2double(IntegraParam.iter{valor_elegido_iter});
        
    case 2
        Integrador=@multipaso_nb_implicito;
             
        valor_elegido_paso=get(handles.pm_paso_mul,'Value');
        valor_elegido_orden=get(handles.pm_orden_mul,'Value');
        
        
        IntegraParam.orden=get(handles.pm_orden_mul,'String');
        IntegraParam.paso=get(handles.pm_paso_mul,'String');
        
        IntegraParam.orden=str2double(IntegraParam.orden{valor_elegido_orden});
        IntegraParam.paso=str2double(IntegraParam.paso{valor_elegido_paso});
end



function checkbox_rotantes_Callback(hObject, eventdata, handles)




function pop_planetas_Callback(hObject, eventdata, handles)



function pop_planetas_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function checkbox_ecua_Callback(hObject, eventdata, handles)

function Cuerpos=mpc2orbitcalc(archivo);
if archivo(:,(end-3):end)=='.mat';
    load(archivo);
else
    fid = fopen(archivo);
    mpcorb= textscan(fid, '%[^\n]');
    mpcorb=char(mpcorb{1});
    H=mpcorb(:,9:13);
    Cuerpos.H=str2num(H);
    Cuerpos.nombres=mpcorb(:,1:7);
    Cuerpos.G=str2num(mpcorb(:,15:19));
    xmas=@(x) max(x,0);
    epoca=mpcorb(:,22:25);
    depocaJ=strmatch('J',mpcorb(:,21));
    anio=2000+str2num(epoca(:,1:2));
    anio(depocaJ)=1900+str2num(epoca(depocaJ,1:2));
    mes=char(epoca(:,3))+0;
    dia=char(epoca(:,4))+0;
    dia=xmas(dia-48)-xmas(dia-57)+xmas(dia-64);
    mes=xmas(mes-48)-xmas(mes-57)+xmas(mes-64);
    epoca=gre2jul(dia,mes,anio);
    Cuerpos.epoca=epoca(1);
    clear dia mes anio xmas;
    
    Cuerpos.M=str2num(mpcorb(:,27:35));
    Cuerpos.peri=str2num(mpcorb(:,38:46));
    Cuerpos.node=str2num(mpcorb(:,49:57));
    Cuerpos.incli=str2num(mpcorb(:,60:68));
    Cuerpos.e=str2num(mpcorb(:,71:79));
    Cuerpos.n=str2num(mpcorb(:,81:91));
    Cuerpos.a=str2num(mpcorb(:,93:103));
    fclose(fid);
end

function IndMax=cubrir_rect(X,res1,res2);

I=1:size(X,1);
IndMax=[];
while ~isempty(I)
    for j=1:length(I)
        Adentro{j}=find(  abs(X(I,1)-X(I(j),1))<res1 & abs(X(I,2)-X(I(j),2))<res2 );
        CantAdent(j)=length(Adentro{j});
    end
    [Maximo,IMax]=max(CantAdent);
    IndMax=[IndMax,I(IMax)];
    I=setdiff(I,I(Adentro{IMax}));
    clear CantAdent Adentro
  
end



% --------------------------------------------------------------------
function Configuracion_Callback(hObject, eventdata, handles)
Configuracion;
close(Efemerides);


% --------------------------------------------------------------------
function filtro_Callback(hObject, eventdata, handles)
filtro;
close(Efemerides);

function impacto(t,AR,DE,Delta,AltitudAtm)

RadTierra=radio_tierra(DE);

DeltaKm=Delta*149597870.7;
Altitud=DeltaKm-RadTierra;
PtosImpact=find(Altitud>0 & Altitud < AltitudAtm);

if ~isempty(PtosImpact)
    Altitud=Altitud(PtosImpact);
    DE=DE(PtosImpact);
    AR=AR(PtosImpact);
    t=t(PtosImpact);
    [~,~,DiaImpact]=jul2gre(t);
    Tol=1.15740740740741e-005;
    DiaImpact=Tol*round(DiaImpact*Tol^(-1));
    HorasImp=(DiaImpact-floor(DiaImpact))*24;
    MinImp=(HorasImp-floor(HorasImp))*60;
    SegImp=(MinImp-floor(MinImp))*60;
    DiaImpact=floor(DiaImpact);
    HorasImp=floor(HorasImp);
    MinImp=floor(MinImp);
    SegImp=floor(SegImp);
    
    LocSTGre=lst(t,0);
    LongImp=AR*180/pi-LocSTGre;
   
    figure;
    ax =worldmap('world');
    setm(ax, 'Origin', [0 LongImp(1) 0])
    land = shaperead('landareas', 'UseGeoCoords', true);
    geoshow(ax, land, 'FaceColor', [0.5 0.7 0.5])
    lakes = shaperead('worldlakes', 'UseGeoCoords', true);
    geoshow(lakes, 'FaceColor', 'blue')
    rivers = shaperead('worldrivers', 'UseGeoCoords', true);
    geoshow(rivers, 'Color', 'blue')
    cities = shaperead('worldcities', 'UseGeoCoords', true);
    geoshow(cities, 'Marker', '.', 'Color', 'red')
    load topo
    meshm(topo,topolegend) 
    gridm('GLineStyle','-','Gcolor',[.8 .7 .6],'Galtitude', .02);
    load coast;
    plot3m(lat,long,.01,'k');
    plotm(DE,LongImp,'.','MarkerSize',20,'Color','k');
    
    for j=1:length(PtosImpact);
      TextImp=sprintf('   %02.0f:%02.0f:%02.0f   %3.0fkm'...
            ,[HorasImp(j),MinImp(j),SegImp(j),Altitud(j)]);
      textm(DE(j),LongImp(j),TextImp,'Color','r');
    end
else
       disp('No se presentan Impactos');
 end
function impacto_masa(t,AR,DE,Delta,Nombres)

RadTierra=radio_tierra(DE);
NombresImp=[];
TiempoImp=[];
ARImp=[];
DEImp=[];

for j=1:size(AR,1)
    DeltaKm=Delta(j,:)*149597870.7;
    Altitud=DeltaKm-RadTierra(j,:);
    PtosImpact=find(Altitud<0 );
    if ~isempty(PtosImpact)
        PtosImpact=PtosImpact(1);
        NombresImp=[NombresImp;Nombres(j,:)];
        TiempoImp=[TiempoImp;t(PtosImpact)];
        ARImp=[ARImp;AR(j,PtosImpact)];
        DEImp=[DEImp;DE(j,PtosImpact)];
    end
end
LocSTGre=lst(TiempoImp,0);
LongImp=ARImp*180/pi-LocSTGre;
if ~isempty(ARImp)
    figure;
    ax =worldmap('world');
    setm(ax, 'Origin', [0 LongImp(1) 0])
    land = shaperead('landareas', 'UseGeoCoords', true);
    geoshow(ax, land, 'FaceColor', [0.5 0.7 0.5])
    lakes = shaperead('worldlakes', 'UseGeoCoords', true);
    geoshow(lakes, 'FaceColor', 'blue')
    rivers = shaperead('worldrivers', 'UseGeoCoords', true);
    geoshow(rivers, 'Color', 'blue')
    cities = shaperead('worldcities', 'UseGeoCoords', true);
    geoshow(cities, 'Marker', '.', 'Color', 'red')
    load topo
    meshm(topo,topolegend)
    gridm('GLineStyle','-','Gcolor',[.8 .7 .6],'Galtitude', .02);
    load coast;
    plot3m(lat,long,.01,'k');
    for j=1:length(ARImp)
        [~,~,DiaImpact]=jul2gre(TiempoImp(j));
        Tol=1.15740740740741e-005;
        DiaImpact=Tol*round(DiaImpact*Tol^(-1));
        HorasImp=(DiaImpact-floor(DiaImpact))*24;
        MinImp=(HorasImp-floor(HorasImp))*60;
        SegImp=(MinImp-floor(MinImp))*60;
        DiaImpact=floor(DiaImpact);
        HorasImp=floor(HorasImp);
        MinImp=floor(MinImp);
        SegImp=floor(SegImp);
        
   
        
        plotm(DEImp(j),LongImp(j),'.','MarkerSize',20,'Color','k');
       
        TextImp=sprintf(['  ',NombresImp(j,:),' %02.0f:%02.0f:%02.0f '] ,[HorasImp,MinImp,SegImp]);
        textm(DEImp(j),LongImp(j),TextImp,'Color','r');
    end
else
    disp('No se presentan Impactos');
 end
function RadTierra=radio_tierra(lat)
a=6378.1370;
b=6356.7523;
RadTierra=sqrt(((a^2.*cosd(lat)).^2+(b^2.*sind(lat)).^2)./((a.*cosd(lat)).^2+(b.*sind(lat)).^2));

function checkbox_impact_Callback(hObject, eventdata, handles)




function edit_imp_Callback(hObject, eventdata, handles)

function edit_imp_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Ayuda_Callback(hObject, eventdata, handles)
switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
        system([observador.directorio1,'\orbit_calc_manual.pdf']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
        system([observador.directorio1,'\orbit_calc_manual.pdf']);
end


