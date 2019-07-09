%this is for calculating the stress of a layered laminate
%code is same as strain but with stress.
%PLEASE REFER TO THE CODE OF globalstrain.m FOR KNOWING WHY THE CODE IS SO
function[Q, t1, t2, Q_g, A, B, D, E, strain, glob_strn, stress] = stress(N, e1, e2, g12, mu12, mu21)

if(nargin != 6)
printf("Usage inputs are straincalc2(N, e1, e2, g12, mu12, mu21)\n");
return;
endif


N = input("Select number of layers: ");
theta = zeros(1, N);
z = zeros(1, N);

for i = 1:N
	printf('Enter the angle of the %d layer', i); 
	theta(i) = input(" (in theta): ");
	printf('Enter the distance from the base for %d layer', i);
	z(i) = input(" (in units): ");
endfor
 
 
 printf('enter the value of Nx');
 Nx = input(" (in units) ");
 printf('enter the value of Ny');
 Ny = input(" (in units) ");
 printf('enter the value of Nxy');
 Nxy = input(" (in units) ");
 printf('enter the value of Mx');
 Mx = input(" (in units) ");
 printf('enter the value of My');
 My = input(" (in units) ");
 printf('enter the value of Mxy');
 Mxy = input(" (in units) ");
 printf('enter the value of x');
 x = input(" (the distance from the mid-plane) ");

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


for i = 1:3
glob_strn(i,1) = strain(i,1) + x*strain(i+3,1);
endfor
%stress
for j = 1:N 
 	stress(:,1,j) = Q_g(:,:,j)*glob_strn();   
end
