clc; clear; close all;
set(groot, 'defaultTextInterpreter','latex')
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultLineLineWidth', 1.2);
set(groot, 'defaultLegendAutoUpdate','off');


%% Surface parameters
a = 0.5;
b = 2.5;
c = 3; 
r = 2;
%% Initial conditions
IC_data;

%% Initilaization
t = 0:0.01:20;
IC = [x0;gamma0];

%% Solve

tic;
    [T,Z]=ode89(@(t,z)geo_unicycle(t, z, r,a,b,c),t,IC);
toc;


%% Fetching data
for i = 1 :length(T)
    [~,h1(i,1),h1_dot(i,1), const_1(i,1),const_2(i,1),ch(i,1),ch_dt(i,1)] = geo_unicycle(T(i),Z(i,:),r,a,b,c);
end

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
figure; grid on; hold on;
plot(T,h1); plot(T,h1_dot,'--');
xlabel('Time (s)')
legend('$h_1$','$\dot{h}_1$')
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

% animate([Z(:,1).'; Z(:,2).'; Z(:,3).'], T, r,a,b,c, 'Record', false, 'Filename', 'unicyle_on_manifold.mp4')
snapshots([Z(:,1).'; Z(:,2).'; Z(:,3).'], T, r, a,b,c,[0 1 2 3 4  6  8  9])