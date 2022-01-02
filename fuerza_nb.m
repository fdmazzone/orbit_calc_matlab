function estado_aceleracion=fuerza_nb(estado,funcion_datos)
%n=size(funcion_datos.GM,1);
n=size(estado,2)/3;
s_est=size(estado,1);
R=permute(reshape(estado',[3,n,s_est]),[2,1,3]);
R_pla=R(1:funcion_datos.cantidad_planetas,:,:);
sR=size(R);
R0=reshape(([-funcion_datos.GM(2,funcion_datos.cantidad_planetas+2),funcion_datos.GM(1,2:funcion_datos.cantidad_planetas)]/funcion_datos.GM(1,1))*R_pla(:,:),[1, sR(2:end)]);
R=cat(1,R0,R);
diferencias=R(funcion_datos.indices(:,1),:,:)-R(funcion_datos.indices(:,2),:,:);
norma_diferencias=(sum(diferencias.^2,2).^(-1.5));
diferencias=repmat(norma_diferencias,[1,3,1]).*diferencias;
diferencias=diferencias(funcion_datos.Indicador,:,:);
sdif=size(diferencias);
estado_aceleracion=permute(reshape(-funcion_datos.GM*diferencias(:,:),[n,sdif(2:end)]),[2,1,3]);
estado_aceleracion=reshape(estado_aceleracion,[3*n,s_est])';

 