function [dzdt,phi__2,phi__2_dot,const_1,const_2,ch,ch_dt] = geo_unicycle(t,z,r)

x     =  [z(1);z(2);z(3)];
gamma =  [z(4);z(5);z(6)];

gamma = gamma/norm(gamma); % gamma lives in S

x__1=x(1); x__2=x(2); x__3=x(3);

%% Fix input v
v = 2;
%% phi_1 =  manifold (sphere)

n = [x__1 / r x__2 / r x__3 / r].';
N = [0.1e1 / r 0 0; 0 0.1e1 / r 0; 0 0 0.1e1 / r;];

gamma = gamma - n * (n.' * gamma); % gamma also lives in TxM
%% phi_2 = curve on manifold (circle)
P = [1,0,0;0,1,0;0,0,0];
P = [3,0,0;0,1,0;0,0,0];

phi__2 = x.' * P * x - (0.9*r)^2;
phi__2_dot = 2*v*x.'*P*gamma;
 


%% Input
a = 2*v*x.'*P*SSS(n)*gamma;
b = 2*v^2*(gamma.'*P*gamma  -  x.'*P*(gamma.'*N*gamma)*n);

k1 = 2; k2 = 1;

% om = 0;

om = 1/a*(-b - k1*phi__2 - k2*phi__2_dot);


phi__2_ddot = a * om + b;
% phi__2_ddot = 2*v*(v*gamma.' *  P  * gamma  +  x.'*P*(om*SSS(n)*gamma - v * (gamma.' * N * gamma)*n)    );









ch = phi__2_dot;
ch_dt = phi__2_ddot;

%%  View constraints
const_1 = gamma.' * gamma;
const_2 =  n.' * gamma;
%% Dyammcis
dzdt = [v*gamma;...
        om*SSS(n)*gamma - v * (gamma.' * N * gamma)*n];