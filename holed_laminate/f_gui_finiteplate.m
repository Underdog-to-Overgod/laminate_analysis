##
## ----------------------------------------
## Coded by Sumit Sunil Kumar (July 2019)
## Email: f20180029@goa.bits-pilani.ac.in
## ----------------------------------------
## The following function is the function from which, the outputs are taken
## when the user wants to find the stress concentration of a finite
## plate with a hole of suitable diameter and width in it and
## also calculate the stress concentration of an infinite plate.
## ----------------------------------------
## The following inputs are required:
## [a] The number of layers of the material (N)
## [b] The stresses of the corresponding layer (e1, e2, g12) 
## [c] The poisson ratios of the layer (mu12, mu21)
## [d] The fiber orientation angle (theta) and the distance of each layer from origin (z)
## -----------------------------------------
## It is implemented in the .m file gui_Ktinfi_Ktfini_sol.m
## which is a graphical user interface that uses it.
function[Q, t1, t2, Q_g, A, KTinfi, KT] = f_gui_finiteplate(N, e1, e2, g12, mu12, mu21, d, w, theta, z)



Q_g = zeros(3, 3, N);
for i = 1:N
 [Q, t1, t2, Q_g(:,:,i)] = global_stress(theta(i), e1, e2, g12, mu12, mu21);
endfor


b = d/w;
K = 3*(1-b)/(2 + (1-b)^3); 
bm2 = (1/2)*(sqrt(1 - 8*(K - 1)) - 1);

A = zeros(3,3);
sumation = zeros(3,3);


for i = 2:N
 num(:,:,i) = Q_g(:,:,i)*(z(i) - z(i-1));
 sumation = sumation + num(:,:,i);
endfor

A = sumation;

KTinfi = 1 + sqrt((2/A(2,2))*(((A(1,1)*A(2,2) - A(1,2)^2)/(2*A(3,3))) - A(1,2) + sqrt(A(1,1)*A(2,2))));
 
KT = KTinfi/(K + (1/2)*((bm2)^3)*(KTinfi - 3)*(1 - bm2));
