clc; clear; close all;
set(groot, 'defaultTextInterpreter','latex')
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultLineLineWidth', 1.2);
set(groot, 'defaultLegendAutoUpdate','off');
set(groot, 'defaultFigureNumberTitle', 'off')

%% Surface parameters
a = 0.5;
b = 2.5;
c = 3; 
r = 2;
%% Initial conditions
IC_data;
%% Initilaization
t = 0:0.01:20;
IC = [x0;gamma0;0.8];

%% Solve

tic;
    [T,Z]=ode89(@(t,z)geo_unicycle_ext(t, z, r,a,b,c),t,IC);
toc;


%% Fetching data
for i = 1 :length(T)
    [~,h1(i,1),h1_dot(i,1),h2(i,1),h2_dot(i,1), const_1(i,1),const_2(i,1),ch(i,1),ch_dt(i,1)] = geo_unicycle_ext(T(i),Z(i,:),r,a,b,c);
end
%% Plot
figure('Name','3D plot'); hold on; grid on; view(3); axis equal;
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
figure('Name','Constraints');

subplot(1,2,1)
plot(T,const_1); hold on; grid on;
xlabel('Time(s)')
ylabel('$\gamma^\top \gamma$')

subplot(1,2,2)
plot(T,const_2); hold on; grid on;
xlabel('Time(s)')
ylabel('$n^\top \gamma$')

%% For CDC
figure('Name','CDC','NumberTitle','off');

subplot(1,2,1);grid on; hold on;
plot(T,h1); plot(T,h1_dot,'--');
xlabel('Time (s)')
legend('$h_1$','$\dot{h}_1$')

subplot(1,2,2);grid on; hold on;
% plot(T,unwrap(h2));
plot(T,h2_dot);
xlabel('Time (s)')
ylabel('$\dot{h}_2$')
% legend('$h_2$','$\dot{h}_2$')
%% Output
figure('Name','h1','NumberTitle','off');

subplot(1,2,1);grid on; hold on;
plot(T,h1);
xlabel('Time (s)')
ylabel('$h_1$')

subplot(1,2,2);grid on; hold on;
plot(T,h1_dot);
xlabel('Time (s)')
ylabel('$\dot{h}_1$')


figure('Name','h2');

subplot(1,2,1);grid on; hold on;
plot(T,h2);
xlabel('Time (s)')
ylabel('$h_2$')

subplot(1,2,2);grid on; hold on;
plot(T,h2_dot);
xlabel('Time (s)')
ylabel('$\dot{h}_2$')

figure('Name','v');hold on; grid on;
plot(T,Z(:,7));
xlabel('Time (s)')
ylabel('$v$')


%% Checking stuff
figure('Name','Checking 1'); hold on; grid on;

plot(T,ch)
xlabel('Time(s)')
title('Checkig signals')


figure('Name','Checking 2'); hold on; grid on;

plot(T,ch_dt)
plot(T(2:end),diff(ch)./diff(T),'--')
xlabel('Time(s)')
legend('$\frac{d}{dt}$ch','diff(ch)/diff(T)')
title('Checkig derivatives')

%% animate

% animate([Z(:,1).'; Z(:,2).'; Z(:,3).'], T, r,a,b,c, 'Record', false, 'Filename', 'unicyle_on_manifold.mp4')
snapshots([Z(:,1).'; Z(:,2).'; Z(:,3).'], T, r,a,b,c, [0 1 3  6  7  9 11 12])