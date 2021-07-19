%--------------------------------------------------------------------
%  Direct Adaptive Contol ALG for FREN and MiFREN series 
%  PE and Learning rate range 
%  On-line learning  (only LC parameters) 
%  1 Input, 1 Output, 5 Rules 
%  
%  V 0.01 Date 10 March 2010
%  V 0.01L : 8 March 2017 Learning for Gradient Ap
%--------------------------------------------------------------------
clc
clear all
%close all
%----- MFs parameters -----

an1=3.5         ;  bn1=2.5;
an2=-2.5        ;  bn2=1.0;
az0=0           ;  bz0=1.75;
ap2=2.5         ;  bp2=1.0;
ap1=3.5         ;  bp1=2.5;

% an1=1.1         ;  bn1=9;
% an2=-0.9        ;  bn2=0.4;
% az0=0           ;  bz0=0.5;
% ap2=0.8         ;  bp2=0.4;
% ap1=1.1         ;  bp1=9;

emax=5;
emin=-5;
MFshow_DA01
%-----------LC-------------
b1(1)=1;
b2(1)=0.5;
b3(1)=0;
b4(1)=-0.5;
b5(1)=-1; 

% b1(1)=0;
% b2(1)=0;
% b3(1)=0;
% b4(1)=0;
% b5(1)=0; 

% b1(1)=randn(1,1);
% b2(1)=randn(1,1);
% b3(1)=randn(1,1);
% b4(1)=randn(1,1);
% b5(1)=randn(1,1); 
%--------------------------
kmax=4999;
x=zeros(1,kmax);
eta=zeros(1,kmax);
e=zeros(1,kmax);
x(1)=0.5;
eta(1)=0.000001;
P_margin=0.0;
u_max=100;
e(1)=0-x(1);
g_m=6;
al=1.0; % Gain of adaptation, 2 is Maximum.
wr=8;
%------------------- Main Loop ---------------- 
for k=1:kmax 
   
B=[b1(k); b2(k); b3(k); b4(k); b5(k)];
   p1(k)=MFsig01n(e(k),an1,bn1);
   p2(k)=MFgus01(e(k),an2,bn2);
   p3(k)=MFgus01(e(k),az0,bz0);
   p4(k)=MFgus01(e(k),ap2,bp2);
   p5(k)=MFsig01(e(k),ap1,bp1);  
P=[p1(k); p2(k); p3(k); p4(k); p5(k)];   
ut=B'*P;
if abs(ut)>u_max
    u(k)=sign(ut)*u_max;
    disp('Control effort Saturates')
else
    u(k)=ut;
end
%x(k+1)=sin(x(k))+(5+cos(x(k)*u(k)))*u(k);
Yp(k)=-u(k)*x(k)*sin(x(k)*u(k))+(5+cos(x(k)*u(k)));

x(k+1)=sin(x(k))+(5+cos(x(k)))*u(k);
%xd(k+1)=2*sin(2*pi*k/50)+2*sin(2*pi*k/100);
xd(k+1)=1*sign(cos(2*wr*pi*k/kmax));
%xd(k+1)=1;
e(k+1)=xd(k+1)-x(k+1);

   %-------------- Adaptive ------------
   PP=P'*P;
   if PP > P_margin
       eta(k+1)=0.2/(g_m^2*PP);
       %eta(k+1)=0.2/(Yp(k)*Yp(k)*PP);
   else
       eta(k+1)=eta(k);
       disp('PP lower than Margin !')
   end
   %g_m=Yp(k);
   b1(k+1)=b1(k)+al*eta(k+1)*e(k+1)*g_m*p1(k);
   b2(k+1)=b2(k)+al*eta(k+1)*e(k+1)*g_m*p2(k);
   b3(k+1)=b3(k)+al*eta(k+1)*e(k+1)*g_m*p3(k);
   b4(k+1)=b4(k)+al*eta(k+1)*e(k+1)*g_m*p4(k);
   b5(k+1)=b5(k)+al*eta(k+1)*e(k+1)*g_m*p5(k);
   %-------------- Adaptive ------------ 
    
end
%------------------- Main Loop ---------------- 
figure(10)
plot(1:kmax+1,x,'k', 1:kmax+1,xd,':k')
ylabel('x and x_d')
xlabel('Time index: k')
legend('x(k)','x_d(k)')
grid on

figure(11)
plot(1:kmax,u,'k')
ylabel('u')
xlabel('Time index: k')
grid on

figure(12)
plot(1:kmax+1,e)
ylabel('e')
xlabel('Time index: k')
grid on

figure(13)
plot(1:kmax,Yp,'k')
ylabel('Y_p')
xlabel('Time index: k')
grid on

figure(20)
subplot(2,3,1)
plot(1:kmax+1,b1,'k')
ylabel('\beta_1')
subplot(2,3,2)
plot(1:kmax+1,b2,'k')
ylabel('\beta_2')
subplot(2,3,3)
plot(1:kmax+1,b3,'k')
ylabel('\beta_3')
subplot(2,3,4)
plot(1:kmax+1,b4,'k')
ylabel('\beta_4')
subplot(2,3,5)
plot(1:kmax+1,b5,'k')
ylabel('\beta_5')

%-----------------------------------------------------
% figure(201)
% plot(1:kmax+1,b1,'k')
% ylabel('\beta_1')
% xlabel('Time index: k')
% grid on
% 
% figure(202)
% plot(1:kmax+1,b2,'k')
% ylabel('\beta_2')
% xlabel('Time index: k')
% grid on
% 
% figure(203)
% plot(1:kmax+1,b3,'k')
% ylabel('\beta_3')
% xlabel('Time index: k')
% grid on
% 
% figure(204)
% plot(1:kmax+1,b4,'k')
% ylabel('\beta_4')
% xlabel('Time index: k')
% grid on
% 
% figure(205)
% plot(1:kmax+1,b5,'k')
% ylabel('\beta_5')
% xlabel('Time index: k')
% grid on
%----------------------------------------------------

figure(30)
plot(1:kmax+1,eta,'k')
ylabel('\eta')
xlabel('Time index: k')
grid on

