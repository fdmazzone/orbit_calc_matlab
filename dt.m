%%%  Esta función calcula dt-UT la diferencia entre el tiempo dinámico y
%%%  universal, el argumento es el  dia juliano
function dt=dt(a)
  dt=-15+0.00325*(a-1810)^2;