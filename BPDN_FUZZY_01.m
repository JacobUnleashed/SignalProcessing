clear
obj1 = SetTek;

% NN
a1 = -2.15e6;    b1 = 15e-6;
a2 = 2.3e6;     b2 = 0.20e6;
a3 = 2.7e6;     b3 = 0.20e6;
a4 = 3.1e6;     b4 = 0.20e6;
a5 = 3.5e6;         b5 = 0.20e6;
figure(11)
MFshow(1.8e6,3.75e6,a1,a2,a3,a4,a5,b1,b2,b3,b4,b5)

imax = 100;

d1B= zeros(1,imax);
d2B= zeros(1,imax);
d3B= zeros(1,imax);
d4B= zeros(1,imax);
d5B= zeros(1,imax);

d1C= zeros(1,imax);
d2C= zeros(1,imax);
d3C= zeros(1,imax);
d4C= zeros(1,imax);
d5C= zeros(1,imax);

initv = 1;

d1B(:)= initv;
d2B(:)= initv*.8;
d3B(:)= initv*.6;
d4B(:)= initv*.4;
d5B(:)= initv*.2;
umaxB = 1.5;

d1C(:)= initv;
d2C(:)= initv*.8;
d3C(:)= initv*.6;
d4C(:)= initv*.4;
d5C(:)= initv*.2;
umaxC = 1.500;


% al=0.010;                  
eta=0.01;           
% Yp=00.5;






f_max(1) = 0;
deltaP(1) = 0;

% obj1 = SetTd1ek;
% ref = load('mag_ref_May13.txt');
% 

ee = 0;

thesign = -1;
ex1=5;


F1 = daq.createSession('ni');
ai = addAnalogInputChannel(F1,'Dev1',[0 1 2 3 4 5],'Voltage');

%-------------- Cal Matrix for Force sensor -------



M=[-0.140897527337   -0.026646811515    0.459277540445   6.543839454651   -0.183051392436    -6.065379142761
   -0.374699562788   -7.318554878235    0.269087761641   3.787328720093    0.181604579091     3.484099626541
   10.177042007446   -0.422389984131   10.365196228027  -0.361159473658   10.161412239075    -0.163943350315
   -0.000614119286   -0.039782140404    0.142598077655   0.016440978274   -0.140442624688     0.020647138357 
   -0.171546921134    0.006461459678    0.081093870103  -0.038116268814    0.082939267159     0.032150499523
   -0.003099882044   -0.088794820011   -0.004044984467  -0.090272977948   -0.004795755260    -0.084723599255];

Kph=500;
for k=1:Kph
        Hb(:,k)=inputSingleScan(F1);
end

