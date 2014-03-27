function varargout=extract_bodies(camino,varargin)
clc;
global asteroides;
switch true
    case ispc
        load([getenv('APPDATA'),'\orbit_calc2.0\observer.mat']);
    case isunix
        load([getenv('HOME'),'/.orbit_calc2.0/observer.mat']);
end
load('obscod.mat');

   

size_mpc=length(asteroides.H);
filtro=1:size_mpc;
filtro_filtro=filtro;

    
    
    for j=1:length(varargin);
        is_chart=ischar(varargin{j});
        if is_chart==1
            neos=strmatch('neos',varargin{j});
            neost=isempty(neos);
            if neost==0
                clasedec=hex2dec(asteroides.clase(filtro,3:4));
               filtro_filtro=find(clasedec==2|clasedec==3|clasedec==4);
               filtro=filtro(filtro_filtro);
            end
            mains=strmatch('main belt',varargin{j});
            mainst=isempty(mains);
            if mainst==0
                clasedec=hex2dec(clase(filtro,3:4));
                filtro_filtro=find(clasedec==0|clasedec==1);
                filtro=filtro(filtro_filtro);
            end
            marsc=strmatch('mars cross',varargin{j});
            marsct=isempty(marsc);
            if marsct==0
                 clasedec=hex2dec(clase(filtro,3:4));
                 filtro_filtro=find(clasedec==5|clasedec==6|clasedec==7);
                 filtro=filtro(filtro_filtro);
            end
            hilda=strmatch('hilda',varargin{j});
            hildat=isempty(hilda);
            if hildat==0
                clasedec=hex2dec(asteroides.clase(filtro,3:4));
                filtro_filtro=find(clasedec==8);
                filtro=filtro(filtro_filtro);
            end
            jupitert=strmatch('jupiter troyan',varargin{j});
            jupitertt=isempty(jupitert);
            if jupitertt==0
                 clasedec=hex2dec(asteroides.clase(filtro,3:4));
                 filtro_filtro=find(clasedec==9);
                 filtro=filtro(filtro_filtro);
            end
            centaur=strmatch('centaur',varargin{j});
            centaurt=isempty(centaur);
            if centaurt==0
                 clasedec=hex2dec(clase(filtro,3:4));
                 filtro_filtro=find(clasedec==10);
                 filtro=filtro(filtro_filtro);
            end
            transnep=strmatch('TNO',varargin{j});
            transnept=isempty(transnep);
            if transnept==0
                 clasedec=hex2dec(clase(filtro,3:4));
                 filtro_filtro=find(clasedec==14 | clasedec==15 | clasedec==16 | clasedec==17  );
                 filtro=filtro(filtro_filtro);
            end
            ult_obs=strmatch('last obs',varargin{j});
            ult_obst=isempty(ult_obs);
            if ult_obst==0 & length(varargin{j+1})==1
                
                filtro_filtro=find(ultobs(filtro)<=gre2jul(Dia,Mes,Anio)-varargin{j+1}*365.25);
                filtro=filtro(filtro_filtro);
            elseif  ult_obst==0 & length(varargin{j+1})==2
                 filtro_filtro=find(ultobs(filtro)<=gre2jul(Dia,Mes,Anio)-varargin{j+1}(2)*365.25  & ultobs(filtro)>=gre2jul(Dia,Mes,Anio)-varargin{j+1}(1)*365.25);
                filtro=filtro(filtro_filtro);
                
            end
            num_ops=strmatch('num ops',varargin{j});
            num_opst=isempty(num_ops);
            if num_opst==0
                filtro_filtro=find(asteroides.nroops(filtro)<=varargin{j+1}(2) & asteroides.nroops(filtro)>=varargin{j+1}(1));
                filtro=filtro(filtro_filtro);
            end
            incerti=strmatch('U',varargin{j});
            incertit=isempty(incerti);
            if incertit==0
                filtro_U=strmatch('X',U);
                filtro_U=union(strmatch('E',U),filtro_U);
                filtro_U=union(strmatch('F',U),filtro_U);
                filtro_U=union(strmatch('D',U),filtro_U);
                filtro=setdiff(filtro,filtro_U);
                filtro_filtro=find(str2num(U(filtro))>=varargin{j+1}(1) & str2num(U(filtro))<=varargin{j+1}(2));
                filtro=filtro(filtro_filtro);
            end       
            
            semieje=strmatch('a',varargin{j});
            semiejet=isempty(semieje);
            if semiejet==0
                filtro_filtro=find(asteroides.a(filtro)>=varargin{j+1}(1) & asteroides.a(filtro)<=varargin{j+1}(2));
                filtro=filtro(filtro_filtro);
            end 
            
            
            exc=strmatch('e',varargin{j});
            exct=isempty(exc);
            if exct==0
                filtro_filtro=find(asteroides.e(filtro)>=varargin{j+1}(1) & asteroides.e(filtro)<=varargin{j+1}(2));
                filtro=filtro(filtro_filtro);
            end 
            
                        
            inclinacion=strmatch('incli',varargin{j});
            inclinaciontt=isempty(inclinacion);
            if inclinaciontt==0
                filtro_filtro=find(asteroides.incli(filtro)>=varargin{j+1}(1) & asteroides.incli(filtro)<=varargin{j+1}(2));
                filtro=filtro(filtro_filtro);
            end 
            
            
            
            arco=strmatch('arc',varargin{j});
            arco_t=isempty(arco);
            if arco_t==0
                filtro_filtro=find(asteroides.arc_obs(filtro)<=varargin{j+1}(2) & asteroides.arc_obs(filtro)>=varargin{j+1}(1));
                filtro=filtro(filtro_filtro);
            end
            
            numeracion=strmatch('numerados',varargin{j});
            numerados_t=isempty(numeracion);
            if numerados_t==0
                primer_num=varargin{j+1}(1);
                segundo_num=varargin{j+1}(2);
                filtro=intersect(filtro,primer_num:1:segundo_num);
            end
           
        end
  
    end

epoca_media=median(asteroides.epoca);
filtro_filtro=find(asteroides.epoca(filtro)==epoca_media);
filtro=filtro(filtro_filtro);
Cuerpos.epoca=epoca_media;
Cuerpos.nombres=asteroides.nombres(filtro,1:7);
Cuerpos.H=asteroides.H(filtro);
Cuerpos.G=asteroides.G(filtro);

Cuerpos.M=asteroides.M(filtro);
Cuerpos.peri=asteroides.peri(filtro);
Cuerpos.node=asteroides.node(filtro);
Cuerpos.incli=asteroides.incli(filtro);
Cuerpos.e=asteroides.e(filtro);
Cuerpos.n=asteroides.n(filtro);
Cuerpos.a=asteroides.a(filtro);


varargout{1}=length(Cuerpos.a);
save(camino,'Cuerpos');
