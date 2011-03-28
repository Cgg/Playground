% InvertedPendulum.m
%
% Simulate an inverted pendulum on a cart.
%
% More on the underlying physic stuff here :
% http://membres.multimania.fr/lebrunpascal/memoire.html#II.1.LE%20PENDULE%20INVERSE
%
% Input arguments :
% ---------------
% - l    : pendulum's length
% - m    : pendulum's weight
% - M    : cart's weight
% - f    : dynamic "rub coefficient"
% - dt   : temporal resolution
% - Tmax : max. simulation's duration
%
% Output : n x 7 matrix
% ------
% Where n is the number of steps of simulation (maximum T/dt)
% Columns' layout : 
% t | x | speed | acc. | angle | ang. speed | ang. acc.
%
% Simulation's length :
% -------------------
% The sim lasts until either one of the following conditions is satisfied :
% - all speeds and accelerations are null
% - simulation's length becomes greater than T (cf. input args)

function [ T, x, sp, ac, a, asp, aac ] = InvertedPendulum( l, m, M, f, dt, TMax )

end