H=sum(Hb')/Kph;
H=H';
 
  


[s]=CreateSession(1);
fopen(s);

% umax = 0.05;
% disP = linspace(0,-umax,imax/2);
% disN = linspace(umax,0,imax/2);
% 
% displ = [disP disN];

% BP
sigma =0.0100;
index1 = 4000;
index2 = 6000;

c1= 5;
c2 = 6;
tic


for i = 1:imax 
    if rem(i,10) == 0
        ct = c1;
        c1 = c2;
        c2 = ct;
        if i == 10
            B1 = B;
        elseif rem(i,20) == 0
            B2 = B;
            d1B(i) = B1(1);
            d2B(i) = B1(2);
            d3B(i) = B1(3);
            d4B(i) = B1(4);
            d5B(i) = B1(5);
        else
            B1 = B;
            d1C(i) = B2(1);
            d2C(i) = B2(2);
            d3C(i) = B2(3);
            d4C(i) = B2(4);
            d5C(i) = B2(5);
        end
            
    else   
    end

     for ii = 1:10

            [data,time,rate] = AcqTek(obj1);
            
            datai(:,i) = data; 

            [y_BP(:,i),r_BP] = BP01(data,index1,index2,sigma);
            ylim([-0.03 0.03])
            [f,mag,max_f] = FFT01(data,y_BP(:,i),rate,index1,index2);
            ylim([0 2])
%             [Loss,m] = loss01(f,mag,ref);

%             fmax(i+1) = 
            fmaxx(i,ii) = max_f;

            fmax(i+1) = max_f;

            % Read force
            F_temp1=inputSingleScan(F1);   % Read the force ...  
            F_temp2=F_temp1'-H;
            F_temp3=M*F_temp2;
            Fx(i)=F_temp3(1);  
            Fy(i)=F_temp3(2);  
            Fz(i)=F_temp3(3) ;  
            Tx(i)=F_temp3(4);
            Ty(i)=F_temp3(5);
            Tz(i)=F_temp3(6);


            A = ReadK(s);
            
%             disp(c1)
            Bc = A(c1);
            robPos(i) = Bc;
            

            if ii == 1 

                figure(4)
                subplot(3,2,1), plot (Fx),ylabel('F_x')
                grid on
                subplot(3,2,3), plot (Fy),ylabel('F_y')
                grid on
                subplot(3,2,5), plot (Fz),ylabel('F_z')
                grid on
                subplot(3,2,2), plot (Tx),ylabel('\tau_x')
                grid on
                subplot(3,2,4), plot (Ty),ylabel('\tau_y')
                grid on
                subplot(3,2,6), plot (Tz),ylabel('\tau_z')
                grid on

                figure(5)
                plot(robPos,'k');
                ylabel('Rob Pos [mm]')

                figure(6)
                plot(fmax,'k');
                ylabel('f_m_a_x [Hz]')
                title(fmax(i+1))

                if c1 == 5
                    B=[d1B(i); d2B(i); d3B(i); d4B(i); d5B(i)];

                    p1(i) = MFsig01n(fmax(i),a1,b1);
                    p2(i) = MFgus01(fmax(i),a2,b2);
                    p3(i) = MFgus01(fmax(i),a3,b3);
                    p4(i) = MFgus01(fmax(i),a4,b4);
                    p5(i) = MFgus01(fmax(i),a5,b5);

                    P = [p1(i); p2(i); p3(i); p4(i); p5(i)];

                    ut1 = B'*P;
                    ut2 = min(abs(ut1),umaxB);
                    u(i) = thesign*ut2;disp(u(i))

                    % Robot displacement
                    Db=u(i);
                    
                    Bd = Bc + Db;
                    Ak=0;

                    % Learning phase 
                    d1B(i+1) = d1B(i) - eta*p1(i);
                    d2B(i+1) = d2B(i) - eta*p2(i);
                    d3B(i+1) = d3B(i) - eta*p3(i);
                    d4B(i+1) = d4B(i) - eta*p4(i);
                    d5B(i+1) = d5B(i) - eta*p5(i);
                    B=[d1B(i+1);d2B(i+1);d3B(i+1);d4B(i+1);d5B(i+1)];
                    Norm_B(i)=norm(B);



                else
                    B=[d1C(i); d2C(i); d3C(i); d4C(i); d5C(i)];

                    p1(i) = MFsig01n(fmax(i),a1,b1);
                    p2(i) = MFgus01(fmax(i),a2,b2);
                    p3(i) = MFgus01(fmax(i),a3,b3);
                    p4(i) = MFgus01(fmax(i),a4,b4);
                    p5(i) = MFgus01(fmax(i),a5,b5);

                    P = [p1(i); p2(i); p3(i); p4(i); p5(i)];

                    ut1 = B'*P;
                    ut2 = min(abs(ut1),umaxC);
                    u(i) = thesign*ut2;disp(u(i))

                    % Robot displacement
                    Db=u(i);

                    Bd = Bc + Db;
                    Ak=0;
                    

                    % Learning phase 
                    d1C(i+1) = d1C(i) - eta*p1(i);
                    d2C(i+1) = d2C(i) - eta*p2(i);
                    d3C(i+1) = d3C(i) - eta*p3(i);
                    d4C(i+1) = d4C(i) - eta*p4(i);
                    d5C(i+1) = d5C(i) - eta*p5(i);
                    B=[d1C(i+1);d2C(i+1);d3C(i+1);d4C(i+1);d5C(i+1)];
                    Norm_B(i)=norm(B);
                end

    %                 ee = fmax(i);
            else
                    pause(0.1)
                    Bd = Bc + 0;
                    Ak=0;
            end

            if i==imax
                Ak=1;
            end

            if c1 == 5
                BUFF=[A(1) A(2) A(3) A(4) Bd A(6) A(7) A(8) Ak];
            else
                BUFF=[A(1) A(2) A(3) A(4) A(5) Bd A(7) A(8) Ak];
            end

            % Write to kuka
            WriteK(BUFF,s);
%             disp(Bd)
            if i==imax
                break
            end
     end
     ex2 = ex1;
     ex1 = fmax(i+1);

     if abs(ex1) < abs(ex2) 
         thesign = -1*thesign;
     else  
     end
%     disp(c1)
%     disp(deltaP(i+1))
%      if i == imax
%          break
%      end
end
toc
elapsed = toc;
% figure(53)
% hold on
% plot(e)
% axis tight
% set(gca,'FontSize',18)
% % ylim([0e6 3e6])
% grid on
% xlabel('Iteration [i]');
% ylabel('m []')
% 
% 
fclose(s)
% fclose(obj1);

figure(10)
clf
hold on
plot(d1C)
plot(d2C)
plot(d3C)
plot(d4C)
plot(d5C)
axis tight

figure(12)
clf
hold on
plot(d1B)
plot(d2B)
plot(d3B)
plot(d4B)
plot(d5B)
axis tight