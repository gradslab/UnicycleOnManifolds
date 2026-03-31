function snapshots(x, T, r, tShow)
%SHOW_SNAPSHOTS  Static unicycle snapshots on a sphere.
%
%   show_snapshots(x, T, r, tShow)
%
% Inputs:
%   x     : 3-by-n positions on the sphere
%   T     : n-by-1 strictly increasing time stamps
%   r     : sphere radius
%   tShow : vector of times at which to show snapshots
%
% Features:
%   - no animation
%   - static snapshots at user-selected times
%   - short constant blue tail for each snapshot
%   - orange triangular heading marker
%   - timestamp text next to each snapshot
%   - text made selectable; sphere and patches made non-selectable
%
% After the figure appears:
%   use plot edit / select mode and click-drag the timestamp labels.

% ---- Validate inputs ----
if size(x,1) ~= 3
    error('x must be 3-by-n.');
end

n = size(x,2);
T = T(:);

if numel(T) ~= n
    error('T must match number of columns of x.');
end
if any(diff(T) <= 0)
    error('T must be strictly increasing.');
end
if r <= 0
    error('r must be positive.');
end
if isempty(tShow)
    error('tShow must be nonempty.');
end

tShow = tShow(:).';
if any(tShow < T(1)) || any(tShow > T(end))
    error('All tShow values must lie in [T(1), T(end)].');
end

% ---- Figure setup ----
fig = figure('Name','Static Unicycle Snapshots');
fig.Theme = "light";

ax = axes('Parent',fig);
hold(ax,'on');
grid(ax,'on');
axis(ax,'equal');
view(ax,3);

xlabel(ax,'$x_1$','FontSize',16);
ylabel(ax,'$x_2$','FontSize',16);
zlabel(ax,'$x_3$','FontSize',16);
ax.FontSize = 12;
% ---- Draw sphere ----
[Xs,Ys,Zs] = sphere(60);
surf(ax, r*Xs, r*Ys, r*Zs, ...
    'FaceColor',[0.8 0.8 0.8], ...
    'EdgeColor','none', ...
    'FaceAlpha',0.2, ...
    'PickableParts','none', ...
    'HitTest','off');

lighting(ax,'gouraud');
camlight(ax,'headlight');

% ---- Full trajectory in light gray ----
plot3(ax, x(1,:), x(2,:), x(3,:), ...
    'Color',[0.75 0.75 0.75], ...
    'LineWidth',1, ...
    'PickableParts','none', ...
    'HitTest','off');

% ---- The curve on M ----
t = linspace(0,2*pi,500);

xc = (0.9*r/sqrt(3))*cos(t);
yc = (0.9*r)*sin(t);
zc = sqrt(r^2 - xc.^2 - yc.^2);



p=plot3(ax, xc,yc,zc,'--' ,...
    'Color',[0.4660 0.6740 0.1880 0.7], 'LineWidth',2);

lgd = legend(p,'Curve on $\mathcal{M}$','Location','north');
% ---- Styling ----
trailLen   = 35;                 % constant tail length in samples
trailColor = [0 0.4470 0.7410];  % blue
arrowColor = [0.8500 0.3250 0.0980]; % orange
arrowLen   = 0.15*r;
headWidth  = 0.06*r;
labelShift = 0.08*r;

% ---- Plot requested snapshots ----
for j = 1:numel(tShow)

    % nearest sampled index to requested time
    [~,k] = min(abs(T - tShow(j)));

    % short fixed tail
    i0 = max(1, k - trailLen + 1);
    tp = plot3(ax, x(1,i0:k), x(2,i0:k), x(3,i0:k), ...
        '-', ...
        'Color',trailColor, ...
        'LineWidth',2);
    
    % heading direction from finite difference
    if k < n
        vhat = (x(:,k+1) - x(:,k)) / (T(k+1) - T(k));
    else
        vhat = (x(:,k) - x(:,k-1)) / (T(k) - T(k-1));
    end

    if norm(vhat) < 1e-12
        continue
    end

    ghat = vhat / norm(vhat);
    xk   = x(:,k);

    % triangle marker geometry
    tip = xk + arrowLen*ghat;

    tmp = cross(ghat,[0;0;1]);
    if norm(tmp) < 1e-6
        tmp = cross(ghat,[0;1;0]);
    end
    perp = tmp / norm(tmp);

    left  = xk + headWidth*perp;
    right = xk - headWidth*perp;

    hp = patch(ax, ...
        'XData',[tip(1) left(1) right(1)], ...
        'YData',[tip(2) left(2) right(2)], ...
        'ZData',[tip(3) left(3) right(3)], ...
        'FaceColor',arrowColor, ...
        'EdgeColor','none', ...
        'PickableParts','none', ...
        'HitTest','off');

    % timestamp text
    txtPos = xk + labelShift*(perp + 0.4*ghat);

    text(ax, txtPos(1), txtPos(2), txtPos(3), ...
        sprintf('$t = %.0f$s', T(k)), ...
        'FontWeight','bold', ...
        'FontSize',12, ...
        'PickableParts','all', ...
        'HitTest','on', ...
        'Clipping','off');
end

% ---- Axes limits ----
lim = 1.2*r;
xlim(ax,[-lim lim]);
ylim(ax,[-lim lim]);
zlim(ax,[-lim lim]);

% ---- Enable plot edit mode ----
%plotedit(fig,'on');

% ---- Bring head and tail to top (for graphics)
uistack(tp, 'top')
uistack(hp, 'top')
end