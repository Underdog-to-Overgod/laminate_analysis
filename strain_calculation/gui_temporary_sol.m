##
## ----------------------------------------
## Coded by Sumit Sunil Kumar (July 2019)
## Email: f20180029@goa.bits-pilani.ac.in
## ----------------------------------------
## This is a Graphical User Interface that has been prepared.
## The GUI requires the following .m files f_gui_straincalc.m and global_stress.m
## The GUI opens and the user enters the values that come on the screen once
## the command is executed and gets the output.
## ----------------------------------------
## The following inputs are required:
## [a] The number of layers of the material (N)
## [b] The stresses of the corresponding layer (e1, e2, g12) 
## [c] The poisson ratios of the layer (mu12, mu21)
## [d] The fiber orientation angle (theta) and the distance of each layer from origin (z)
## [e] The forces and moments of the layer (Nx, Ny, Nxy, Mx, My, Mxy)
## -----------------------------------------
## The following outputs are visible in the GUI:
## [a] A, B, D matrices.
## [b] inverse of the 6 by 6 matrix formed by A, B, D.
## [c] The transpose of strain matrix.
## ------------------------------------------

function gui_temporary_sol()

close all

global inp_N;
global inp_e1; 
global inp_e2; 
global inp_mu12; 
global inp_mu21; 
global inp_g12;
global inp_theta;
global inp_z;
global my_theta;
global my_z;
global inp_Nx;
global inp_Ny;
global inp_Nxy;
global inp_Mx;
global inp_My;
global inp_Mxy;

% Make a large figure.
my_ui = figure('position',[0 0 1500 500], 'name', 'Lamination', 'NumberTitle', 'off');

% Just some descriptive text.
uicontrol('Style', 'text', 'String', 'Lamination',...
'Position', [700 475 100 20]);

my_credits = uicontrol('Style', 'text', 'String', 'A GUI attempt by Sumit',...
'Position', [650 30 200 20]);
set(my_credits,'ForegroundColor','blue','Backgroundcolor','yellow','Fontweight','bold');

uicontrol('Style', 'text', 'String', 'No of Layers =',...
'Position', [10 450 100 15]);
inp_N = uicontrol('Style', 'edit',...
'Position', [155 450 50 15]);

uicontrol('Style', 'text', 'String', 'e1 =',...
'Position', [10 430 45 15]);
inp_e1 = uicontrol('Style', 'edit',...
'Position', [55 430 50 15]);

uicontrol('Style', 'text', 'String', 'e2 =',...
'Position', [110 430 45 15]);
inp_e2 = uicontrol('Style', 'edit',...
'Position', [155 430 50 15]);

uicontrol('Style', 'text', 'String', 'mu12 =',...
'Position', [10 410 45 15]);
inp_mu12 = uicontrol('Style', 'edit',...
'Position', [55 410 50 15]);

uicontrol('Style', 'text', 'String', 'mu21 =',...
'Position', [10 390 45 15]);
inp_mu21 = uicontrol('Style', 'edit',...
'Position', [55 390 50 15]);

uicontrol('Style', 'text', 'String', 'g12 =',...
'Position', [10 370 45 15]);
inp_g12 = uicontrol('Style', 'edit',...
'Position', [55 370 50 15]);

uicontrol('Style', 'text', 'String', 'Nx =',...
'Position', [10 350 45 15]);
inp_Nx = uicontrol('Style', 'edit',...
'Position', [55 350 50 15]);

uicontrol('Style', 'text', 'String', 'Ny =',...
'Position', [10 330 45 15]);
inp_Ny = uicontrol('Style', 'edit',...
'Position', [55 330 50 15]);

uicontrol('Style', 'text', 'String', 'Nxy =',...
'Position', [10 310 45 15]);
inp_Nxy = uicontrol('Style', 'edit',...
'Position', [55 310 50 15]);

uicontrol('Style', 'text', 'String', 'Mx =',...
'Position', [10 290 45 15]);
inp_Mx = uicontrol('Style', 'edit',...
'Position', [55 290 50 15]);

uicontrol('Style', 'text', 'String', 'My =',...
'Position', [10 270 45 15]);
inp_My = uicontrol('Style', 'edit',...
'Position', [55 270 50 15]);

