clc;clear;close all;

fig1 = openfig('frontpage.fig');


exportgraphics(fig1, 'output_filename.pdf', 'ContentType', 'vector');


