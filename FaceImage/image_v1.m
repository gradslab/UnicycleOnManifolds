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

xlimv = [-2.25 2.25];
ylimv = [-2.25 2.25];

%% ============================================================
% Surface mesh
% ============================================================

nx = 140;
ny = 140;
[xg, yg] = meshgrid(linspace(xlimv(1),xlimv(2),nx), ...
                    linspace(ylimv(1),ylimv(2),ny));
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

e1 = [1;0;fx]; e1 = e1/norm(e1);
e2 = [0;1;fy]; e2 = e2/norm(e2);

n = [-fx;-fy;1]; n = n/norm(n);

%% ============================================================
% Tangent plane patch
% ============================================================

s1 = 0.52;
s2 = 0.42;

A = p - s1*e1 - s2*e2;
B = p + s1*e1 - s2*e2;
C = p + s1*e1 + s2*e2;
D = p - s1*e1 + s2*e2;

planeX = [A(1) B(1); D(1) C(1)];
planeY = [A(2) B(2); D(2) C(2)];
planeZ = [A(3) B(3); D(3) C(3)];

%% ============================================================
% Figure
% ============================================================

fig = figure('Color','w','Renderer','opengl');
ax = axes(fig);
hold(ax,'on');

% Preserve geometric proportions
axis(ax,'equal');
axis(ax,'vis3d');

box(ax,'off');
grid(ax,'off');
view(ax,[48 24]);

% Make axes occupy the figure tightly without manual figure sizing
set(ax,'Units','normalized','Position',[0 0 1 1]);
set(ax,'LooseInset', max(get(ax,'TightInset'), 0.02*[1 1 1 1]));

% Smooth surface
surf(ax, xg, yg, zg, ...
    'EdgeColor', 'none', ...
    'FaceColor', [0.77 0.84 0.93], ...
    'FaceAlpha', 1.0, ...
    'SpecularStrength', 0.10, ...
    'DiffuseStrength', 0.90, ...
    'AmbientStrength', 0.42);

lighting(ax,'gouraud');
camlight(ax,'headlight');
camlight(ax,35,18);
camlight(ax,-55,8);

% Very light mesh overlay for geometric feel
meshStep = 16;
mesh(ax, xg(1:meshStep:end,1:meshStep:end), ...
         yg(1:meshStep:end,1:meshStep:end), ...
         zg(1:meshStep:end,1:meshStep:end), ...
         'EdgeColor', [0.25 0.40 0.62], ...
         'FaceColor', 'none', ...
         'LineWidth', 0.45, ...
         'EdgeAlpha', 0.18);

% Closed curve
plot3(ax, xC, yC, zC, ...
    'Color', [0.84 0.16 0.10], ...
    'LineWidth', 3.2);

% Tangent plane
surf(ax, planeX, planeY, planeZ, ...
    'FaceColor', [0.95 0.72 0.30], ...
    'FaceAlpha', 0.62, ...
    'EdgeColor', [0.80 0.42 0.02], ...
    'LineWidth', 1.1);

% Point x
plot3(ax, p(1), p(2), p(3), '.', 'Color', 'k', 'MarkerSize', 24);

% Tangent axes and normal
Ltan = 0.72;
Lnor = 0.88;

quiver3(ax, p(1), p(2), p(3), ...
    Ltan*e1(1), Ltan*e1(2), Ltan*e1(3), ...
    0, 'Color', [0.86 0.46 0.05], 'LineWidth', 1.4, 'MaxHeadSize', 0.55);

quiver3(ax, p(1), p(2), p(3), ...
    Ltan*e2(1), Ltan*e2(2), Ltan*e2(3), ...
    0, 'Color', [0.86 0.46 0.05], 'LineWidth', 1.4, 'MaxHeadSize', 0.55);

quiver3(ax, p(1), p(2), p(3), ...
    Lnor*n(1), Lnor*n(2), Lnor*n(3), ...
    0, 'Color', [0.00 0.52 0.56], 'LineWidth', 1.4, 'MaxHeadSize', 0.55);

%% ============================================================
% Labels
% ============================================================

text(1.80, 1.55, a*sin(b*1.80)*sin(c*1.55)+0.18, '$\mathsf{M}$', ...
    'Interpreter','latex', 'FontSize', 24, ...
    'Color', [0.12 0.24 0.52]);

text(-1.42, -0.18, a*sin(b*(-1.42))*sin(c*(-0.18))+0.12, '$\mathsf{C}$', ...
    'Interpreter','latex', 'FontSize', 24, ...
    'Color', [0.78 0.12 0.08]);

text(p(1)+0.06, p(2)+0.07, p(3)+0.06, '$x$', ...
    'Interpreter','latex', 'FontSize', 21, 'Color', 'k');

text(p(1)+0.83, p(2)+0.25, p(3)+0.48, '$\mathsf{T}_x\mathsf{M}$', ...
    'Interpreter','latex', 'FontSize', 21, ...
    'Color', [0.68 0.34 0.03]);

text(p(1)+0.96*Ltan*e1(1), p(2)+0.96*Ltan*e1(2), p(3)+0.96*Ltan*e1(3), '$\tau$', ...
    'Interpreter','latex', 'FontSize', 19, ...
    'Color', [0.86 0.46 0.05]);

text(p(1)+0.97*Ltan*e2(1), p(2)+0.97*Ltan*e2(2), p(3)+0.97*Ltan*e2(3), '$\sigma$', ...
    'Interpreter','latex', 'FontSize', 19, ...
    'Color', [0.86 0.46 0.05]);

text(p(1)+1.02*Lnor*n(1), p(2)+1.02*Lnor*n(2), p(3)+1.02*Lnor*n(3), '$n(x)$', ...
    'Interpreter','latex', 'FontSize', 19, ...
    'Color', [0.00 0.42 0.46]);

%% ============================================================
% Styling
% ============================================================

ax.Visible = 'off';
xlim(ax, xlimv);
ylim(ax, ylimv);
zlim(ax, [min(zg(:))-0.35, max(zg(:))+0.60]);

% Keep the printed/exported size tied to on-screen size
set(fig,'PaperPositionMode','auto');

%% ============================================================
% Export
% ============================================================

exportgraphics(fig, 'frontpage_manifold_figure.png', ...
    'Resolution', 450, ...
    'BackgroundColor', 'white');

print(fig, 'frontpage_manifold_figure_small.pdf', '-dpdf', '-r300');