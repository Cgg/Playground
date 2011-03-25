% Implementation de la methode de Runge-Kutta, pour voir

function Resultat=RK4(F,P0,N,XFin)

% Où :
% - F est la fonction à intégrer (tq dy/dx = F(x,y) )
% - P0 est la matrice (1,2) définissant le point de départ de la méthode
% - N est le nombre d'itérations
% - XFin est l'abscisse où s'arrête la méthode
%
% le pas utilisé est obtenu via (XFin - X0)/N
%
% Resultat est retourné sous la forme d'une matrice à n+1 lignes et deux
% colonnes :
%
% x0 | y0
% x1 | y1
%   ...
% xn | yn

Pas = ( XFin - P0( 1, 2 ) ) / N;

% Initialisation du vecteur-résultat.
Resultat = zeros( n + 1, 2 );

Resultat( 1, : ) = P0;

% Initialisation de la matrice stockant les coef k1, k2, k3, k4
k = zeros( 1, 4 );

% Initialisation de la matrice stockant le point courant
X = zeros( 1, 2 );


for i = 2..( N + 1 )

    % Calcul de l'abscisse du point suivant
    Resultat( i , 1 ) = Resultat( 1, 1 ) + ( ( i - 1 ) * Pas );

    X = Resultat( i - 1, : );

    % Calcul des coefficients k1, k2, k3, k4
    k( 1 ) = Pas * X * F;
    
    X( 1 ) = X( 1 ) + ( Pas / 2 );
    X( 2 ) = X( 2 ) + ( k( 1 ) / 2 );

    k( 2 ) = Pas * X * F;

    X( 1 ) = X( 1 ) + ( Pas / 2 );
    X( 2 ) = X( 2 ) + ( k( 2 ) / 2 );
        
end
