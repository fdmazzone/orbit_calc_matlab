%Esta funciòn convierte dias en dd.dddddd en [dd hh mm ss]
function [dias horas minutos segundos]=d2dhs(dias)

tolerancia_tiempo=1.15740740740741e-005;
dias=tolerancia_tiempo*round(dias*tolerancia_tiempo^(-1));

horas=(dias-floor(dias))*24;
minutos=(horas-floor(horas))*60;
segundos=(minutos-floor(minutos))*60;
dias=floor(dias);
horas=floor(horas);
minutos=floor(minutos);
segundos=floor(segundos);

