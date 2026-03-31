clc; clear; close all;

%% ============================================================
% Parameters
% ============================================================

a = 0.45;
b = 1.25;
c = 1.10;

xc = 0.0;
yc = 0.0;
R  = 1.30;

theta0 = deg2rad(35);

xdom = [-2.90 2.90];
ydom = [-2.90 2.90];

%% ============================================================
% Surface mesh
% ============================================================

nx = 30;
ny = 30;
[xg, yg] = meshgrid(linspace(xdom(1),xdom(2),nx), ...
                    linspace(ydom(1),ydom(2),ny));
zg = a*sin(b*xg).*sin(c*yg);

%% ============================================================
% Closed curve on the surface
% ============================================================

th = linspace(0,2*pi,700);
xC = xc + R*cos(th);
yC = yc + R*sin(th);
zC = a*sin(b*xC).*sin(c*yC);

%% ============================================================
% Point x on the curve
% ============================================================

px = xc + R*cos(theta0);
py = yc + R*sin(theta0);
pz = a*sin(b*px)*sin(c*py);
p  = [px; py; pz];

%% ============================================================
% Surface geometry at x
% ============================================================

fx = a*b*cos(b*px)*sin(c*py);
fy = a*c*sin(b*px)*cos(c*py);

n = [-fx; -fy; 1];
n = n / norm(n);

%% ============================================================
% Rotated frame: tau tangent to curve C, sigma tangent to surface
% ============================================================

dx_dth = -R*sin(theta0);
dy_dth =  R*cos(theta0);
dz_dth = fx*dx_dth + fy*dy_dth;

tau = [dx_dth; dy_dth; dz_dth];
tau = tau / norm(tau);

sigma = cross(n, tau);
sigma = sigma / norm(sigma);

tau = cross(sigma, n);
tau = tau / norm(tau);

%% ============================================================
% Tangent plane patch aligned with (tau, sigma)
% ============================================================

s1 = 0.52;
s2 = 0.42;

A  = p - s1*tau   - s2*sigma;
B  = p + s1*tau   - s2*sigma;
C1 = p + s1*tau   + s2*sigma;
D  = p - s1*tau   + s2*sigma;

planeX = [A(1) B(1); D(1) C1(1)];
planeY = [A(2) B(2); D(2) C1(2)];
planeZ = [A(3) B(3); D(3) C1(3)];

%% ============================================================
% Figure
% ============================================================

fig = figure('Color','w','Renderer','opengl');
ax = axes(fig);
hold(ax,'on');

axis(ax,'equal');
axis(ax,'vis3d');
box(ax,'off');
grid(ax,'off');
view(ax,[48 24]);

set(ax,'Units','normalized','Position',[0.02 0.02 0.96 0.96]);
set(ax,'LooseInset',[0 0 0 0]);

%% ============================================================
% Surface
% ============================================================

surf(ax, xg, yg, zg, ...
    'EdgeColor', 'none', ...
    'FaceColor', [0.42 0.64 0.92], ...
    'FaceAlpha', 0.82, ...
    'SpecularStrength', 0.06, ...
    'DiffuseStrength', 0.5, ...
    'AmbientStrength', 0.4);

lighting(ax,'gouraud');
camlight(ax,'headlight');
camlight(ax,28,16);

meshStep = 20;
mesh(ax, xg(1:meshStep:end,1:meshStep:end), ...
         yg(1:meshStep:end,1:meshStep:end), ...
         zg(1:meshStep:end,1:meshStep:end), ...
         'EdgeColor', [0.16 0.31 0.56], ...
         'FaceColor', 'none', ...
         'LineWidth', 0.35, ...
         'EdgeAlpha', 0.10);

%% ============================================================
% Curve and tangent plane
% ============================================================

plot3(ax, xC, yC, zC, ...
    'Color', [0.84 0.16 0.10], ...
    'LineWidth', 3.2);

surf(ax, planeX, planeY, planeZ, ...
    'FaceColor', [0.95 0.72 0.30], ...
    'FaceAlpha', 0.62, ...
    'EdgeColor', [0.80 0.42 0.02], ...
    'LineWidth', 1.1);

%% ============================================================
% Point x
% ============================================================

plot3(ax, p(1), p(2), p(3), '.', 'Color', 'k', 'MarkerSize', 24);

%% ============================================================
% Tangent axes and normal
% ============================================================

Ltan = 0.72;
Lnor = 0.88;

