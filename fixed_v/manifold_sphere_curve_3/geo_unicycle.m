function [dzdt,h1,h1_dot,const_1,const_2,ch,ch_dt] = geo_unicycle(t,z,r,a,b,c)

x     =  [z(1);z(2);z(3)];
gamma =  [z(4);z(5);z(6)];

gamma = gamma/norm(gamma); % gamma lives in S

x__1=x(1); x__2=x(2); x__3=x(3);

%% Fix input v
v = 2;


%% phi = manifold
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



% n = [x__1 / r x__2 / r x__3 / r].';
% N = [0.1e1 / r 0 0; 0 0.1e1 / r 0; 0 0 0.1e1 / r;];

gamma = gamma - n * (n.' * gamma); % gamma also lives in TxM
%% h1 = curve on manifold (circle)
P = [1,0,0;0,1,0;0,0,0];

h1 = x.' * P * x - r^2;
h1_dot = 2*v*x.'*P*gamma;
 


%% Input
a = 2*v*x.'*P*SSS(n)*gamma;
b = 2*v^2*(gamma.'*P*gamma  -  x.'*P*(gamma.'*N*gamma)*n);

k1 = 1; k2 = 1;

% om = 0;

om = 1/a*(-b - k1*h1 - k2*h1_dot);


phi__2_ddot = a * om + b;
% phi__2_ddot = 2*v*(v*gamma.' *  P  * gamma  +  x.'*P*(om*SSS(n)*gamma - v * (gamma.' * N * gamma)*n)    );









ch = h1_dot;
ch_dt = phi__2_ddot;

%%  View constraints
const_1 = gamma.' * gamma;
const_2 =  n.' * gamma;
%% Dyammcis
dzdt = [v*gamma;...
        om*SSS(n)*gamma - v * (gamma.' * N * gamma)*n];