##
## ----------------------------------------
## Coded by Sumit Sunil Kumar (July 2019)
## Email: f20180029@goa.bits-pilani.ac.in
## ----------------------------------------
## This is the function that has to be called to get the output to the GUI prepared. 
## It is used to give the gui for the calculation of the stiffness
## matrices of a layered composite as well as the inverse of the 6 by 6
## matrix formed with A,B,D matrices. It also gives the code for strain.
## This is implemented in the .m file named gui_temporary_sol.m
## ----------------------------------------
## The following inputs are required:
## [a] The number of layers of the material (N)
## [b] The stresses of the corresponding layer (e1, e2, g12) 
## [c] The poisson ratios of the layer (mu12, mu21)
## [d] The fiber orientation angle (theta) and the distance of each layer from origin (z)
## [e] The forces and moments of the layer (Nx, Ny, Nxy, Mx, My, Mxy)
## -----------------------------------------

function[Q, t1, t2, Q_g, A, B, D, E, F] = f_gui_straincalc(N, e1, e2, g12, mu12, mu21, theta, z, Nx, Ny, Nxy, Mx, My, Mxy)


 
%Nx = 11;
% Ny = 13; 
% Nxy = 15;
% Mx = 17;
% My = 18;
% Mxy = 34;
 
% printf('enter the value of Nx');
% Nx = input(" (in units) ");
% printf('enter the value of Ny');
% Ny = input(" (in units) ");
% printf('enter the value of Nxy');
% Nxy = input(" (in units) ");
% printf('enter the value of Mx');
% Mx = input(" (in units) ");
% printf('enter the value of My');
% My = input(" (in units) ");
% printf('enter the value of Mxy');
% Mxy = input(" (in units) ");

 norm_moment = [Nx; Ny; Nxy; Mx; My; Mxy];

Q_g = zeros(3, 3, N);
for i = 1:N
 [Q, t1, t2, Q_g(:,:,i)] = global_stress(theta(i), e1, e2, g12, mu12, mu21);
endfor

Q_g

A = zeros(3,3);
B = zeros(3,3);
D = zeros(3,3);
sumation1 = zeros(3,3);
sumation2 = zeros(3,3);
sumation3 = zeros(3,3);
Z = zeros(6,6);
E = zeros(6,6);


for i = 2:N
num1 = Q_g(:,:,i)*(z(i) - z(i-1));
sumation1 = sumation1 + num1;
endfor

A = sumation1;

for i = 2:N
num2 = Q_g(:,:,i)*((z(i))^2 - (z(i-1))^2)*(1/2);
sumation2 = sumation2 + num2;
endfor

B = sumation2;

for i = 2:N
num3 = Q_g(:,:,i)*((z(i))^3 - (z(i-1))^3)*(1/3);
sumation3 = sumation3 + num3;
endfor

D = sumation3;

strain = zeros(6,1);
Z = [A, B; B, D];
E = inv(Z);
 
for i = 1:6
strain(i,1) = E(i,1)*Nx + E(i,2)*Ny + E(i,3)*Nxy + E(i,4)*Mx + E(i,5)*My + E(i,6)*Mxy;
endfor

F = strain



