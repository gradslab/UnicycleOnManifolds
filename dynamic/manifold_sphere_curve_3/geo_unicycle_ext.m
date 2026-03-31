function [dzdt,h1,h1_dot,h2,h2_dot,const_1,const_2,ch,ch_dt] = geo_unicycle_ext(t,z,r,a,b,c)

x     =  [z(1);z(2);z(3)];
gamma =  [z(4);z(5);z(6)];

zeta = z(7);

gamma = gamma/norm(gamma); % gamma lives in S

x__1=x(1); x__2=x(2); x__3=x(3);


%% phi =  manifold 
% phi = x3 - f(x1,x2)
% phi(x) = x3 - a sin(b x1) sin(c x2) = 0

% First derivatives of f
    fx = a * b * cos(b*x__1) * sin(c*x__2);
    fy = a * c * sin(b*x__1) * cos(c*x__2);

    % Second derivatives of f
    fxx = -a * b^2 * sin(b*x__1) * sin(c*x__2);
    fyy = -a * c^2 * sin(b*x__1) * sin(c*x__2);
    fxy =  a * b * c * cos(b*x__1) * cos(c*x__2);

    % Gradient of phi
    g = [-fx; -fy; 1];
    s = norm(g);

    n = g / s;

    % dg/dx1 and dg/dx2
    g_x1 = [-fxx; -fxy; 0];
    g_x2 = [-fxy; -fyy; 0];
    g_x3 = [0; 0; 0];

    % Jacobian of unit normal:
    % dn = (I - n n^T)/||g|| * dg
    Pn = eye(3) - n*n.';

    dn_dx1 = (Pn / s) * g_x1;
    dn_dx2 = (Pn / s) * g_x2;
    dn_dx3 = (Pn / s) * g_x3;

    N = [dn_dx1, dn_dx2, dn_dx3];



gamma = gamma - n * (n.' * gamma); % gamma also lives in TxM
%% Input
% h1 = curve on manifold (circle)

P = [1,0,0;0,1,0;0,0,0];
% P = [3,0,0;0,1,0;0,0,0];
h1 = x.' * P * x - (1*r)^2;
dh1 = 2*P*x;
ddh1 = 2*P;



h1_dot = zeta*dot(dh1,gamma);



% h2: motion on manifold (circle)
h2 = 1*atan2(x__2, x__1);

dh2 = 1*[-x__2/(x__1^2+x__2^2);...
           x__1/(x__1^2+x__2^2);...
           0];
ddh2 = 1*[2 * x__1 * x__2 / (x__1 ^ 2 + x__2 ^ 2) ^ 2 (-x__1 ^ 2 + x__2 ^ 2) / (x__1 ^ 2 + x__2 ^ 2) ^ 2 0; (-x__1 ^ 2 + x__2 ^ 2) / (x__1 ^ 2 + x__2 ^ 2) ^ 2 -2 * x__1 * x__2 / (x__1 ^ 2 + x__2 ^ 2) ^ 2 0; 0 0 0;];

h2_dot = zeta*dot(dh2, gamma)  -   -1/(0.9*r);
                         
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