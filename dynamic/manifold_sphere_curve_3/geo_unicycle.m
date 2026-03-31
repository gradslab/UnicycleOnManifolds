function [dzdt,phi__2,phi__2_dot,const_1,const_2,ch,ch_dt] = geo_unicycle(t,z,r)

x     =  [z(1);z(2);z(3)];
gamma =  [z(4);z(5);z(6)];

gamma = gamma/norm(gamma);

x__1=x(1); x__2=x(2); x__3=x(3);

%% Fix input v
v = 0.5;
%% phi_1 =  manifold (sphere)

n = [x__1 / r x__2 / r x__3 / r].';
N = [0.1e1 / r 0 0; 0 0.1e1 / r 0; 0 0 0.1e1 / r;];


 


%% Input
% phi_2 = curve on manifold (circle)
P = [1,0,0;0,1,0;0,0,0];
phi__2 = x.' * P * x - (0.9*r)^2;
dphi__2 = 2*P*x;

s1 = dot(dphi__2,gamma);

k1 = 1;
v = -1/s1*k1*phi__2;

phi__2_dot = 2*v*x.'*P*gamma;

% v


% om
a = 2*v*x.'*P*SSS(n)*gamma;
b = 2*v^2*(gamma.'*P*gamma  -  x.'*P*(gamma.'*N*gamma)*n);

k2 = 0.1; k3 = 0.5;



% om = 1/a*(-b - k2*phi__2 - k3*phi__2_dot);
om = 0;



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