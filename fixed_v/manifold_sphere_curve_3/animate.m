function animate(x, T, r, a,b,c,varargin)
%ANIMATE  Animate a 3D particle moving on a sphere of radius r.
%         Shows heading direction with a filled triangular marker;
%         optionally records the animation to an MP4 video.
%
%   animate(x, T, r)
%   animate(x, T, r, 'Record', true)
%   animate(x, T, r, 'Record', true, 'Filename', 'sphere_run.mp4')

% ---- Parse name-value options ----
recordVideo = false;
filename    = 'animation.mp4';
trailLen    = 200;

if mod(numel(varargin), 2) ~= 0
    error('Optional arguments must be name-value pairs.');
end
for k = 1:2:numel(varargin)
    name = varargin{k};
    val  = varargin{k+1};
    switch lower(string(name))
        case "record"
            recordVideo = logical(val);
        case "filename"
            filename = char(val);
        case "traillen"
            trailLen = val;
        otherwise
            error('Unknown option: %s', string(name));
    end
end

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

% ---- Figure setup ----
fig = figure('Name','Animation');
fig.Theme = "light";
ax  = axes('Parent', fig);
hold(ax,'on'); grid(ax,'on'); axis(ax,'equal');
xlabel(ax,'$x_1$'); ylabel(ax,'$x_2$'); zlabel(ax,'$x_3$'); view(ax,3);

% ---- Draw surface ----
x1g = linspace(- 1.5*r, 1.5*r, 150);
x2g = linspace(- 1.5*r, 1.5*r, 150);
[Xs, Ys] = meshgrid(x1g, x2g);
Zs = a * sin(b * Xs) .* sin(c * Ys);


surf(ax, Xs, Ys, Zs, ...
    'FaceColor',[0.4 0.6 1], ...
    'EdgeColor','none', ...
    'FaceAlpha',0.2, ...
    'PickableParts','none', ...
    'HitTest','off');

lighting(ax,'gouraud');
camlight(ax,'headlight');



% ---- The curve on M ----
th = linspace(0, 2*pi, 500);
xc = r*cos(th);
yc = r*sin(th);
zc = a * sin(b * xc) .* sin(c * yc);



p=plot3(ax, xc,yc,zc, ...
    'Color',[0.4660 0.6740 0.1880], 'LineWidth',2);

legend(p,'Curve on $\mathsf{M}$','Location','north');
% lim = 2.2*r;
% xlim(ax,[-lim lim]); ylim(ax,[-lim lim]); zlim(ax,[-lim lim]);

% ---- Trail ----
tailPoints = 35;   % fixed trail length in number of samples
hTrail = plot3(ax, NaN,NaN,NaN, '-', ...
    'Color',[0 0.4470 0.7410], 'LineWidth',2);

% ---- Triangle heading marker ----
arrowColor = [0.8500 0.3250 0.0980]; % modern orange
arrowLen   = 0.15*r;
headWidth  = 0.06*r;

hHead = patch(ax, ...
    'XData',[], 'YData',[], 'ZData',[], ...
    'FaceColor',arrowColor, ...
    'EdgeColor','none');

% ---- Timestamp ----
hTime = text(ax,0.02,0.98,0.98,'', ...
    'Units','normalized', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','top', ...
    'FontWeight','bold', ...
    'FontSize',12);

% ---- Optional recording ----
if recordVideo
    vw = VideoWriter(filename,'MPEG-4');
    vw.Quality   = 95;
    vw.FrameRate = 30;
    open(vw);
else
    vw = [];
end

% ---- Animation ----
t0 = tic; T0 = T(1);

for k = 1:n
    if ~ishandle(fig), break; end

    % Real-time pacing
    target = T(k) - T0;
    while toc(t0) < target
        pause(0.001);
        if ~ishandle(fig), break; end
    end

    % Trail update
        % Trail update
    i0 = max(1, k - tailPoints + 1);

    set(hTrail, ...
        'XData', x(1,i0:k), ...
        'YData', x(2,i0:k), ...
        'ZData', x(3,i0:k));
    set(hTrail,'XData',x(1,i0:k), ...
        'YData',x(2,i0:k), ...
        'ZData',x(3,i0:k));

    % ---- Heading direction from finite difference ----
    if k < n
        vhat = (x(:,k+1)-x(:,k))/(T(k+1)-T(k));
    else
        vhat = (x(:,k)-x(:,k-1))/(T(k)-T(k-1));
    end
    if norm(vhat) < 1e-12
        continue
    end
    ghat = vhat/norm(vhat);

    % Triangle geometry
    xk  = x(:,k);
    tip = xk + arrowLen*ghat;

    tmp = cross(ghat,[0;0;1]);
    if norm(tmp)<1e-6
        tmp = cross(ghat,[0;1;0]);
    end
    perp = tmp/norm(tmp);

    left  = xk + headWidth*perp;
    right = xk - headWidth*perp;

    set(hHead,'XData',[tip(1) left(1) right(1)], ...
        'YData',[tip(2) left(2) right(2)], ...
        'ZData',[tip(3) left(3) right(3)]);

    % Timestamp
    set(hTime,'String',sprintf('$t =$ %.3f s',T(k)));

    drawnow;

    if recordVideo
        writeVideo(vw,getframe(fig));
    end
end

if recordVideo
    close(vw);
    fprintf('Saved video to: %s\n',filename);
end
end
