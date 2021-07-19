function[Mu]=MFsig01n(In,a,b);
% SIG_member ship function 
% a --> center
% b --> varient

Mu=(1./(1+exp(-b*(-In-a))));



