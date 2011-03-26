% Implementation de la methode d'Euler, pour comparaison avec Runge-Kotta
% d'ordre 4

function Resultat=Euler(P0,N,XFin)

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
Resultat = zeros( N + 1, 2 );

Resultat( 1, : ) = P0;

% Point courant
Xi=zeros( 1, 1 );
Yi=zeros( 1, 1 );

for i = 2:1:( N + 1 )

    % Calcul de l'abscisse du point suivant
    Resultat( i , 1 ) = Resultat( 1, 1 ) + ( ( i - 1 ) * Pas );

    Xi = Resultat( i, 1 );
    Yi = Resultat( i, 2 );

    Resultat( i, 2 ) = Resultat( ( i - 1 ), 2 ) + ( Pas * F( Xi, Yi ) );
end