uicontrol('Style', 'text', 'String', 'Mxy =',...
'Position', [10 250 45 15]);
inp_Mxy = uicontrol('Style', 'edit',...
'Position', [55 250 50 15]);

%R=200; C=50; W=100; H=20;
%uicontrol('Style', 'text', 'String', "F = ", 'Position', [R-40 70 W-70 H]);
%uicontrol('Style', 'text', 'String', '(F(1,1))', 'Position', [R+30 70 W H]);
%uicontrol('Style', 'text', 'String', '(F(2,1))', 'Position', [R+30+W 70 W H]);
%uicontrol('Style', 'text', 'String', '(F(3,1))', 'Position', [R+300 70 W H]);
%uicontrol('Style', 'text', 'String', '(F(4,1))', 'Position', [R+400 70 W H]);
%uicontrol('Style', 'text', 'String', '(F(5,1))', 'Position', [R+500 70 W H]);
%uicontrol('Style', 'text', 'String', '(F(6,1))', 'Position', [R+600 70 W H]);


h_moredata = uicontrol('Style', 'pushbutton', 'String', 'More Data',...
'Position', [225 450 100 20],'Callback', @Get_More_Values);
set(h_moredata, 'Callback', {@Get_More_Values});

h_run = uicontrol('Style', 'pushbutton', 'String', 'Run',...
'Position', [350 450 50 20],'Callback', @Get_Values);
set(h_run, 'Callback', {@Get_Values});

endfunction

%%%% Need to get more values based on the input inp_N.

function Get_More_Values(hObject,eventdata)
%function Get_More_Values(h_moredata,eventdata)

global inp_N;
global inp_e1;
global inp_e2;
global inp_mu12;
global inp_mu21;
global inp_g12;
global inp_theta;
global inp_z;
global my_theta;
global my_z;
global inp_Nx;
global inp_Ny;
global inp_Nxy;
global inp_Mx;
global inp_My;
global inp_Mxy;

N = get(inp_N,'String');
%For positioning the angles and distance from origin
uicontrol('Style', 'text', 'String', 'theta',...
'Position', [100*str2num(N) 50 75 15]);
uicontrol('Style', 'text', 'String', 'z',...
'Position', [100*str2num(N) 30 75 15]);

%From layer 1 to layer N, the user enters the value of theta and z
for i = 1:str2num(N)
uicontrol('Style', 'text', 'String', num2str(i),...
'Position', [100*i-85 50 25 15]);
inp_theta(i) = uicontrol('Style', 'edit',...
'Position', [100*i-60 50 25 15]);

uicontrol('Style', 'text', 'String', num2str(i),...
'Position', [100*i-85 30 25 15]);
inp_z(i) = uicontrol('Style', 'edit',...
'Position', [100*i-60 30 25 15]);
endfor

endfunction

%% Called by SimpeGUI to do the plotting
% hObject is the button and eventdata is unused.

function Get_Values(hObject,eventdata)
%function Get_Values(h_run,eventdata)

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
global inp_Nx;
global inp_Ny;
global inp_Nxy;
global inp_Mx;
global inp_My;
global inp_Mxy;


% Gets the value of the parameter from the slider.
e1 = get(inp_e1,'String');
e2 = get(inp_e2,'String');
mu12 = get(inp_mu12,'String');
mu21 = get(inp_mu21,'String');
g12 = get(inp_g12,'String');
Nx = get(inp_Nx,'String');
Ny = get(inp_Ny,'String');
Nxy = get(inp_Nxy,'String');
Mx = get(inp_Mx,'String');
My = get(inp_My,'String');
Mxy = get(inp_Mxy,'String');

% Puts the value of the parameter on the GUI.
if(e1 != " ")
  uicontrol('Style', 'text', 'String', num2str(e1),'Position', [120 470  40 20]);
else
  uicontrol('Style', 'text', 'String', "e1?",'Position', [120 470  40 20]);
endif

