function varargout = filtro(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filtro_OpeningFcn, ...
                   'gui_OutputFcn',  @filtro_OutputFcn, ...
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

function filtro_OpeningFcn(hObject, eventdata, handles, varargin)

    global asteroides;
    
    switch true
        case ispc
            load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
            load([observador.directorio1,'\asteroides.mat']);
        case isunix
            load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
            load([observador.directorio1,'/asteroides.mat']);
    end



   
    hoy=now;
    hoy=hoy+1721058.5-observador.UToffset/24;
    [Anio Mes Dia]=jul2gre(hoy);
    [dias horas minutos segundos]=d2dhs(Dia);
    Anio=num2str(Anio);
    Mes=num2str(Mes);
    dias=num2str(dias);
    horas=num2str(horas);
    minutos=num2str(minutos);
    segundos='0';
    set(handles.fecha_ano,'String',Anio);
    set(handles.fecha_mes,'String',Mes);
    set(handles.fecha_dia,'String',dias);
    set(handles.fecha_hora,'String',horas);
    set(handles.fecha_minutos,'String',minutos);
    set(handles.codigo,'String',observador.cod);

    
    handles.output = hObject;
    guidata(hObject, handles);




% --- Outputs from this function are returned to the command line.
function varargout = filtro_OutputFcn(hObject, eventdata, handles) 


varargout{1} = handles.output;


function AR1_Callback(hObject, eventdata, handles)



guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function AR1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function DE1_Callback(hObject, eventdata, handles)

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function DE1_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function DE2_Callback(hObject, eventdata, handles)

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function DE2_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function AR2_Callback(hObject, eventdata, handles)

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function AR2_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function mag_Callback(hObject, eventdata, handles)
% hObject    handle to mag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mag as text
%        str2double(get(hObject,'String')) returns contents of mag as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function mag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton_buscar.
function pushbutton_buscar_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_buscar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



ARa = str2num(get(handles.AR1,'String'));
ARb = str2num(get(handles.AR2,'String'));
DEa = str2num(get(handles.DE1,'String'));
DEb = str2num(get(handles.DE2,'String'));
maga = str2num(get(handles.mag,'String'));
AsRe1=(ARa(1)+ARa(2)/60+ARa(3)/3600);
AsRe2=(ARb(1)+ARb(2)/60+ARb(3)/3600);
if DEa(1)<0
    Dec1=-(-DEa(1)+DEa(2)/60+DEa(3)/3600);
else
    Dec1=(DEa(1)+DEa(2)/60+DEa(3)/3600); 
end
if DEb(1)<0
    Dec2=-(-DEb(1)+DEb(2)/60+DEb(3)/3600);
else
    Dec2=(DEb(1)+DEb(2)/60+DEb(3)/3600); 
end

elong_solar = str2num(get(handles.edit_elong_solar,'String'));
elong_lunar = str2num(get(handles.edit_elong_lunar,'String'));
varargin_oc={};

    aaaa=str2num(get(handles.fecha_ano,'String'));
    mm=str2num(get(handles.fecha_mes,'String'));
    dd=str2num(get(handles.fecha_dia,'String'));
    hh=str2num(get(handles.fecha_hora,'String'));
    mmm=str2num(get(handles.fecha_minutos,'String'));
    varargin_oc={varargin_oc{:},'date',aaaa,mm,dd+hh/24+mmm/(24*60)};
    



switch get(handles.clase,'Value')
    case 1
        clase='';
    case 2
        clase='neos';
    case 3
        clase='mars cross';
    case 4
        clase='main belt';
    case 5
        clase='hilda';
    case 6
        clase='jupiter troyan';
    case 7
        clase='distante';

    otherwise
        
end

if isempty(clase)==0
    varargin_oc={varargin_oc{:},clase};
end

checkboxStatus = get(handles.opo,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    nro_ops1=str2num(get(handles.nro_ops1,'String'));
    nro_ops2=str2num(get(handles.nro_ops2,'String'));
    varargin_oc={varargin_oc{:},'num ops',[nro_ops1,nro_ops2]};
end

checkboxStatus = get(handles.ult_obs_checkbox,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    ult_obs_1=str2num(get(handles.ult_obs1,'String'));
    ult_obs_2=str2num(get(handles.ult_obs2,'String'));
    varargin_oc={varargin_oc{:},'last obs',[ult_obs_2,ult_obs_1]};
end
checkboxStatus = get(handles.U,'Value');
if(checkboxStatus)
    U_min1=str2num(get(handles.U_min,'String'));
    U_max1=str2num(get(handles.U_max,'String'));
    varargin_oc={varargin_oc{:},'U',[U_min1,U_max1]};
end
checkboxStatus = get(handles.arco_checkbox,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    arco_1=str2num(get(handles.arco1,'String'));
    arco_2=str2num(get(handles.arco2,'String'));
    varargin_oc={varargin_oc{:},'arc',[arco_1,arco_2]};
end



checkboxStatus = get(handles.IncreArco,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    Porcent=str2num(get(handles.EditPorcent,'String'));
    varargin_oc={varargin_oc{:},'IncrArc',Porcent};
end


    cod=get(handles.codigo,'String');
    varargin_oc={varargin_oc{:},'cod',cod};



radioStatus = get(handles.html_radiobutton,'Value');
if(radioStatus)
    %if box is checked, text is set to bold
    varargin_oc={varargin_oc{:},'html'};
end

radioStatus = get(handles.carts_radiobutton,'Value');
if(radioStatus)
    %if box is checked, text is set to bold
    varargin_oc={varargin_oc{:},'ciel'};
end




checkboxStatus = get(handles.checkbox_semieje,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    semieje1=str2num(get(handles.edit_oe_min_a,'String'));
    semieje2=str2num(get(handles.edit_oe_max_a,'String'));
    varargin_oc={varargin_oc{:},'a',[semieje1,semieje2]};
end


checkboxStatus = get(handles.checkbox_excentricidad,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    e1=str2num(get(handles.edit_ex_min,'String'));
    e2=str2num(get(handles.edit_ex_max,'String'));
    varargin_oc={varargin_oc{:},'e',[e1,e2]};
end

checkboxStatus = get(handles.checkbox_inclinacion,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    incli1=str2num(get(handles.edit_incli_min,'String'));
    incli2=str2num(get(handles.edit_incli_max,'String'));
    varargin_oc={varargin_oc{:},'incli',[incli1,incli2]};
end

checkboxStatus = get(handles.checkbox_rango_numeracion,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    numer1=str2num(get(handles.edit_numerados_min,'String'));
    numer2=str2num(get(handles.edit_numerados_max,'String'));
    varargin_oc={varargin_oc{:},'numerados',[numer1,numer2]};
end


cantidad=bodysearch(AsRe1,AsRe2,Dec1,Dec2,maga,elong_solar,elong_lunar,varargin_oc{:});

set(handles.text_cant_hallados,'String',[num2str(cantidad),' ','asteroides hallados']);
set(handles.text_cant_hallados,'Visible','on');
% orbit_calc('filtro',texto_busqueda,coordenadas_radianes,designacion,fecha);
guidata(hObject, handles);


% --- Executes on selection change in clase.
function clase_Callback(hObject, eventdata, handles)
% hObject    handle to clase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns clase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from clase


% --- Executes during object creation, after setting all properties.





function clase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in opo.
function opo_Callback(hObject, eventdata, handles)
% hObject    handle to opo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of opo





function nro_ops1_Callback(hObject, eventdata, handles)
% hObject    handle to nro_ops1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nro_ops1 as text
%        str2double(get(hObject,'String')) returns contents of nro_ops1 as a double


% --- Executes during object creation, after setting all properties.
function nro_ops1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nro_ops1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function nro_ops2_Callback(hObject, eventdata, handles)
% hObject    handle to nro_ops2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nro_ops2 as text
%        str2double(get(hObject,'String')) returns contents of nro_ops2 as a double


% --- Executes during object creation, after setting all properties.
function nro_ops2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nro_ops2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in ult_obs_checkbox.
function ult_obs_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to ult_obs_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ult_obs_checkbox



function ult_obs1_Callback(hObject, eventdata, handles)
% hObject    handle to ult_obs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ult_obs1 as text
%        str2double(get(hObject,'String')) returns contents of ult_obs1 as a double


% --- Executes during object creation, after setting all properties.
function ult_obs1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ult_obs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ult_obs2_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function ult_obs2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in U.
function U_Callback(hObject, eventdata, handles)
% hObject    handle to U (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of U


% --- Executes on selection change in U_min.
function U_min_Callback(hObject, eventdata, handles)
% hObject    handle to U_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns U_min contents as cell array
%        contents{get(hObject,'Value')} returns selected item from U_min


% --- Executes during object creation, after setting all properties.
function U_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to U_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in U_max.
function U_max_Callback(hObject, eventdata, handles)
% hObject    handle to U_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns U_max contents as cell array
%        contents{get(hObject,'Value')} returns selected item from U_max


% --- Executes during object creation, after setting all properties.
function U_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to U_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in arco_checkbox.
function arco_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to arco_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of arco_checkbox



function arco1_Callback(hObject, eventdata, handles)
% hObject    handle to arco1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of arco1 as text
%        str2double(get(hObject,'String')) returns contents of arco1 as a double


% --- Executes during object creation, after setting all properties.
function arco1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arco1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function arco2_Callback(hObject, eventdata, handles)
% hObject    handle to arco2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of arco2 as text
%        str2double(get(hObject,'String')) returns contents of arco2 as a double


% --- Executes during object creation, after setting all properties.
function arco2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arco2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in fecha_checkbox.
function fecha_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fecha_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fecha_checkbox



function fecha_ano_Callback(hObject, eventdata, handles)
% hObject    handle to fecha_ano (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fecha_ano as text
%        str2double(get(hObject,'String')) returns contents of fecha_ano as a double


% --- Executes during object creation, after setting all properties.
function fecha_ano_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fecha_ano (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fecha_mes_Callback(hObject, eventdata, handles)
% hObject    handle to fecha_mes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fecha_mes as text
%        str2double(get(hObject,'String')) returns contents of fecha_mes as a double


% --- Executes during object creation, after setting all properties.
function fecha_mes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fecha_mes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fecha_dia_Callback(hObject, eventdata, handles)
% hObject    handle to fecha_dia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fecha_dia as text
%        str2double(get(hObject,'String')) returns contents of fecha_dia as a double


% --- Executes during object creation, after setting all properties.
function fecha_dia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fecha_dia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fecha_hora_Callback(hObject, eventdata, handles)
% hObject    handle to fecha_hora (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fecha_hora as text
%        str2double(get(hObject,'String')) returns contents of fecha_hora as a double


% --- Executes during object creation, after setting all properties.
function fecha_hora_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fecha_hora (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fecha_minutos_Callback(hObject, eventdata, handles)
% hObject    handle to fecha_minutos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fecha_minutos as text
%        str2double(get(hObject,'String')) returns contents of fecha_minutos as a double


% --- Executes during object creation, after setting all properties.
function fecha_minutos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fecha_minutos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in cod_checkbox.
function cod_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cod_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cod_checkbox



function codigo_Callback(hObject, eventdata, handles)
% hObject    handle to codigo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of codigo as text
%        str2double(get(hObject,'String')) returns contents of codigo as a double


% --- Executes during object creation, after setting all properties.
function codigo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to codigo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end









% --- Executes on button press in pushbutton_pushbutton_guardar.
function pushbutton_guardar_Callback(hObject, eventdata, handles)
[nombre_archivo, camino]=uiputfile('mpcorb_b.mat','Guardar Archivo de Elementos');
set(handles.text_cant_hallados,'String','Espere por favor...');
set(handles.text_cant_hallados,'Visible','on');
% hObject    handle to pushbutton_pushbutton_guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargin_oc={};
switch get(handles.clase,'Value')
    case 1
        clase='';
    case 2
        clase='neos'
    case 3
        clase='mars cross'
    case 4
        clase='main belt'
    case 5
        clase='hilda'
    case 6
        clase='jupiter troyan'
    case 7
        clase='centaur'
    case 8
        clase='TNO'
    otherwise
        
end

if isempty(clase)==0
    varargin_oc={varargin_oc{:},clase}
end

checkboxStatus = get(handles.opo,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    nro_ops1=str2num(get(handles.nro_ops1,'String'));
    nro_ops2=str2num(get(handles.nro_ops2,'String'));
    varargin_oc={varargin_oc{:},'num ops',[nro_ops1,nro_ops2]};
end

checkboxStatus = get(handles.ult_obs_checkbox,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    ult_obs_1=str2num(get(handles.ult_obs1,'String'));
    ult_obs_2=str2num(get(handles.ult_obs2,'String'));
    varargin_oc={varargin_oc{:},'last obs',[ult_obs_2,ult_obs_1]};
end
checkboxStatus = get(handles.U,'Value');
if(checkboxStatus)
    U_min1=get(handles.U_min,'Value');
    U_max1=get(handles.U_max,'Value');
    if U_min1==1 | U_min1==2
        U_min1=0;
    else
        U_min1=U_min1-2;
    end
    if U_max1==1 
        U_max1=9;
    else
        U_max1=U_max1-2;
    end
    varargin_oc={varargin_oc{:},'U',[U_min1,U_max1]};
end
checkboxStatus = get(handles.arco_checkbox,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    arco_1=str2num(get(handles.arco1,'String'));
    arco_2=str2num(get(handles.arco2,'String'));
    varargin_oc={varargin_oc{:},'arc',[arco_1,arco_2]};
end

checkboxStatus = get(handles.checkbox_semieje,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    semieje1=str2num(get(handles.edit_oe_min_a,'String'));
    semieje2=str2num(get(handles.edit_oe_max_a,'String'));
    varargin_oc={varargin_oc{:},'a',[semieje1,semieje2]};
end


checkboxStatus = get(handles.checkbox_excentricidad,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    e1=str2num(get(handles.edit_ex_min,'String'));
    e2=str2num(get(handles.edit_ex_max,'String'));
    varargin_oc={varargin_oc{:},'e',[e1,e2]};
end

checkboxStatus = get(handles.checkbox_inclinacion,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    incli1=str2num(get(handles.edit_incli_min,'String'));
    incli2=str2num(get(handles.edit_incli_max,'String'));
    varargin_oc={varargin_oc{:},'incli',[incli1,incli2]};
end

checkboxStatus = get(handles.checkbox_rango_numeracion,'Value');
if(checkboxStatus)
    %if box is checked, text is set to bold
    numer1=str2num(get(handles.edit_numerados_min,'String'));
    numer2=str2num(get(handles.edit_numerados_max,'String'));
    varargin_oc={varargin_oc{:},'numerados',[numer1,numer2]};
end

cantidad=extract_bodies([camino,'\',nombre_archivo],varargin_oc{:});

set(handles.text_cant_hallados,'String',[num2str(cantidad),' ','asteroides hallados']);
set(handles.text_cant_hallados,'Visible','on');



% --- Executes on button press in pushbutton_salir.
function pushbutton_salir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_salir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(filtro);



% --- Executes on button press in checkbox_semieje.
function checkbox_semieje_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_semieje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_semieje




% --- Executes on button press in checkbox_excentricidad.
function checkbox_excentricidad_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_excentricidad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_excentricidad


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox_rango_numeracion.
function checkbox_rango_numeracion_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rango_numeracion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rango_numeracion



function edit_oe_min_a_Callback(hObject, eventdata, handles)
% hObject    handle to edit_oe_min_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_oe_min_a as text
%        str2double(get(hObject,'String')) returns contents of edit_oe_min_a as a double


% --- Executes during object creation, after setting all properties.
function edit_oe_min_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_oe_min_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_oe_max_a_Callback(hObject, eventdata, handles)
% hObject    handle to edit_oe_max_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_oe_max_a as text
%        str2double(get(hObject,'String')) returns contents of edit_oe_max_a as a double


% --- Executes during object creation, after setting all properties.
function edit_oe_max_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_oe_max_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ex_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ex_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ex_min as text
%        str2double(get(hObject,'String')) returns contents of edit_ex_min as a double


% --- Executes during object creation, after setting all properties.
function edit_ex_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ex_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_ex_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ex_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ex_max as text
%        str2double(get(hObject,'String')) returns contents of edit_ex_max as a double


% --- Executes during object creation, after setting all properties.
function edit_ex_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ex_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_incli_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_incli_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_incli_min as text
%        str2double(get(hObject,'String')) returns contents of edit_incli_min as a double


% --- Executes during object creation, after setting all properties.
function edit_incli_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_incli_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_incli_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_incli_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_incli_max as text
%        str2double(get(hObject,'String')) returns contents of edit_incli_max as a double


% --- Executes during object creation, after setting all properties.
function edit_incli_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_incli_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_numerados_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numerados_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numerados_min as text
%        str2double(get(hObject,'String')) returns contents of edit_numerados_min as a double


% --- Executes during object creation, after setting all properties.
function edit_numerados_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numerados_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_numerados_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numerados_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numerados_max as text
%        str2double(get(hObject,'String')) returns contents of edit_numerados_max as a double


% --- Executes during object creation, after setting all properties.
function edit_numerados_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numerados_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function edit_elong_solar_Callback(hObject, eventdata, handles)
% hObject    handle to edit_elong_solar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_elong_solar as text
%        str2double(get(hObject,'String')) returns contents of edit_elong_solar as a double


% --- Executes during object creation, after setting all properties.
function edit_elong_solar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_elong_solar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_elong_lunar_Callback(hObject, eventdata, handles)
% hObject    handle to edit_elong_lunar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_elong_lunar as text
%        str2double(get(hObject,'String')) returns contents of edit_elong_lunar as a double


% --- Executes during object creation, after setting all properties.
function edit_elong_lunar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_elong_lunar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in carts_radiobutton.
function carts_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to carts_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of carts_radiobutton





function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to nro_ops2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nro_ops2 as text
%        str2double(get(hObject,'String')) returns contents of nro_ops2 as a double


% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nro_ops2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function checkbox_inclinacion_Callback(hObject, eventdata, handles)









function html_radiobutton_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Efemerides_Callback(hObject, eventdata, handles)
Efemerides;
close(filtro);


function Configuracion_Callback(hObject, eventdata, handles)
Configuracion;
close(filtro);


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


% --- Executes on button press in IncreArco.
function IncreArco_Callback(hObject, eventdata, handles)
% hObject    handle to IncreArco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IncreArco



function EditPorcent_Callback(hObject, eventdata, handles)
% hObject    handle to EditPorcent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditPorcent as text
%        str2double(get(hObject,'String')) returns contents of EditPorcent as a double


% --- Executes during object creation, after setting all properties.
function EditPorcent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditPorcent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
