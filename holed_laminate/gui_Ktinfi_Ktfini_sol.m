##
## ----------------------------------------
## Coded by Sumit Sunil Kumar (July 2019)
## Email: f20180029@goa.bits-pilani.ac.in
## ----------------------------------------
## This is a Graphical User Interface that has been prepared.
## The GUI requires the following .m files f_gui_finiteplate and global_stress.m
## ----------------------------------------
##The inputs entered by user in the editable boxes in the screen are:
## [a] The number of layers of the material (N)
## [b] The stresses of the corresponding layer (e1, e2, g12) 
## [c] The poisson ratios of the layer (mu12, mu21)
## [d] The fiber orientation angle (theta) and the distance of each layer from origin (z)
## [e] The forces and moments of the layer (Nx, Ny, Nxy, Mx, My, Mxy)
## [f] The diameter and width of the hole (d,w)
## -----------------------------------------
## The outputs are the stress concentration of the finite plate (Kt) 
## and the stress concentration of the infiniteplate (Ktinfi).
## -----------------------------------------



function gui_Ktinfi_Ktfini_sol()

clc
clear
close all

global fH;
global fW;
global inp_N;
global inp_e1; 
global inp_e2; 
global inp_mu12; 
global inp_mu21; 
global inp_g12;
global inp_w;
global inp_d;
global inp_theta;
global inp_z;
global my_theta;
global my_z;

% Make a large figure.
fW = 600; fH = 400;
my_gui = figure('position',[0 0 fW fH], 'name', 'Stress Concentration', 'NumberTitle', 'off');


% Just some descriptive text.
my_title = uicontrol('Style', 'text', 'String', 'Holed Laminate',...
'Position', [(fW/2)-50 fH-25 100 20]);

%my_credits = uicontrol('Style', 'text', 'String', 'An Octave GUI by Sumit',...
%'Position', [(fW)-250 40 200 20]);
%set(my_credits,'ForegroundColor','blue','Backgroundcolor','yellow','Fontweight','bold');

uicontrol('Style', 'text', 'String', 'No of Layers =',...
'Position', [10 fH-50 100 15]);
inp_N = uicontrol('Style', 'edit',...
'Position', [155 fH-50 50 15]);

uicontrol('Style', 'text', 'String', 'e1 =',...
'Position', [10 fH-70 45 15]);
inp_e1 = uicontrol('Style', 'edit',...
'Position', [55 fH-70 50 15]);

uicontrol('Style', 'text', 'String', 'e2 =',...
'Position', [110 fH-70 45 15]);
inp_e2 = uicontrol('Style', 'edit',...
'Position', [155 fH-70 50 15]);

uicontrol('Style', 'text', 'String', 'mu12 =',...
'Position', [10 fH-90 45 15]);
inp_mu12 = uicontrol('Style', 'edit',...
'Position', [55 fH-90 50 15]);

uicontrol('Style', 'text', 'String', 'mu21 =',...
'Position', [10 fH-110 45 15]);
inp_mu21 = uicontrol('Style', 'edit',...
'Position', [55 fH-110 50 15]);

uicontrol('Style', 'text', 'String', 'g12 =',...
'Position', [10 fH-130 45 15]);
inp_g12 = uicontrol('Style', 'edit',...
'Position', [55 fH-130 50 15]);

uicontrol('Style', 'text', 'String', 'd =',...
'Position', [10 fH-150 45 15]);
inp_d = uicontrol('Style', 'edit',...
'Position', [55 fH-150 50 15]);

uicontrol('Style', 'text', 'String', 'w =',...
'Position', [10 fH-170 45 15]);
inp_w = uicontrol('Style', 'edit',...
'Position', [55 fH-170 50 15]);

h_moredata = uicontrol('Style', 'pushbutton', 'String', 'More Data',...
'Position', [225 fH-50 100 20],'Callback', @Get_More_Values);
% set(h_moredata, 'Callback', {@Get_More_Values});

h_run = uicontrol('Style', 'pushbutton', 'String', 'Run',...
'Position', [350 fH-50 50 20],'Callback', @Get_Values);
% set(h_run, 'Callback', {@Get_Values});

endfunction

%%%% Need to get more values based on the input inp_N.

function Get_More_Values(hObject,eventdata)
%function Get_More_Values(h_moredata,eventdata)
global fH;
global fW;
global inp_N;
global inp_e1;
global inp_e2;
global inp_mu12;
global inp_mu21;
global inp_g12;
global inp_w;
global inp_d;
global inp_theta;
global inp_z;
global my_theta;
global my_z;


N = get(inp_N,'String');

uicontrol('Style', 'text', 'String', 'theta',...
'Position', [100*str2num(N) fH-190 75 15]);
uicontrol('Style', 'text', 'String', 'z',...
'Position', [100*str2num(N) fH-210 75 15]);

for i = 1:str2num(N)
uicontrol('Style', 'text', 'String', num2str(i),...
'Position', [100*i-85 fH-190 25 15]);
inp_theta(i) = uicontrol('Style', 'edit',...
'Position', [100*i-60 fH-190 25 15]);

uicontrol('Style', 'text', 'String', num2str(i),...
'Position', [100*i-85 fH-210 25 15]);
inp_z(i) = uicontrol('Style', 'edit',...
'Position', [100*i-60 fH-210 25 15]);
endfor

endfunction

%% Called by SimpeGUI to do the plotting
% hObject is the button and eventdata is unused.

function Get_Values(hObject,eventdata)
%function Get_Values(h_run,eventdata)
global fH;
global fW;
global inp_N;
global inp_e1; 
global inp_e2;% Slider is a handle to the slider.
global inp_mu12; 
global inp_mu21; 
global inp_g12;
global inp_theta;
global inp_z;
global my_theta;
global my_z;
global inp_w;
global inp_d;

% Gets the value of the parameter from the slider.
e1 = get(inp_e1,'String');
e2 = get(inp_e2,'String');
mu12 = get(inp_mu12,'String');
mu21 = get(inp_mu21,'String');
g12 = get(inp_g12,'String');
w = get(inp_w,'String');
d = get(inp_d,'String');


N = get(inp_N,'String');

for i=1:str2num(N)
my_theta(i) = str2num(get(inp_theta(i),'String'));
my_z(i) = str2num(get(inp_z(i),'String'));
endfor
% calling the outputs from the function f_gui_finiteplate.m
[Q, t1, t2, Q_g, A, KTinfi, KT] = f_gui_finiteplate(str2num(N), str2num(e1), str2num(e2), str2num(g12), str2num(mu12), str2num(mu21), str2num(d),...
 str2num(w), (my_theta), (my_z));

R = fW-200; C = fH-220; W = 100; H = 20;
%Kt positioning and value 
uicontrol('Style', 'text', 'String', num2str(KT), 'Position', [(R)+60 (C)-50 W H]);
uicontrol('Style', 'text', 'String', "KT = ", 'Position', [(R)-40 (C)-50 W H]);
%Ktinfi positioning and value 
uicontrol('Style', 'text', 'String', num2str(KTinfi), 'Position', [(R)+60 (C)-80 W H]);
uicontrol('Style', 'text', 'String', "KTinfi = ", 'Position', [(R)-40 (C)-80 W H]);
 
 endfunction
