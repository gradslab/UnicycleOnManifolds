theta0 = 0.8;          % angular location
r0     = 0.1;         % must be different from r

x10 = r0*cos(theta0);
x20 = r0*sin(theta0);
x30 = a * sin(b * x10) * sin(c * x20);   % guarantees x0 is on the surface

x0 = [x10; x20; x30];

% Surface normal at x0
fx = a * b * cos(b*x10) * sin(c*x20);
fy = a * c * sin(b*x10) * cos(c*x20);

% Second derivatives of f
fxx = -a * b^2 * sin(b*x10) * sin(c*x20);
fyy = -a * c^2 * sin(b*x10) * sin(c*x20);
fxy =  a * b * c * cos(b*x10) * cos(c*x20);

% Gradient of phi
g = [-fx; -fy; 1];
s = norm(g);

n0 = g / s;

% Tangent direction chosen to roughly move around the cylinder
radial_dir = [x10; -x20; 0];
gamma0 = cross(n0, radial_dir);
gamma0 = gamma0 - n0*(n0.'*gamma0);
gamma0 = gamma0 / norm(gamma0);