quiver3(ax, p(1), p(2), p(3), ...
    Ltan*tau(1), Ltan*tau(2), Ltan*tau(3), ...
    0, 'Color', [0.86 0.46 0.05], 'LineWidth', 1.4, 'MaxHeadSize', 0.55);

quiver3(ax, p(1), p(2), p(3), ...
    Ltan*sigma(1), Ltan*sigma(2), Ltan*sigma(3), ...
    0, 'Color', [0.86 0.46 0.05], 'LineWidth', 1.4, 'MaxHeadSize', 0.55);

quiver3(ax, p(1), p(2), p(3), ...
    Lnor*n(1), Lnor*n(2), Lnor*n(3), ...
    0, 'Color', [0.00 0.52 0.56], 'LineWidth', 1.4, 'MaxHeadSize', 0.55);

%% ============================================================
% Camera direction for lifting text slightly forward
% ============================================================

camPos = campos(ax);
camTar = camtarget(ax);

vcam = camPos - camTar;
vcam = vcam / norm(vcam);

liftSmall = 0.10 * vcam;
liftX     = 0.9 * vcam;   % more lift for x so plane won't cover it
liftTxM   = 0.14 * vcam;

%% ============================================================
% Labels (draw last)
% ============================================================

hM = text(2.02 + liftSmall(1), ...
          1.78 + liftSmall(2), ...
          a*sin(b*2.02)*sin(c*1.78)+0.20 + liftSmall(3), ...
          '$\mathsf{M}$', ...
          'Interpreter','latex', 'FontSize',25, ...
          'Color',[0.04 0.16 0.42], ...
          'Clipping','off');

hC = text(-1.55 + liftSmall(1), ...
          -0.18 + liftSmall(2), ...
          a*sin(b*(-1.55))*sin(c*(-0.18))+0.12 + liftSmall(3), ...
          '$\mathsf{C}$', ...
          'Interpreter','latex', 'FontSize',25, ...
          'Color',[0.78 0.12 0.08], ...
          'Clipping','off');

hx = text(p(1)+0.06 + liftX(1), ...
          p(2)+0.07 + liftX(2), ...
          p(3)+0.06 + liftX(3), ...
          '$x$', ...
          'Interpreter','latex', ...
          'FontSize',24, ...
          'FontWeight','bold', ...
          'Color','k', ...
          'Margin',1, ...
          'Clipping','off');

hTxM = text(p(1)+0.62 + liftTxM(1), ...
            p(2)+0.20 + liftTxM(2), ...
            p(3)+0.48 + liftTxM(3), ...
            '$\mathsf{T}_x\mathsf{M}$', ...
            'Interpreter','latex', 'FontSize',22, ...
            'Color',[0.68 0.34 0.03], ...
            'Clipping','off');

htau = text(p(1)+1.06*Ltan*tau(1) + liftSmall(1), ...
            p(2)+1.06*Ltan*tau(2) + liftSmall(2), ...
            p(3)+1.06*Ltan*tau(3) + liftSmall(3), ...
            '$\tau$', ...
            'Interpreter','latex', 'FontSize',20, ...
            'Color',[0.86 0.46 0.05], ...
            'Clipping','off');

hsigma = text(p(1)+1.06*Ltan*sigma(1) + liftSmall(1), ...
              p(2)+1.06*Ltan*sigma(2) + liftSmall(2), ...
              p(3)+1.06*Ltan*sigma(3) + liftSmall(3), ...
              '$\sigma$', ...
              'Interpreter','latex', 'FontSize',20, ...
              'Color',[0.86 0.46 0.05], ...
              'Clipping','off');

hn = text(p(1)+1.07*Lnor*n(1) + liftSmall(1), ...
          p(2)+1.07*Lnor*n(2) + liftSmall(2), ...
          p(3)+1.07*Lnor*n(3) + liftSmall(3), ...
          '$n(x)$', ...
          'Interpreter','latex', 'FontSize',20, ...
          'Color',[0.00 0.42 0.46], ...
          'Clipping','off');

%% ============================================================
% Styling
% ============================================================

ax.Visible = 'off';
camva(ax, camva(ax)*1.08);

set(fig,'PaperPositionMode','auto');

%% ============================================================
% Export
% ============================================================

% exportgraphics(fig, 'frontpage_manifold_figure.pdf', ...
%     'ContentType', 'vector', 'BackgroundColor', 'white');