function fourier_analisis(y,t);
delta_t=t(2)-t(1);
Y = fft(y);
N = length(Y);
Y(1) = [];
power = abs(Y(1:N/2)).^2;
%nyquist = 1/2;
freq = (1:N/2)/N;%/2)*nyquist;
%plot(freq,power), grid on
%xlabel('cycles/year')
%title('Periodogram')

period = delta_t*(1./freq)/365.25;
h=plot(period,power); grid on;
ylabel('Contenido de frecuencias')
xlabel('Periodo Años')