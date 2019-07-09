%this is for getting a plot of Qbar against the value of theta which is the fiber orientation
function qg_plot(e1, e2, g12, mu12, mu21)
  
%if less variables are entered by user
if(nargin != 5)
printf("<=====================>\nUsage qg_plot(e1, e2, g12, mu12, mu21)\n===\n");
printf("e1 = axial modulus\n");
printf("e2 = transverse moduli\n");
printf("g12 = shear modulus\n");
printf("mu12 = poisson ratio\n");
printf("mu21 = poisson ratio\n");
printf("<======================>\n");
return
endif

%I have taken only a few points for convenience. We can also make the process continous
%like theta = linspace(1:100:0.5);  
theta = [1.2, 2.3, 3.4, 4.5, 5.6, 6.7, 7.8, 8.9, 9.1];
N = length(theta);
ltheta = theta*180/pi;

Qg = zeros(N,3,3);

%calling the function global_stress.m that calculates Q_g wrt theta
for i = 1:N
 [Q, T1, T2, Qg(i,:,:)] = global_stress(theta(i), e1, e2, g12, mu12, mu21);
endfor

plot(ltheta,Qg(:,1,1),'rx-', ltheta, Qg(:,1,2), 'b*-', ltheta, Qg(:,2,1), ltheta, Qg(:,2,2), ltheta, Qg(:,3,3))

%some details
details_str = sprintf("e1=%.2f, e2=%.2f, g12=%.2f, mu12=%.2f, mu21=%.2f",e1, e2, g12, mu12, mu21);

title(details_str);
%labels
xlabel("Theta in Deg");

%legend
legend("Qg11", "Qg12", "Qg21", "Qg22", "Qg66");
