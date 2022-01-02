function varargout = Configuracion(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Configuracion_OpeningFcn, ...
                   'gui_OutputFcn',  @Configuracion_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Configuracion is made visible.
function Configuracion_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(handles.ubicacion_button_group,'SelectionChangeFcn',@ubicacion_button_group_SelectionChangeFcn);

switch true

    case ispc
        if exist([getenv('APPDATA'),'\orbit_calc2.0\observer.mat'], 'file')==0
            load('observer.mat')
        else    
            load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
        end
    case isunix
        if exist([getenv('HOME'),'/.orbit_calc2.0/observer.mat'], 'file')==0
            load('observer.mat')
        else
            load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
        end
        
        
end
        

        
        

set(handles.edit_nombre,'String',observador.name_obs);
if ~isempty(observador.cod)
    set(handles.radiobutton_codigo_v,'Value',1.0);
    set(handles.edit_codigo,'String',observador.cod);
else
    set(handles.radiobutton_codigo_falso,'Value',1.0);
    if observador.Latitude<0
        hemisferio='S';
    else
        hemisferio='N';
    end
    Latitud_string=degree2dms(observador.Latitude);
    Latitud_string=[num2str(Latitud_string(1)),' ',num2str(Latitud_string(2)),' ',num2str(Latitud_string(3))];

    if observador.Longitude>180
        Longitude=360-observador.Longitude;
        EO='E';
    else
        EO='O';
    end
    Longitud_string=degree2dms(observador.Longitude);
    Longitud_string=[num2str(Longitud_string(1)),' ',num2str(Longitud_string(2)),' ',num2str(Longitud_string(3))];

    set(handles.edit_lat,'String',Latitud_string);
    set(handles.edit_hemisferio,'String',hemisferio);
    set(handles.edit_longitud,'String',Longitud_string);
    set(handles.edit_EO,'String',EO);
    set(handles.edit_altura,'String',observador.Altitude);
end
set(handles.edit_zonahoraria,'String',num2str(observador.UToffset));
set(handles.edit_directorio1,'String',observador.directorio1);
set(handles.edit_ucac4,'String',observador.directorio_ucac4);
set(handles.edit_directorio,'String',observador.directorio);
set(handles.edit_distancia_focal,'String',num2str(observador.focal));
set(handles.edit_sensor_ancho,'String',num2str(fix(observador.fov(1)*60/observador.res)));
set(handles.edit_sensor_alto,'String',num2str(fix(observador.fov(2)*60/observador.res)));
set(handles.edit_pixel_ancho,'String',num2str(tand(observador.res/3600)*observador.focal*1000));
set(handles.edit_pixel_alto,'String',num2str(tand(observador.res/3600)*observador.focal*1000));

switch observador.cat_activo
    case 'UCAC4'
        set(handles.rd_UCAC4,'Value',1.0);
        set(handles.rb_internet,'Value',0.0);
    otherwise
        set(handles.rd_UCAC4,'Value',0.0);
        set(handles.rb_internet,'Value',1.0);
%        set(handles.pm_catalogo,'Value',1);
%         switch observador.cat_activo(10:end);
%             case 'UCAC3'
%                 set(handles.pm_catalogo,'Value',1);
%             case 'CMC14'
%                 set(handles.pm_catalogo,'Value',2);
%             case 'USNOA2'
%                 set(handles.pm_catalogo,'Value',4);
%             case 'PPMXL'
%                 set(handles.pm_catalogo,'Value',3);
%             case 'UCAC4'
%                 set(handles.pm_catalogo,'Value',5);
%         end
end
guidata(hObject, handles);



function varargout = Configuracion_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function edit_nombre_Callback(hObject, eventdata, handles)
name_obs=get(handles.edit_nombre,'String');

function edit_nombre_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_codigo_Callback(hObject, eventdata, handles)


function edit_codigo_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_lat_Callback(hObject, eventdata, handles)
function edit_lat_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_hemisferio_Callback(hObject, eventdata, handles)
function edit_hemisferio_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_longitud_Callback(hObject, eventdata, handles)
function edit_longitud_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_EO_Callback(hObject, eventdata, handles)


function edit_EO_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_altura_Callback(hObject, eventdata, handles)


function edit_altura_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function radiobutton1_Callback(hObject, eventdata, handles)
function edit_zonahoraria_Callback(hObject, eventdata, handles)


function edit_zonahoraria_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit12_Callback(hObject, eventdata, handles)


function edit12_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function dir1_pushbutton_Callback(hObject, eventdata, handles)
directorio = uigetdir;
set(handles.edit_directorio,'String',directorio);










function edit_distancia_focal_Callback(hObject, eventdata, handles)
function edit_distancia_focal_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_pixel_ancho_Callback(hObject, eventdata, handles)


function edit_pixel_ancho_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_sensor_alto_Callback(hObject, eventdata, handles)
function edit_sensor_alto_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit19_Callback(hObject, eventdata, handles)
function edit19_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_pixel_alto_Callback(hObject, eventdata, handles)
function edit_pixel_alto_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function edit_directorio_Callback(hObject, eventdata, handles)



function edit_directorio_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function pushbutton_dir_oc_Callback(hObject, eventdata, handles)
directorio1 = uigetdir;
set(handles.edit_directorio1,'String',directorio1);





function edit_directorio1_Callback(hObject, eventdata, handles)
function edit_directorio1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




function pushbutton_guardar_Callback(hObject, eventdata, handles)

observador.directorio1=get(handles.edit_directorio1,'String');
observador.directorio=get(handles.edit_directorio,'String');
observador.directorio_ucac4=get(handles.edit_ucac4,'String');
observador.name_obs=get(handles.edit_nombre,'String');
observador.UToffset=str2num(get(handles.edit_zonahoraria,'String'));
observador.focal=str2num(get(handles.edit_distancia_focal,'String'));
long_sensor1=str2num(get(handles.edit_sensor_ancho,'String'));
long_sensor2=str2num(get(handles.edit_sensor_alto,'String'));
pixel1=str2num(get(handles.edit_pixel_ancho,'String'));
pixel2=str2num(get(handles.edit_pixel_alto,'String'));
observador.res1=atand(pixel1*1e-3/observador.focal)*3600;
observador.res2=atand(pixel2*1e-3/observador.focal)*3600;
observador.res=min(observador.res1,observador.res2);
fov1=long_sensor1*observador.res1/60;
fov2=long_sensor2*observador.res2/60;
observador.fov=[fov1,fov2];
observador.cod=get(handles.edit_codigo,'String');
es_vacio_cod=isempty(observador.cod);
%observador.cat_activo=get(handles.rd_UCAC3,'Value');

switch true
    case get(handles.rd_UCAC4,'Value')
        observador.cat_activo='UCAC4';
    otherwise
        observador.cat_activo='Internet';
        Valor=get(handles.pm_catalogo,'Value');
        Catalogo=get(handles.pm_catalogo,'String');
        Catalogo=Catalogo(Valor,:);
        observador.cat_activo=[observador.cat_activo,'-',Catalogo];
        
        
end

switch es_vacio_cod   % Get Tag of selected object
    case 0
        switch true
            case ispc
                load([observador.directorio1,'\obscod.mat']);
            case isunix
                load([observador.directorio1,'/obscod.mat']);
        end
        ind=strmatch(observador.cod,code_all);
        observador.pcos=cosc_all(ind);
        observador.psin=sinc_all(ind);
        observador.Longitude=Long_all(ind);
        observador.name_obs=nameobs_all(ind,:);
        
     case 1
        
        Altitude=str2num(get(handles.edit_altura,'String'));
        Longitude=str2num(get(handles.edit_longitud,'String'));
        correct_longitud=get(handles.edit_EO,'String');
        if correct_longitud=='E';
            observador.Longitude=Longitude(1)+Longitude(2)/60+Longitude(3)/3600;
        elseif correct_longitud=='O';
            observador.Longitude=360-(Longitude(1)+Longitude(2)/60+Longitude(3)/3600);
        end
        
        Latitude=str2num(get(handles.edit_lat,'String'));
        Latitude=(Latitude(1)+Latitude(2)/60+Latitude(3)/3600);
        correct_lat=get(handles.edit_hemisferio,'String');
        if correct_lat=='S';
            Latitude=-Latitude;
        end
        observador.Latitude=Latitude;
        observador.Altitude=Altitude;
        [pcos psin]=observer_location(Latitude, Altitude);
        observador.pcos=pcos;
        observador.psin=psin;
end
switch true
    case ispc
        DatosAplicaciones = getenv('APPDATA');
        DatosAplicaciones=[DatosAplicaciones,'\orbit_calc2.0'];
        if ~isdir(DatosAplicaciones)
            mkdir(DatosAplicaciones)
        end
        save([DatosAplicaciones,'\observer.mat'],'observador');
    case isunix
        DatosAplicaciones = getenv('HOME');
        DatosAplicaciones=[DatosAplicaciones,'/.orbit_calc2.0'];
        if ~isdir(DatosAplicaciones)
            mkdir(DatosAplicaciones)
        end
        save([DatosAplicaciones,'/observer.mat'],'observador');
end



addpath(observador.directorio1);
savepath;

function pushbutton_cancelar_Callback(hObject, eventdata, handles)
close(Configuracion);

function ubicacion_button_group_SelectionChangeFcn(hObject, eventdata)
 
handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton_codigo_v'
    set(handles.edit_lat,'String','');
    set(handles.edit_hemisferio,'String','');
    set(handles.edit_longitud,'String','');
    set(handles.edit_EO,'String','');
    set(handles.edit_altura,'String','');
 
    case 'radiobutton_codigo_falso'
    set(handles.edit_codigo,'String','');
    set(handles.edit_lat,'String','00 00 00');
    set(handles.edit_hemisferio,'String','S');
    set(handles.edit_longitud,'String','00 00 00');
    set(handles.edit_EO,'String','E');
    set(handles.edit_altura,'String','0');
end
guidata(hObject, handles);


function pushbutton_salir_Callback(hObject, eventdata, handles)
close(Configuracion);





% --------------------------------------------------------------------
function Descargas_Callback(hObject, eventdata, handles)
function Mpcorb_Callback(hObject, eventdata, handles)
Mensaje=warndlg('Sea paciente, no cierre el programa','Descargando MPCORB.dat');
urlwrite('http://www.minorplanetcenter.net/iau/MPCORB/MPCORB.DAT.gz','MPCORB.DAT.gz');
switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end


gunzip('MPCORB.DAT.gz',observador.directorio);
base;
delete('MPCORB.DAT.gz')
close(Mensaje);



function Comet_Callback(hObject, eventdata, handles)
Mensaje=warndlg('Sea paciente, no cierre el programa','Descargando COMET.dat');
switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end

switch true
    case ispc
        camino=[observador.directorio,'\COMET.dat'];
    case isunix
        camino=[observador.directorio,'/COMET.dat'];
end


urlwrite('http://www.minorplanetcenter.net/iau/MPCORB/CometEls.txt',camino);
close(Mensaje);
base_com;



% --------------------------------------------------------------------
function Codigos_Callback(hObject, eventdata, handles)


switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end


mensaj1=warndlg('bajando codigos de observatorios');
codes=urlread('http://www.minorplanetcenter.net/iau/lists/ObsCodes.html');
fid=fopen('obscod.txt','w');
fprintf(fid,codes);
fclose(fid);
fid=fopen('obscod.txt');
codes=textscan(fid,'%[^\n]');
codes=char(codes{1});
codes(1:2,:)=[];
[f c]=size(codes);
codes(f,:)=[];
eliminar=strmatch('        ',codes(1:f-1,14:21));
codes(eliminar,:)=[];
[f c]=size(codes);
code_all=codes(1:f,1:3);
Long_all=str2num(codes(1:f,5:13));
cosc_all=str2num(codes(1:f,14:21));
sinc_all=str2num(codes(1:f,22:30));
nameobs_all=codes(1:f,31:78);
fclose(fid);
clc;
switch true
    case ispc
         save([observador.directorio1,'\obscod.mat'],'code_all','Long_all','cosc_all','sinc_all','nameobs_all');
    case isunix
        save([observador.directorio1,'/obscod.mat'],'code_all','Long_all','cosc_all','sinc_all','nameobs_all');
end
delete('obscod.txt');
close(mensaj1);



% --------------------------------------------------------------------
function Efemerides_Callback(hObject, eventdata, handles)
Efemerides;
close(Configuracion);

% --------------------------------------------------------------------
function filtro_Callback(hObject, eventdata, handles)
filtro;
close(Configuracion);


% --------------------------------------------------------------------
function Ayuda_Callback(hObject, eventdata, handles)

switch true
    case ispc
        
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
        system([observador.directorio1,'\orbit_calc_manual.pdf']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
        system([observador.directorio1,'/orbit_calc_manual.pdf']);
end


function edit_ucac4_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function edit_ucac4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_ucac2.
function pb_ucac2_Callback(hObject, eventdata, handles)
directorio_ucac4 = uigetdir;
set(handles.edit_ucac4,'String',directorio_ucac4);


% --- Executes on selection change in pm_catalogo.
function pm_catalogo_Callback(hObject, eventdata, handles)
% hObject    handle to pm_catalogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_catalogo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_catalogo


% --- Executes during object creation, after setting all properties.
function pm_catalogo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_catalogo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



