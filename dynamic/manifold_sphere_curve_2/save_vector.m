clc;clear;close all;

fig = openfig('snapshots.fig');
exportgraphics(fig, 'output_filename.pdf', 'ContentType', 'vector');