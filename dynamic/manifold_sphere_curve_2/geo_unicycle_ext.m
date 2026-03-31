function [dzdt,h1,h1_dot,h2,h2_dot,const_1,const_2,ch,ch_dt] = geo_unicycle_ext(t,z,r)

x     =  [z(1);z(2);z(3)];
gamma =  [z(4);z(5);z(6)];

zeta = z(7);

gamma = gamma/norm(gamma); % gamma lives in S

x__1=x(1); x__2=x(2); x__3=x(3);


%% phi =  manifold (sphere)

n = [x__1 / r x__2 / r x__3 / r].';
N = [0.1e1 / r 0 0; 0 0.1e1 / r 0; 0 0 0.1e1 / r;];

gamma = gamma - n * (n.' * gamma); % gamma also lives in TxM
%% Input
% h1 = curve on manifold (circle)

% P = [1,0,0;0,1,0;0,0,0];
P = [3,0,0;0,1,0;0,0,0];
h1 = x.' * P * x - (0.9*r)^2;
dh1 = 2*P*x;
ddh1 = 2*P;



h1_dot = zeta*dot(dh1,gamma);



% h2: motion on manifold (circle)
h2 = 1*atan2(x__2, x__1);

dh2 = 1*[-x__2/(x__1^2+x__2^2);...
           x__1/(x__1^2+x__2^2);...
           0];
ddh2 = 1*[2 * x__1 * x__2 / (x__1 ^ 2 + x__2 ^ 2) ^ 2 (-x__1 ^ 2 + x__2 ^ 2) / (x__1 ^ 2 + x__2 ^ 2) ^ 2 0; (-x__1 ^ 2 + x__2 ^ 2) / (x__1 ^ 2 + x__2 ^ 2) ^ 2 -2 * x__1 * x__2 / (x__1 ^ 2 + x__2 ^ 2) ^ 2 0; 0 0 0;];

h2_dot = zeta*dot(dh2, gamma)  -   -0.5;
                         
A = [dot(dh1,gamma), zeta*dot(dh1,SSS(n)*gamma);...
     dot(dh2,gamma), zeta*dot(dh2,SSS(n)*gamma)];

 
b = [zeta^2*(gamma.'*ddh1 * gamma - dot(dh1,gamma.'*N*gamma*n));...
     zeta^2*(gamma.'*ddh2 * gamma - dot(dh2,gamma.'*N*gamma*n))];


h = [h1;...
     h2];

h_dt = [h1_dot;...
        h2_dot];

k21 = 10 ; k22 = 5;

k31 = 0; k32 = 0.5;

ubar = A\(- b - diag([k21, k31])*h -  diag([k22, k32])*h_dt);

u = ubar(1);
om = ubar(2);


ch = h1;
ch_dt = h1_dot;

%%  View constraints
const_1 = gamma.' * gamma;
const_2 =  n.' * gamma;
%% Dyammcis

dzdt = [zeta*gamma;...
        om*SSS(n)*gamma - zeta * (gamma.' * N * gamma)*n;...
        u];