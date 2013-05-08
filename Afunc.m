function [A1, A2] = Afunc(m, theta)

A1 = (1 - m*exp(2*i*theta))./(sqrt(1 - 2*m*cos(2*theta) + m^2));
A2 = (exp(i*theta) + m*exp(-i*theta))./(1 - m*exp(2*i*theta));
