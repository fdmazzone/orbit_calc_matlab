function estado_aceleracion=fuerzaDE_2b(estado,GMS)
[k l]=size(estado);
estado_aux=reshape(estado,[k,3,l/3]);
normas=sum(estado_aux.^2,2).^(-1.5);
normas=repmat(normas,[1,3,1]);
estado_aceleracion=-GMS*normas.*estado_aux;
estado_aceleracion=reshape(estado_aceleracion,[k,l]);