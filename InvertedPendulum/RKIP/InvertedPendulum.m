% InvertedPendulum.m
%
% Simulate an inverted pendulum on a cart.
%
% More on the underlying physic stuff here :
% http://membres.multimania.fr/lebrunpascal/memoire.html#II.1.LE%20PENDULE%20INVERSE
%
% Input arguments :
% ---------------
% - iA   : initial value for pendulum's angle
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

function [ T, x, sp, ac, a, asp, aac ] = InvertedPendulum( iA, l, m, M, f, dt, TMax )

% tolerance over stop condition. Should be input arg.
eps = 1e-3;

nStep = TMax / dt;

T   = zeros( nStep, 1 );
x   = zeros( nStep, 1 );
sp  = zeros( nStep, 1 );
ac  = zeros( nStep, 1 );
a   = zeros( nStep, 1 );
asp = zeros( nStep, 1 );
aac = zeros( nStep, 1 );

a( 1 ) = iA;

% Runge-Kutta methode is used 4 times here.
kSp  = zeros( 4, 1 );
kAc  = zeros( 4, 1 );
kASp = zeros( 4, 1 );
kAAc = zeros( 4, 1 );

i = 2;

runningPendulum = 1;

% Computing results
% i refers to the currently computed position/speed/angle/etc.
% ( i - 1 ) refers to the previous one
while( ( i < nStep ) & ( runningPendulum == 1 ) )



    % Checking the other stop condition
    if( abs( sp( i ) ) <= eps &
        abs( ac( i ) ) <= eps &
        abs( asp( i ) ) <= eps &
        abs( aac( i ) ) <= eps )

        runningPendulum = 0;
    end
end

end
