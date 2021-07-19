function MFshow01(emin,emax,an1,an2,az0,ap2,ap1,bn1,bn2,bz0,bp2,bp1)
 %clear all
 %close all
 
%  emax=3;
%  emin=-3;
 point=100; 

 e=linspace(emin,emax,point);
 [i,j]=size(e);


% Paste the parameters hear ..........

% an1=1.1         ;  bn1=9;
% an2=-0.75        ;  bn2=0.4;
% az0=0           ;  bz0=0.5;
% ap2=0.75         ;  bp2=0.4;
% ap1=1.1         ;  bp1=9;

for k=1:j    %[ FOR of main loop --> k]
   
   MUen1(k)=MFsig01n(e(k),an1,bn1);
   MUen2(k)=MFgus01(e(k),an2,bn2);
   MUez0(k)=MFgus01(e(k),az0,bz0);
   MUep2(k)=MFgus01(e(k),ap2,bp2);
   MUep1(k)=MFgus01(e(k),ap1,bp1);        
   
end       %[ FOR of main loop -->k ]



% figure(103)

plot(e,MUen1,'k',e,MUen2,'k',e,MUez0,'k',e,MUep2,'k',e,MUep1,'k')
axis([emin emax 0 1])
xlabel('f_m_a_x'); 
ylabel('MF');
set(gca,'FontSize',18)


% disp('Finish ! ')
% % % 

