%%%  Esta funci�n calcula dt-UT la diferencia entre el tiempo din�mico y
%%%  universal, el argumento es el  dia juliano
function dt=dt(a)
  dt=-15+0.00325*(a-1810)^2;