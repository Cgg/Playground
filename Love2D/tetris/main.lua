--[[
Un tetris simple.

Le carré élémentaire fait 10 px de côté.

L'aire de jeux fait 10 carrés de côté (=100 px) et 20 de haut (=200 px)

--]]

function createPiece( X_i, Y_i )
  --[[
  create a RANDOM piece with center being at X_i, Y_i (grid coordinates)
  organisation d'une table de données "pièce" :
   - trois champs r, g, b pour la couleur de la pièce
   - les "grid coordinates d'un carré de la pièce
   - un tableau 3x2 stockant les grid coordinates des trois autres carrés
  --]]
  
  local P = {}

  P.r = 0
  P.g = 0
  P.b = 0

  P.X = X_i
  P.Y = Y_i

  P.S = {}

  for i = 0, 2 do
    P.S[i] = {}
  end

  -- TODO generate a random piece

  -- this is for the T piece
  P.r = 255

  P.S[0].X = -1
  P.S[0].Y = 0

  P.S[1].X = 1
  P.S[1].Y = 0

  P.S[2].X = 0
  P.S[2].Y = 1

  -- this is for S
  -- this is for SInv
  -- this is for L
  -- this is for LInv
  -- this is for I
  -- this is for O (the square)
  -- this is for the one I forgot

  return P
end

function love.load()
  -- graphics constants

  -- window's width and height
  WW = 640
  WH = 400

  -- elementary square width
  SQW = 15

  -- playfield width and height in squares 
  PFW = 10
  PFH = 20

  -- playfield's top left corner position
  PF_X = 20
  PF_Y = 20

  -- game variables
  nextPiece    = createPiece( PFW + 2, 0 )
  currentPiece = createPiece( math.ceil( PFW/2 ), 0 )  

  heap = {}

  for i = 0, PFW-1 do
    heap[i] = {}
    for j = 0, PFH-1 do
      heap[i][j] = -1
    end
  end

  g_level   = 1
  g_n_lines = 0
  g_score   = 0
  
  g_Vinv = 1   -- inverse of fall speed (seconds per block )
  g_dt_acc = 0 -- to know when to make the current piece go down
  g_slip   = 0 -- pour laisser la piece "glisser" lorsqu'elle ne peut pas
               -- descendre

  -- love init calls
  love.graphics.setMode( WW, WH )
end

function drawFrame()
  -- draw the game fram : grid, window for the next piece, window for the
  -- score, etc.

  love.graphics.setColor( 255, 255, 255 )

  -- +/- 1 : draw the external border of the playing field
  
  love.graphics.rectangle( "fill",
                           PF_X - 1,
                           PF_Y - 1, 
                           ( PFW * SQW ) + 2,
                           ( PFH * SQW ) + 2 )
end

function drawElementarySquare( X, Y, r, g, b )
  -- draw an elementary square (squares composing the pieces) at a given
  -- position. The position is given in grid coordinates!
  -- hence the CONTRACT : X and Y are integers.

  love.graphics.setColor( r, g, b )

  local X1 = PF_X + ( X * SQW )
  local Y1 = PF_Y + ( Y * SQW )

  love.graphics.rectangle( "fill", X1, Y1, SQW, SQW )
end

function drawPiece( P )

  drawElementarySquare( P.X, P.Y, P.r, P.g, P.b )

  for i = 0, 2 do
    drawElementarySquare( P.X + P.S[i].X, P.Y + P.S[i].Y, P.r, P.g, P.b )
  end
end

function drawHeap()
  for i = 0, PFW-1 do
    for j = 0, PFH-1 do
      
      if heap[i][j] ~= -1 then -- TODO plutot tester si le type de l'entrée est une table
        local S = heap[i][j]
        drawElementarySquare( i, j, S.r, S.g, S.b )
      end
    end
  end

end

function currentPieceGoDown()
  --[[
  do minus 1 on current piece's Y

  check if it intersects with the heap

  if so 
    restore current piece's Y
    if g_slip < 3 
      g_slip += 1
    else
      la piece est maintenant bien tombée/collée
      updateHeap
  if not
    g_slip = 0
  --]]
end

function IntersectHeapAndPiece( P )
  -- check if current piece and heap are overlapping
  local X_a = P.X
  local Y_a = P.Y

  --[[ pour chaque carré C de P faire
        si C.Y == PF_H - 1 retourner vrai
        si heap[C.X][C.Y] ~= -1 retourner vrai
  --]]

  return false;
end

function love.update( dt )

  if g_dt_acc >= g_Vinv then

    currentPieceGoDown()

    g_dt_acc = g_dt_acc - g_Vinv

  else
    g_dt_acc = g_dt_acc + dt
  end

end

function love.draw()
  r, g, b, a = love.graphics.getColor()

  drawFrame()

  drawPiece( nextPiece )
  drawPiece( currentPiece )

  drawHeap()

  love.graphics.setColor( r, g, b, a )
end
