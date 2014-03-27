%Funcion base_com lee COMET.dat y los transforma en la base de matlab
%comet.dat. La variable
function base_com
progreso=waitbar(0,'Leyendo comet.dat...');


switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
        esta_comet=dir([observador.directorio,'\comet.dat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
        esta_comet=dir([observador.directorio,'/COMET.dat']);
end





if isempty(esta_comet)
    disp('comet.dat no fue hallado');
    return
end

switch true
    case ispc
        cometasfida = fopen([observador.directorio,'\comet.dat']);
    case isunix
        cometasfida = fopen([observador.directorio,'/COMET.dat']);
end



 
 nombres=textscan(cometasfida,'%s%*[^\n]');
 fclose(cometasfida);

 nombres=char(nombres{1});

 switch true
     case ispc
         cometasfid=fopen([observador.directorio,'\comet.dat']);
     case isunix
         cometasfid=fopen([observador.directorio,'/COMET.dat']);
 end



linea=fgetl(cometasfid);
cometasdat=[];
while length(linea)>1;
   cometasdat=char(cometasdat,linea);
   linea=fgetl(cometasfid);
end

[cant,~]=size(cometasdat);
cometasdat=cometasdat(2:cant,:);
cant=cant-1;

clear epoca;

anioperi=str2num(cometasdat(:,15:18));
mesperi=str2num(cometasdat(:,20:21));
diaperi=str2num(cometasdat(:,23:29));
pas_peri=gre2jul(diaperi,mesperi,anioperi);

epoca=gre2jul(str2num(cometasdat(:,88:89)),str2num(cometasdat(:,86:87)),str2num(cometasdat(:,82:85)));
epoca=mode(epoca);





q=str2num(cometasdat(:,31:39));
e=str2num(cometasdat(:,42:49));
peri=str2num(cometasdat(:,52:59));
node=str2num(cometasdat(:,62:69));
incli=str2num(cometasdat(:,72:79));
H=str2num(cometasdat(:,92:95));
G=str2num(cometasdat(:,97:100));

designacion=cometasdat(:,103:150);

fclose(cometasfid);



k2=0.000295912208285591;
V=(k2.*(e+1)./q).^.5;
pos=[q,zeros(length(V),1),zeros(length(V),1)];
posdot=[zeros(length(V),1),V,zeros(length(V),1)];
R=[cosd(node).*cosd(peri)-sind(node).*cosd(incli).*sind(peri), -cosd(node).*sind(peri)-sind(node).*cosd(incli).*cosd(peri), sind(node).*sind(incli);
  sind(node).*cosd(peri)+cosd(node).*cosd(incli).*sind(peri), -sind(node).*sind(peri)+cosd(node).*cosd(incli).*cosd(peri), -cosd(node).*sind(incli);
  sind(incli).*sind(peri),                                    sind(incli).*cosd(peri)                                       cosd(incli)              ];
for j=1:length(V)
    pos(j,:)=pos(j,:)*(R([j, j+length(V), j+2*length(V)],:))';
    posdot(j,:)=posdot(j,:)*(R([j, j+length(V), j+2*length(V)],:))';
end






parametros.iter=3;
parametros.orden=10;
parametros.tol=1e-22;
parametros.paso=.01;



for j=1:cant;
    
    leyenda_barra=sprintf('%s %s','Procesando', designacion(j,:));
    waitbar(j/cant,progreso,leyenda_barra);
    %funcion=@fuerza_nb;
    funcion=@fuerzaDE_2b;
    [pos_nueva,vel_nueva]=colocacion_nb_adap(funcion, k2,epoca,pos(j,:),posdot(j,:),pas_peri(j),parametros);
    cometas.posiciones(j,:)=pos_nueva;
    cometas.velocidades(j,:)=vel_nueva;
end


cometas.epocas=epoca;
cometas.H=H;
cometas.G=G;
cometas.nombres=nombres;
cometas.designacion=designacion;


switch true
    case ispc
        save([observador.directorio1,'\cometas.mat'],'cometas');
    case isunix
        save([observador.directorio1,'/cometas.mat'],'cometas');
end
disp(sprintf('%d %s',cant, 'cometas procesados'));  
close(progreso);
