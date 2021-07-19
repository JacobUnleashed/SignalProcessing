function[Mu]=MFgus01(In,a,b);
% GUS_member ship function 
% a --> center
% b --> varient

TempM1=((In-a)^2)/(b^2);

Mu=exp(-TempM1);




