function [f,mag,max_f] = FFT01(data,xbp,rate,index1,index2)

n = size(data,1);
xZ = zeros(n,1);
xZ(index1:index2) = xbp;

X_F = fft(xZ, length(xZ));
X_A=abs(X_F); 
fs_L = 1/rate;
f_1=(fs_L/length(xZ))*(0:1:length(xZ)/2);   %rango de frecuencia

Spec = X_A(1:(length(xZ)/2)+1);

% figure
% clf
% plot(f_1,Spec,'-k','LineWidth',2)
% axis tight
% xlim([0 1e7])
% ylim ([0 10])
% hold on
c(1) = 0;
for k = 1:size(Spec,1)
    c(k+1) = max(Spec(k),c(k));
    if c(k+1) > c(k)
        indez = k;
%         f_max = k;
    end
end

%plot(f_1(indez),max(Spec),'or')
%title(f_1(indez))

f = f_1; 
mag = Spec;
max_f = f_1(indez);