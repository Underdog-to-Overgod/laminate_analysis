##
## ----------------------------------------
## Coded by Sumit Sunil Kumar (July 2019)
## Email: f201800289@goa.bits-pilani.ac.in
## ----------------------------------------
## This is the function that has to be called to get the output to the GUI prepared 
## for testing whether a layered laminate has failed or is safe by the tsai-hill criteria.
## It's outputs are used in the .m file labeled as gui_tsai_hill.m
## ----------------------------------------
## The function takes into consideration the inputs that are:
## [a] The number of layers of the material (N)
## [b] The stresses of the corresponding layer (e1, e2, g12) 
## [c] The poisson ratios of the layer (mu12, mu21)
## [d] The fiber orientation angle (theta) and the distance of each layer from origin (z)
## [e] The forces and moments of the layer (Nx, Ny, Nxy, Mx, My, Mxy)
## [f] The material strengths in the X, Y and shear direction (X, Y, S)
## [g] The mid-plane axis distance (x)
## ----------------------------------------
## The outputs that come are in the GUI
## [1] The 3 stiffness matrices of layers A, B, D.
## [2] The strain 6 by 1 matrix.
## [3] Whether the material has failed by tsai-hill property or not.
## [4] If the material has failed then how many layers have failed.
function[Q, t1, t2, Q_g, A, B, D, E, strain, glob_strn, stress,  tsai_hill, global_failure] = f_gui_tsai(N, e1, e2, g12, mu12, mu21, theta , z, Nx, Ny, Nxy, Mx, My, Mxy, X, Y, S, x)

norm_moment = [Nx; Ny; Nxy; Mx; My; Mxy];

Q_g = zeros(3, 3, N);
for i = 1:N
 [Q, t1, t2, Q_g(:,:,i)] = global_stress(theta(i), e1, e2, g12, mu12, mu21);
endfor

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
glob_strn = zeros(3,1);
stress = zeros(3,1,N);

Z = [A, B; B, D];
E = inv(Z);
 
for i = 1:6
 strain(i,1) = E(i,1)*Nx + E(i,2)*Ny + E(i,3)*Nxy + E(i,4)*Mx + E(i,5)*My + E(i,6)*Mxy;
endfor 

F = strain;
for i = 1:3
 glob_strn(i,1) = strain(i,1) + x*strain(i+3,1);
endfor

G = glob_strn;
for j = 1:N 
 	stress(:,:,j) = Q_g(:,:,j)*glob_strn;   
end

%tsai-hill criteria
tsai_hill = zeros(1,1,N);
failure_flag = zeros(1,N);
global_failure = 0;

T = zeros(N,1);

for i = 1:N
 ct = cos(theta(i));
 st = sin(theta(i));
 tsai_hill(1,1,i) = (stress(1,1,i)^2)*(ct^4/X^2 + (1/S^2 - 1/X^2)*(st*ct)^2 + st^4/Y^2);
endfor

for i = 1:N
 if(tsai_hill(1,1,i) > 0 & tsai_hill(1,1,i) < 1)
	%printf("(%f) the materials %d layer has not failed\n", tsai_hill(1,1,i),i);
  	failure_flag(1,i) = 1;	
 else
	%printf("(%f) the material has failed\n", tsai_hill(1,1,i));
	  global_failure = global_failure+1;
 endif
endfor
