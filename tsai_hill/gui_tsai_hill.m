## A GUI for matrial failure using Tsai-hill failure criteria
## ----------------------------------------
## Coded by Sumit Sunil Kumar (July 2019)
## Email: f201800289@goa.bits-pilani.ac.in
## ----------------------------------------
## This is the main Graphical User Interface that has been prepared.
## The GUI requires the following .m files f_gui_tsai.m and global_stress.m
## The GUI opens and the user enters the values that come on the screen once
## the command is executed and gets the output.
## -----------------------------------------
## The following inputs are required:
## [a] The number of layers of the material (N)
## [b] The stresses of the corresponding layer (e1, e2, g12) 
## [c] The poisson ratios of the layer (mu12, mu21)
## [d] The fiber orientation angle (theta) and the distance of each layer from origin (z)
## [e] The forces and moments of the layer (Nx, Ny, Nxy, Mx, My, Mxy)
## [f] The material strengths in the X, Y and shear direction (X, Y, S)
## [g] The mid-plane axis distance (x)
## ----------------------------------------
## The output that is displayed on the screen shows:
## [a] The A, B, D stiffness matrices.
## [b] The strain of the material.
## [c] Whether the material has failed or not.
## [d] If the material fails, then how many layers failed.
## -----------------------------------------

function gui_tsai_hill()

close all;
% Entering all the inputs
global inp_N;
global inp_e1; global inp_e2; 
global inp_mu12; global inp_mu21; 
global inp_g12;
global inp_theta; global my_theta;
global inp_z; global my_z;
global inp_Nx; global inp_Ny; global inp_Nxy;
global inp_Mx; global inp_My; global inp_Mxy;
global inp_X; global inp_Y; global inp_S; global inp_x;

% Make a large figure.
my_ui = figure('position',[0 0 1500 500], 'name', 'Lamination', 'NumberTitle', 'off');

%Descriptive text
my_credits = uicontrol('Style', 'text', 'String', 'A GUI by Sumit (Lamination)',...
'Position', [650 30 300 20]);
set(my_credits,'ForegroundColor','white','Backgroundcolor','black','Fontweight','bold','fontsize',12);

%Positioning the texts
uicontrol('Style', 'text', 'String', 'No of Layers =',...
'Position', [10 450 100 15],'foregroundcolor',[0 0 1]);
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

uicontrol('Style', 'text', 'String', 'X =',...
'Position', [10 230 45 15]);
inp_X = uicontrol('Style', 'edit',...
'Position', [55 230 50 15]);

uicontrol('Style', 'text', 'String', 'Y =',...
'Position', [10 210 45 15]);
inp_Y = uicontrol('Style', 'edit',...
'Position', [55 210 50 15]);

uicontrol('Style', 'text', 'String', 'S =',...
'Position', [10 190 45 15]);
inp_S = uicontrol('Style', 'edit',...
'Position', [55 190 50 15]);

uicontrol('Style', 'text', 'String', 'x =',...
'Position', [10 170 45 15]);
inp_x = uicontrol('Style', 'edit',...
'Position', [55 170 50 15]);

%The 2 buttons that are used to execute the running of the code.
h_moredata = uicontrol('Style', 'pushbutton', 'String', '1. More Data',...
'Position', [225 450 100 20],'Callback', @Get_More_Values);

h_run = uicontrol('Style', 'pushbutton', 'String', '2. Run',...
'Position', [350 450 50 20],'Callback', @Run_Values);

endfunction

%%%% Need to get more values based on the input inp_N.

function Get_More_Values(hObject,eventdata)

global inp_N;
global inp_e1; global inp_e2; 
global inp_mu12; global inp_mu21; 
global inp_g12;
global inp_theta; global my_theta;
global inp_z; global my_z;
global inp_Nx; global inp_Ny; global inp_Nxy;
global inp_Mx; global inp_My; global inp_Mxy;
global inp_X; global inp_Y; global inp_S; global inp_x;

N = get(inp_N,'String');
% This is for entering the text for theta and z
uicontrol('Style', 'text', 'String', 'theta',...
'Position', [100*str2num(N) 50 75 15],'foregroundcolor',[0 0 1]);
uicontrol('Style', 'text', 'String', 'z',...
'Position', [100*str2num(N) 30 75 15], 'foregroundcolor', [0 0 1]);

uicontrol('Style', 'frame', 'Position', [100 100 10 20], 'backgroundcolor', [0 0 1]);

% This is for getting a suitable position for each of the values of theta and z 
% for each layer
for i = 1:str2num(N)
uicontrol('Style', 'text', 'String', num2str(i),...
'Position', [100*i-85 50 25 15],'foregroundcolor', [0 0 1]);
inp_theta(i) = uicontrol('Style', 'edit',...
'Position', [100*i-60 50 25 15],'foregroundcolor', [0 0 1]);

uicontrol('Style', 'text', 'String', num2str(i),...
'Position', [100*i-85 30 25 15], 'foregroundcolor', [0 0 1]);
inp_z(i) = uicontrol('Style', 'edit',...
'Position', [100*i-60 30 25 15], 'foregroundcolor', [0 0 1]);
endfor

endfunction

function Run_Values(hObject,eventdata)
%function Get_Values(h_run,eventdata)

global inp_N;
global inp_e1; global inp_e2;
global inp_mu12; global inp_mu21; 
global inp_g12;
global inp_theta; global my_theta;
global inp_z; global my_z;
global inp_Nx; global inp_Ny; global inp_Nxy;
global inp_Mx; global inp_My; global inp_Mxy;
global inp_X; global inp_Y; global inp_S; global inp_x;

