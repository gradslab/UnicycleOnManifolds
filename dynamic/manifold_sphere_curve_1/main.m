clc; clear; close all;
set(groot, 'defaultTextInterpreter','latex')
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultLineLineWidth', 1.2);
set(groot, 'defaultLegendAutoUpdate','off');


%% Data
r = 2;
%% Initial conditions
x01 = 0.5; x02 = -0.2; x03 = sqrt(1 - x01^2 - x02^2);

x0 = r*[x01;x02;x03]; % Must be on the manifold
n0 = x0/r;

% a0 = [-2;1;0]; % Not collinear with x0
a0 = [x03;-x01;x02];

gamma0 = cross(n0,a0)/norm(cross(n0,a0));

% gamma0 = [1; 0; 0]; % Must be a unit vector AND on Tx0M

%% Initilaization
t = 0:0.01:30;
IC = [x0;gamma0;0.5];

%% Solve

tic;
    [T,Z]=ode89(@(t,z)geo_unicycle_ext(t, z, r),t,IC);
toc;


%% Fetching data
for i = 1 :length(T)
    [~,phi__2(i,1),phi__2_dot(i,1),phi__3(i,1),phi__3_dot(i,1), const_1(i,1),const_2(i,1),ch(i,1),ch_dt(i,1)] = geo_unicycle_ext(T(i),Z(i,:),r);
end
%% Plot
figure; hold on; grid on; view(3); axis equal;
[X1,X2,X3] = sphere(300);   
h = surf(r*X1,r*X2,r*X3);
set(h, ...
    'FaceColor',[0.7 0.7 0.7], ...  
    'EdgeColor','none', ...         
    'FaceAlpha',0.15);     

set(gcf,'Renderer','opengl')

plot3(Z(:,1),Z(:,2),Z(:,3))
plot3(Z(1,1),Z(1,2),Z(1,3),'.g','MarkerSize',14)
plot3(Z(end,1),Z(end,2),Z(end,3),'.r','MarkerSize',14)

%% Cosntraints
figure;

subplot(1,2,1)
plot(T,const_1); hold on; grid on;
xlabel('Time(s)')
ylabel('$\gamma^\top \gamma$')

subplot(1,2,2)
plot(T,const_2); hold on; grid on;
xlabel('Time(s)')
ylabel('$n^\top \gamma$')

%% Output
figure;

subplot(1,2,1);grid on; hold on;
plot(T,phi__2);
xlabel('Time (s)')
ylabel('$\phi_2$')

subplot(1,2,2);grid on; hold on;
plot(T,phi__2_dot);
xlabel('Time (s)')
ylabel('$\dot{\phi}_2$')


figure;

subplot(1,2,1);grid on; hold on;
plot(T,phi__3);
xlabel('Time (s)')
ylabel('$\phi_3$')

subplot(1,2,2);grid on; hold on;
plot(T,phi__3_dot);
xlabel('Time (s)')
ylabel('$\dot{\phi}_3$')
%% Checking stuff
figure; hold on; grid on;

plot(T,ch)
xlabel('Time(s)')
title('Checkig signals')


figure; hold on; grid on;

plot(T,ch_dt)
plot(T(2:end),diff(ch)./diff(T),'--')
xlabel('Time(s)')
legend('$\frac{d}{dt}$ch','diff(ch)/diff(T)')
title('Checkig derivatives')

%% animate

animate([Z(:,1).'; Z(:,2).'; Z(:,3).'], T, r, 'Record', false, 'Filename', 'unicyle_on_manifold.mp4')