if(e2 != " ")
uicontrol('Style', 'text', 'String', num2str(e2),'Position', [170  470 40 20]);
else
uicontrol('Style', 'text', 'String', "e2?",'Position', [170  470 40 20]);
endif
if(mu12 != " ")
uicontrol('Style', 'text', 'String', num2str(mu12),'Position', [220  470 40 20]);
else
uicontrol('Style', 'text', 'String', "mu12?",'Position', [220  470 40 20]);
endif
if(mu21 != " ")
uicontrol('Style', 'text', 'String', num2str(mu21),'Position', [270 470 40 20]);
else
uicontrol('Style', 'text', 'String', "mu21?",'Position', [270 470 40 20]);
endif
if(g12 != " ")
uicontrol('Style', 'text', 'String', num2str(g12),'Position', [320  470 40 20]);
else
uicontrol('Style', 'text', 'String', "g12?",'Position', [320  470 40 20]);
endif
if(Nx != " ")
uicontrol('Style', 'text', 'String', num2str(Nx),'Position', [370  470 40 20]);
else
uicontrol('Style', 'text', 'String', "Nx?",'Position', [370  470 40 20]);
endif
if(Ny != " ")
uicontrol('Style', 'text', 'String', num2str(Ny),'Position', [420  470 40 20]);
else
uicontrol('Style', 'text', 'String', "Ny?",'Position', [420  470 40 20]);
endif
if(Nxy != " ")
uicontrol('Style', 'text', 'String', num2str(Nxy),'Position', [470  470 40 20]);
else
uicontrol('Style', 'text', 'String', "g12?",'Position', [470  470 40 20]);
endif
if(Mx != " ")
uicontrol('Style', 'text', 'String', num2str(Mx),'Position', [520  470 40 20]);
else
uicontrol('Style', 'text', 'String', "Mx?",'Position', [520  470 40 20]);
endif
if(My != " ")
uicontrol('Style', 'text', 'String', num2str(My),'Position', [570  470 40 20]);
else
uicontrol('Style', 'text', 'String', "My?",'Position', [570  470 40 20]);
endif
if(Mxy != " ")
uicontrol('Style', 'text', 'String', num2str(Mxy),'Position', [620  470 40 20]);
else
uicontrol('Style', 'text', 'String', "Mxy?",'Position', [620  470 40 20]);
endif

N = get(inp_N,'String');

for i=1:str2num(N)
my_theta(i) = str2num(get(inp_theta(i),'String'));
my_z(i) = str2num(get(inp_z(i),'String'));
endfor

[Q, t1, t2, Q_g, A, B, D, E, F] = f_gui_straincalc(str2num(N), str2num(e1), str2num(e2), str2num(g12), str2num(mu12), str2num(mu21),...
(my_theta), (my_z), num2str(Nx), num2str(Ny), num2str(Nxy), num2str(Mx), num2str(My), num2str(Mxy));
% print Q
R=200; C=50; W=100; H=20;
uicontrol('Style', 'text', 'String', num2str(Q(1,1)), 'Position', [R C+350 W H]);
uicontrol('Style', 'text', 'String', num2str(Q(1,2)), 'Position', [R+100 C+350 W H]);
uicontrol('Style', 'text', 'String', num2str(Q(1,3)), 'Position', [R+200 C+350 W H]);

uicontrol('Style', 'text', 'String', num2str(Q(2,1)), 'Position', [R C+325 W H]);
uicontrol('Style', 'text', 'String', num2str(Q(2,2)), 'Position', [R+100 C+325 W H]);
uicontrol('Style', 'text', 'String', num2str(Q(2,3)), 'Position', [R+200 C+325 W H]);
uicontrol('Style', 'text', 'String', "Q = ", 'Position', [R-40 C+325 W-70 H]);


uicontrol('Style', 'text', 'String', {num2str(Q(3,1))}, 'Position', [R C+300 W H]);
uicontrol('Style', 'text', 'String', num2str(Q(3,2)), 'Position', [R+100 C+300 W H]);
uicontrol('Style', 'text', 'String', num2str(Q(3,3)), 'Position', [R+200 C+300 W H]);
%A matrix
uicontrol('Style', 'text', 'String', num2str(A(1,1)), 'Position', [R C+250 W H]);
uicontrol('Style', 'text', 'String', num2str(A(1,2)), 'Position', [R+100 C+250 W H]);
uicontrol('Style', 'text', 'String', num2str(A(1,3)), 'Position', [R+200 C+250 W H]);

