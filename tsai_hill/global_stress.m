##
## ----------------------------------------
## Coded by Sumit Sunil Kumar (July 2019)
## Email: f201800289@goa.bits-pilani.ac.in
## ---------------------------------------
## function [Q, t1, t2, Q_global] = global_stress(theta, e1, e2, g12, mu12, mu21)
## is the main code to compute the global stress of a material based on 
## [a] the  stresses (e1, e2, g12),
## [b] the poission ratios (mu12, mu21) and 
## [c] the fiber orientationangle (theta).
## ---------------------------------------
## And it gives output of the reduced stiffness matrix i.e. Q
## and the reduced stiffness matrix in global coordinates i.e Q_global
##

function [Q, t1, t2, Q_global] = global_stress(theta, e1, e2, g12, mu12, mu21)
%if less variables are entered by user
if(nargin != 6)
printf("Usage global_stress(theta, e1, e2, g12, mu12, mu21)\n");
return
endif

% Now we have the desired values from user
% We define the output
Q = zeros(3,3);
t1 = zeros(3,3);
t2 = zeros(3,3);

%define a constant ..
k = 1 - mu12*mu21;

m = cos(theta);
n = sin(theta);

% Based on book "Mechanics of Fibrous Composites"
%Q matrix
Q(1,1) = e1/k;
Q(1,2) = (mu12*e2)/k;
Q(2,1) = (mu21*e1)/k;
Q(2,2) = e2/k;
Q(3,3) = g12;
%t1 is the first transformation matrix
t1(1,1) = m^2;
t1(1,2) = n^2;
t1(1,3) = 2*m*n;
t1(2,1) = t1(1,2);
t1(2,2) = t1(1,1);
t1(2,3) = -1*t1(1,3);
t1(3,1) = -m*n;
t1(3,2) = -1*t1(3,1);
t1(3,3) = t1(1,1) - t1(1,2);

%t2 is the second transformation matrix
t2 = t1;

t2(1,3) = t1(3,2);
t2(2,3) = -1*t2(3,2);
t2(3,1) = -1*t1(1,3);
t2(3,2) = -1*t2(3,1);
%By formula
Q_global = inv(t1)*Q*t2;

return
