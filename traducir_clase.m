function [claseb, isneo]=traducir_clase(clase)
    is_main_belt=strmatch('00',clase(:,3:4));
    is_aten=strmatch('02',clase(:,3:4));
    is_apolo=strmatch('03',clase(:,3:4));
    is_amor=strmatch('04',clase(:,3:4));
    is_mars1=strmatch('05',clase(:,3:4));
    is_hung=strmatch('06',clase(:,3:4));
    is_phoc=strmatch('07',clase(:,3:4));
    is_hilda=strmatch('08',clase(:,3:4));
    is_troyan=strmatch('09',clase(:,3:4));
    is_centaur=strmatch('0A',clase(:,3:4));
    is_plutino=strmatch('0E',clase(:,3:4));
    is_otros=strmatch('0F',clase(:,3:4));
    is_cube=strmatch('10',clase(:,3:4));
    is_disper=strmatch('11',clase(:,3:4));
    is_pha=strmatch('8',clase(:,1));
    isneo=strmatch('8',clase(:,2));
    claseb=repmat('            ',[size(clase,1),1]);
    if ~isempty(is_main_belt);
        claseb(is_main_belt,:)=repmat('Cint. Pr.   ',[length(is_main_belt),1]);
    end
    if ~isempty(is_aten);
        claseb(is_aten,:)=repmat('Aten        ',[length(is_aten),1]);
    end
    if ~isempty(is_apolo);
        claseb(is_apolo,:)=repmat('Apolo       ',[length(is_apolo),1]);
    end
    if ~isempty(is_amor);
        claseb(is_amor,:)=repmat('Amor        ',[length(is_amor),1]);
    end
    if ~isempty(is_mars1);
         claseb(is_mars1,:)=repmat('q<1.665     ',[length(is_mars1),1]);
    end
    if ~isempty(is_hung);
         claseb(is_hung,:)=repmat('Hungaria    ',[length(is_hung),1]);
    end
    if ~isempty(is_phoc);
         claseb(is_phoc,:)=repmat('Phocaea     ',[length(is_phoc),1]);
    end
        
    if ~isempty(is_hilda);
        claseb(is_hilda,:)=repmat('Hilda       ',[length(is_hilda),1]);
    end
    if ~isempty(is_troyan);
        claseb(is_troyan,:)=repmat('Jup. Troyan ',[length(is_troyan),1]);
    end
    if ~isempty(is_centaur);
        claseb(is_centaur,:)=repmat('Centaur     ',[length(is_centaur),1]);
    end
    if ~isempty(is_plutino);
        claseb(is_plutino,:)=repmat('Plutino     ',[length(is_plutino),1]);
    end
    if ~isempty(is_otros);
        claseb(is_otros,:)=repmat('Other TNO   ',[length(is_otros),1]);
    end
    if ~isempty(is_cube);
        claseb(is_cube,:)=repmat('Cubewano    ',[length(is_cube),1]); 
    end
    if isempty(is_disper)==0;
        claseb(is_disper,:)=repmat('Disp. Disk  ',[length(is_disper),1]); 
    end
    if ~isempty(is_pha);
        claseb(is_pha,:)=repmat('PHA         ',[length(is_pha),1]); 
    end
    Arreglo=false([size(clase,1),1]);
    Arreglo(isneo)=true;
    isneo=Arreglo;
    