uicontrol('Style', 'text', 'String', num2str(A(2,1)), 'Position', [R C+225 W H]);
uicontrol('Style', 'text', 'String', num2str(A(2,2)), 'Position', [R+100 C+225 W H]);
uicontrol('Style', 'text', 'String', num2str(A(2,3)), 'Position', [R+200 C+225 W H]);
uicontrol('Style', 'text', 'String', "A = ", 'Position', [R-40 C+225 W-70 H]);


uicontrol('Style', 'text', 'String', num2str(A(3,1)), 'Position', [R C+200 W H]);
uicontrol('Style', 'text', 'String', num2str(A(3,2)), 'Position', [R+100 C+200 W H]);
uicontrol('Style', 'text', 'String', num2str(A(3,3)), 'Position', [R+200 C+200 W H]);
%B matrix
uicontrol('Style', 'text', 'String', num2str(B(1,1)), 'Position', [R C+150 W H]);
uicontrol('Style', 'text', 'String', num2str(B(1,2)), 'Position', [R+100 C+150 W H]);
uicontrol('Style', 'text', 'String', num2str(B(1,3)), 'Position', [R+200 C+150 W H]);

uicontrol('Style', 'text', 'String', num2str(B(2,1)), 'Position', [R C+125 W H]);
uicontrol('Style', 'text', 'String', num2str(B(2,2)), 'Position', [R+100 C+125 W H]);
uicontrol('Style', 'text', 'String', num2str(B(2,3)), 'Position', [R+200 C+125 W H]);
uicontrol('Style', 'text', 'String', "B = ", 'Position', [R-40 C+125 W-70 H]);


uicontrol('Style', 'text', 'String', num2str(B(3,1)), 'Position', [R C+100 W H]);
uicontrol('Style', 'text', 'String', num2str(B(3,2)), 'Position', [R+100 C+100 W H]);
uicontrol('Style', 'text', 'String', num2str(B(3,3)), 'Position', [R+200 C+100 W H]);

%D matrix
uicontrol('Style', 'text', 'String', num2str(D(1,1)), 'Position', [R+500 C+350 W H]);
uicontrol('Style', 'text', 'String', num2str(D(1,2)), 'Position', [R+600 C+350 W H]);
uicontrol('Style', 'text', 'String', num2str(D(1,3)), 'Position', [R+700 C+350 W H]);

uicontrol('Style', 'text', 'String', num2str(D(2,1)), 'Position', [R+500 C+325 W H]);
uicontrol('Style', 'text', 'String', num2str(D(2,2)), 'Position', [R+600 C+325 W H]);
uicontrol('Style', 'text', 'String', num2str(D(2,3)), 'Position', [R+700 C+325 W H]);
uicontrol('Style', 'text', 'String', "D = ", 'Position', [R+460 C+325 W-70 H]);


uicontrol('Style', 'text', 'String', num2str(D(3,1)), 'Position', [R+500 C+300 W H]);
uicontrol('Style', 'text', 'String', num2str(D(3,2)), 'Position', [R+600 C+300 W H]);
uicontrol('Style', 'text', 'String', num2str(D(3,3)), 'Position', [R+700 C+300 W H]);

%E the inverse 6by6 matrix
uicontrol('Style', 'text', 'String', num2str(E(1,1)), 'Position', [R+500 C+250 W H]);
uicontrol('Style', 'text', 'String', num2str(E(1,2)), 'Position', [R+600 C+250 W H]);
uicontrol('Style', 'text', 'String', num2str(E(1,3)), 'Position', [R+700 C+250 W H]);
uicontrol('Style', 'text', 'String', num2str(E(1,4)), 'Position', [R+800 C+250 W H]);
uicontrol('Style', 'text', 'String', num2str(E(1,5)), 'Position', [R+900 C+250 W H]);
uicontrol('Style', 'text', 'String', num2str(E(1,6)), 'Position', [R+1000 C+250 W H]);

uicontrol('Style', 'text', 'String', num2str(E(2,1)), 'Position', [R+500 C+225 W H]);
uicontrol('Style', 'text', 'String', num2str(E(2,2)), 'Position', [R+600 C+225 W H]);
uicontrol('Style', 'text', 'String', num2str(E(2,3)), 'Position', [R+700 C+225 W H]);
uicontrol('Style', 'text', 'String', num2str(E(2,4)), 'Position', [R+800 C+225 W H]);
uicontrol('Style', 'text', 'String', num2str(E(2,5)), 'Position', [R+900 C+225 W H]);
uicontrol('Style', 'text', 'String', num2str(E(2,6)), 'Position', [R+1000 C+225 W H]);