% Gets the value of the parameter from GUI
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
X = get(inp_X,'String');
Y = get(inp_Y,'String');
S = get(inp_S,'String');
x = get(inp_x,'String');

% Puts the value of the parameter on the GUI.
if(e1 != " ")
  uicontrol('Style', 'text', 'String', num2str(e1),'Position', [120 470  40 20],'foregroundcolor',[0 1 0]);
else
  uicontrol('Style', 'text', 'String', "e1?",'Position', [120 470  40 20],'foregroundcolor',[1 0 0]);
endif

if(e2 != " ")
uicontrol('Style', 'text', 'String', num2str(e2),'Position', [170  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "e2?",'Position', [170  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(mu12 != " ")
uicontrol('Style', 'text', 'String', num2str(mu12),'Position', [220  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "mu12?",'Position', [220  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(mu21 != " ")
uicontrol('Style', 'text', 'String', num2str(mu21),'Position', [270 470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "mu21?",'Position', [270 470 40 20],'foregroundcolor',[1 0 0]);
endif
if(g12 != " ")
uicontrol('Style', 'text', 'String', num2str(g12),'Position', [320  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "g12?",'Position', [320  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(Nx != " ")
uicontrol('Style', 'text', 'String', num2str(Nx),'Position', [370  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "Nx?",'Position', [370  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(Ny != " ")
uicontrol('Style', 'text', 'String', num2str(Ny),'Position', [420  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "Ny?",'Position', [420  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(Nxy != " ")
uicontrol('Style', 'text', 'String', num2str(Nxy),'Position', [470  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "Nxy?",'Position', [470  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(Mx != " ")
uicontrol('Style', 'text', 'String', num2str(Mx),'Position', [520  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "Mx?",'Position', [520  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(My != " ")
uicontrol('Style', 'text', 'String', num2str(My),'Position', [570  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "My?",'Position', [570  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(Mxy != " ")
uicontrol('Style', 'text', 'String', num2str(Mxy),'Position', [620  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "Mxy?",'Position', [620  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(X != " ")
uicontrol('Style', 'text', 'String', num2str(X),'Position', [670  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "X?",'Position', [670  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(Y != " ")
uicontrol('Style', 'text', 'String', num2str(Y),'Position', [720  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "Y?",'Position', [720  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(S != " ")
uicontrol('Style', 'text', 'String', num2str(S),'Position', [770  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "S?",'Position', [770  470 40 20],'foregroundcolor',[1 0 0]);
endif
if(x != " ")
uicontrol('Style', 'text', 'String', num2str(x),'Position', [820  470 40 20],'foregroundcolor',[0 1 0]);
else
uicontrol('Style', 'text', 'String', "x?",'Position', [820  470 40 20],'foregroundcolor',[1 0 0]);
endif

N = get(inp_N,'String');

for i=1:str2num(N)
my_theta(i) = str2num(get(inp_theta(i),'String'));
my_z(i) = str2num(get(inp_z(i),'String'));
endfor

%Calling the function f_gui_tsai.m for giving the outputs to show in the GUI.
[Q, t1, t2, Q_g, A, B, D, E, F, G, H, tsai_hill, count] = f_gui_tsai(str2num(N), str2num(e1),...
 str2num(e2), str2num(g12), str2num(mu12), str2num(mu21),...
(my_theta), (my_z), str2num(Nx), str2num(Ny), str2num(Nxy),...
 str2num(Mx), str2num(My), str2num(Mxy),...
str2num(X), str2num(Y), str2num(S), str2num(x));

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

%Strain matrix
uicontrol('Style', 'text', 'String', num2str(F(1,1)), 'Position', [R+600 C+130 W H],'backgroundcolor',[1 1 1]);
uicontrol('Style', 'text', 'String', num2str(F(2,1)), 'Position', [R+600 C+110 W H],'backgroundcolor',[1 1 1]);
uicontrol('Style', 'text', 'String', num2str(F(3,1)), 'Position', [R+600 C+90 W H],'backgroundcolor',[1 1 1]);
uicontrol('Style', 'text', 'String', num2str(F(4,1)), 'Position', [R+600 C+70 W H],'backgroundcolor',[1 1 1]);
uicontrol('Style', 'text', 'String', num2str(F(5,1)), 'Position', [R+600 C+50 W H],'backgroundcolor',[1 1 1]);
uicontrol('Style', 'text', 'String', num2str(F(6,1)), 'Position', [R+600 C+30 W H],'backgroundcolor',[1 1 1]);
uicontrol('Style', 'text', 'String', "Strain = ", 'Position',[R+500 C+70 W-10 H],'backgroundcolor',[1 1 1],'foregroundcolor','green','fontsize',11);

uicontrol('Style', 'text', 'String', "Has the material failed?", 'Position', [R+500 C+600 W+150 H]);

%Tsai-hill property testing 
if(tsai_hill > 0 && tsai_hill < 1)
uicontrol('Style', 'text', 'String', "Material Safe", 'Position', [R+300 C+400 W+25 H+5],'foregroundcolor',[0 1 0],'fontsize',12);
s_fail = sprintf("None of the %d layers failed", str2num(N));
uicontrol('Style', 'text', 'String', s_fail, 'Position', [R+350 C+200 W+125 H],'foregroundcolor','green');
else
uicontrol('Style', 'text', 'String', "Material Failed", 'Position', [R+300 C+400 W+25 H+5],'foregroundcolor',[1 0 0],'fontsize',12);
q_fail = sprintf("%d of %d layers failed", count-1, str2num(N));
uicontrol('Style', 'text', 'String', q_fail, 'Position', [R+350 C+200 W+125 H],'foregroundcolor',[1 0 0]);
endif

endfunction