uicontrol('Style', 'text', 'String', num2str(E(3,1)), 'Position', [R+500 C+200 W H]);
uicontrol('Style', 'text', 'String', num2str(E(3,2)), 'Position', [R+600 C+200 W H]);
uicontrol('Style', 'text', 'String', num2str(E(3,3)), 'Position', [R+700 C+200 W H]);
uicontrol('Style', 'text', 'String', num2str(E(3,4)), 'Position', [R+800 C+200 W H]);
uicontrol('Style', 'text', 'String', num2str(E(3,5)), 'Position', [R+900 C+200 W H]);
uicontrol('Style', 'text', 'String', num2str(E(3,6)), 'Position', [R+1000 C+200 W H]);

uicontrol('Style', 'text', 'String', num2str(E(4,1)), 'Position', [R+500 C+175 W H]);
uicontrol('Style', 'text', 'String', num2str(E(4,2)), 'Position', [R+600 C+175 W H]);
uicontrol('Style', 'text', 'String', num2str(E(4,3)), 'Position', [R+700 C+175 W H]);
uicontrol('Style', 'text', 'String', num2str(E(4,4)), 'Position', [R+800 C+175 W H]);
uicontrol('Style', 'text', 'String', num2str(E(4,5)), 'Position', [R+900 C+175 W H]);
uicontrol('Style', 'text', 'String', num2str(E(4,6)), 'Position', [R+1000 C+175 W H]);
uicontrol('Style', 'text', 'String', "E = ", 'Position', [R+460 C+175 W-70 H]);

uicontrol('Style', 'text', 'String', num2str(E(5,1)), 'Position', [R+500 C+150 W H]);
uicontrol('Style', 'text', 'String', num2str(E(5,2)), 'Position', [R+600 C+150 W H]);
uicontrol('Style', 'text', 'String', num2str(E(5,3)), 'Position', [R+700 C+150 W H]);
uicontrol('Style', 'text', 'String', num2str(E(5,4)), 'Position', [R+800 C+150 W H]);
uicontrol('Style', 'text', 'String', num2str(E(5,5)), 'Position', [R+900 C+150 W H]);
uicontrol('Style', 'text', 'String', num2str(E(5,6)), 'Position', [R+1000 C+150 W H]);

uicontrol('Style', 'text', 'String', num2str(E(6,1)), 'Position', [R+500 C+125 W H]);
uicontrol('Style', 'text', 'String', num2str(E(6,2)), 'Position', [R+600 C+125 W H]);
uicontrol('Style', 'text', 'String', num2str(E(6,3)), 'Position', [R+700 C+125 W H]);
uicontrol('Style', 'text', 'String', num2str(E(6,4)), 'Position', [R+800 C+125 W H]);
uicontrol('Style', 'text', 'String', num2str(E(6,5)), 'Position', [R+900 C+125 W H]);
uicontrol('Style', 'text', 'String', num2str(E(6,6)), 'Position', [R+1000 C+125 W H]);

%strain matrix

%uicontrol('Style', 'text', 'String', "B = ", 'Position', [R-40 C+125 W-70 H]);
uicontrol('Style', 'text', 'String', "F' = ", 'Position', [R+50 80 W-70 H]);

uicontrol('Style', 'text', 'String', num2str(F(1,1)), 'Position', [R+100 80 W H]);
uicontrol('Style', 'text', 'String', num2str(F(2,1)), 'Position', [R+200 80 W H]);
uicontrol('Style', 'text', 'String', num2str(F(3,1)), 'Position', [R+300 80 W H]);
uicontrol('Style', 'text', 'String', num2str(F(4,1)), 'Position', [R+400 80 W H]);
uicontrol('Style', 'text', 'String', num2str(F(5,1)), 'Position', [R+500 80 W H]);
uicontrol('Style', 'text', 'String', num2str(F(6,1)), 'Position', [R+600 80 W H]);



endfunction
