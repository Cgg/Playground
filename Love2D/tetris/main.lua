-- airplane fact : les arc-en-ciel circulaires c'est COOL. Avec trois
-- anneaux !

--[[
Un tetris simple.

Le carré élémentaire fait 10 px de côté.

L'aire de jeux fait 10 carrés de côté (=100 px) et 20 de haut (=200 px)

--]]

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

  -- slipping margin
  MAX_SLIP = 1

  -- for the score
  -- amount of points you get for putting a piece down
  SC_PIECE_DOWN = 5 
  -- for a line. Use exponential when dealing with multiple lines
  SC_LINE       = 20

  -- amount of lines after which the level gets increased
  LV_DELTA_LINES = 100

  -- game variables
  nextPiece    = createPiece( PFW + 2, 0 )
  currentPiece = createPiece( math.floor( PFW/2 ), 0 )  

  -- the heap is ordered following the X and Y axis
  heap = {}

  for y = 0, PFH-1 do
    heap[y] = {}
    for x = 0, PFW-1 do
      heap[y][x] = -1
    end
  end

  g_start_level = 5
  g_level       = g_start_level
  g_n_lines     = 0
  g_score       = 0
  
  g_Vinv   = 1 / ( 1 + ( g_start_level / 4 ) )   -- inverse of fall speed (seconds per block )
  g_dt_acc = 0 -- to know when to make the current piece go down
  g_slip   = 0 -- pour laisser la piece "glisser" lorsqu'elle ne peut pas
               -- descendre
  g_paused = false

  g_perdu  = false

  -- init random numbers generator
  math.randomseed( os.time() )

  -- love init calls
  love.graphics.setMode( WW, WH )
  love.graphics.setCaption( "Tetris" )
end


function createPiece( X_i, Y_i )
  --[[
  create a RANDOM piece with center being at X_i, Y_i (grid coordinates)
  organisation d'une table de données "pièce" :
   - trois champs r, g, b pour la couleur de la pièce
   - les "grid coordinates d'un carré de la pièce
   - un tableau 3x2 stockant les grid coordinates des trois autres carrés
  --]]
  
  local piece_type = math.random( 0, 6 )

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

  if piece_type == 0 then
    -- this is for the T piece
    P.r = 255

    P.S[0].X = -1
    P.S[0].Y = 0

    P.S[1].X = 1
    P.S[1].Y = 0

    P.S[2].X = 0
    P.S[2].Y = 1

  elseif piece_type == 1 then
  -- this is for S
    P.r = 255
    P.g = 0
    P.b = 208

    P.S[0].X = 0
    P.S[0].Y = -1

    P.S[1].X = 1
    P.S[1].Y = 0

    P.S[2].X = 1
    P.S[2].Y = 1

  elseif piece_type == 2 then
  -- this is for SInv
    P.r = 21
    P.g = 0
    P.b = 255

    P.S[0].X = 0
    P.S[0].Y = -1

    P.S[1].X = -1
    P.S[1].Y = 0

    P.S[2].X = -1
    P.S[2].Y = 1

  elseif piece_type == 3 then
  -- this is for L
    P.r = 0
    P.g = 255
    P.b = 251

    P.S[0].X = 1
    P.S[0].Y = 0

    P.S[1].X = 2
    P.S[1].Y = 0

    P.S[2].X = 0
    P.S[2].Y = 1

  elseif piece_type == 4 then
  -- this is for LInv
    P.r = 0
    P.g = 255
    P.b = 0

    P.S[0].X = -1
    P.S[0].Y = 0

    P.S[1].X = -2
    P.S[1].Y = 0

    P.S[2].X = 0
    P.S[2].Y = 1

  elseif piece_type == 5 then
    -- this is for I
    P.r = 200
    P.g = 0
    P.b = 255

    P.S[0].X = -1
    P.S[0].Y = 0

    P.S[1].X = 1
    P.S[1].Y = 0

    P.S[2].X = 2
    P.S[2].Y = 0

  elseif piece_type == 6 then
    -- this is for O (the square)
    P.r = 255
    P.g = 0
    P.b = 125

    P.S[0].X = 1
    P.S[0].Y = 0

    P.S[1].X = 0
    P.S[1].Y = 1

    P.S[2].X = 1
    P.S[2].Y = 1
  end

  -- this is for the one I forgot

  return P
end


function CopyPiece( CP )
  local P = {}

  P.X = CP.X
  P.Y = CP.Y
  
  P.r = CP.r
  P.g = CP.g
  P.b = CP.b

  P.S = {}

  for i = 0, 2 do
    P.S[i] = {}

    P.S[i].X = CP.S[i].X
    P.S[i].Y = CP.S[i].Y
  end

  return P
end


function GetAbsolutSquares( P )
  -- return the list of a piece's squares absolut coordinates

  local L = {}

  L[0] = {}

  L[0].X = P.X
  L[0].Y = P.Y

  for i = 0, 2 do
    L[ i+1 ] = {}

    L[ i+1 ].X = P.X + P.S[i].X
    L[ i+1 ].Y = P.Y + P.S[i].Y
  end

  return L
end


function drawFrame()
  -- draw the game frame : grid, window for the next piece, window for the
  -- score, etc.

  love.graphics.setColor( 255, 255, 255 )

  -- -1/+2 : add 1 px border to the playing field rectangle
  
  love.graphics.rectangle( "fill",
                           PF_X - 1,
                           PF_Y - 1, 
                           ( PFW * SQW ) + 2,
                           ( PFH * SQW ) + 2 )
end


function drawInfo()
  -- draw informations : score, number of lines and level
  love.graphics.setColor( 255, 255, 255 )

  love.graphics.print( "Score : " .. g_score, 5 + PF_X + ( PFW * SQW ), PF_Y + (( PFH - 3 ) * SQW) )
  love.graphics.print( "Lines : " .. g_n_lines, 5 + PF_X + ( PFW * SQW ), PF_Y + (( PFH - 2 ) * SQW) )
  love.graphics.print( "Level : " .. g_level, 5 + PF_X + ( PFW * SQW ), PF_Y + (( PFH - 1 ) * SQW) )
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
  local squares = GetAbsolutSquares( P )

  for i = 0, 3 do
    drawElementarySquare( squares[i].X, squares[i].Y, P.r, P.g, P.b )
  end
end


function drawHeap()
  for y = 0, PFH-1 do
    for x = 0, PFW-1 do
      
      if type(heap[y][x]) == "table" then
        local S = heap[y][x]
        drawElementarySquare( x, y, S.r, S.g, S.b )
      end
    end
  end
end


function MoveCurrentPiece( mvmt )
  local candidatePiece = CopyPiece( currentPiece )

  if     mvmt == "left" then
    candidatePiece.X = candidatePiece.X - 1
  elseif mvmt == "right" then
    candidatePiece.X = candidatePiece.X + 1
  elseif mvmt == "up" then -- rotate right
    RotatePiece( candidatePiece )
  end

  if not IsOutOfPlayinGField( candidatePiece ) and 
     not IntersectHeapAndPiece( candidatePiece ) then

     currentPiece = candidatePiece
  end
end


function RotatePiece( P )

  -- apply a rotation matrix to coordinates of P's squares
  local X_old
  local Y_old

  for i = 0, 2 do
    X_old = P.S[i].X
    Y_old = P.S[i].Y

    P.S[i].X = - Y_old
    P.S[i].Y = X_old
  end
end


function CurrentPieceGoDown()
  -- return TRUE if the piece was able to move of slip and FALSE otherwise
  -- do plus 1 on current piece's Y
  currentPiece.Y = currentPiece.Y + 1

  -- check if it intersects with the heap
  if IntersectHeapAndPiece( currentPiece ) then
    --restore current piece's Y
    currentPiece.Y = currentPiece.Y - 1

    -- can the piece still slip ?
    if g_slip < MAX_SLIP then
      g_slip = g_slip + 1
    else
      -- now the piece is stuck for good
      g_slip = 0

      UpdateHeap()

      return false
    end
  -- no ELSE statement. If the current piece doesn't intersect with the
  -- heap we leave it there.
  end

  return true
end


function IsOutOfPlayinGField( P )
  squares = GetAbsolutSquares( P )

  for i = 0,3 do
    if squares[i].X < 0 or squares[i].X > ( PFW - 1 ) or squares[i].Y < 0
    then
      return true
    end
  end

  return false
end


function IntersectHeapAndPiece( P )
  -- check if current piece and heap are overlapping
  local squares = GetAbsolutSquares( P )

  for i = 0, 3 do
    if squares[i].Y > ( PFH - 1 ) then return true
    end

    if type(heap[ squares[i].Y ][ squares[i].X ]) == "table" then return true
    end
  end

  return false
end


function UpdateHeap()
  local squares = GetAbsolutSquares( currentPiece )

  local deltaScore = SC_PIECE_DOWN -- you get at last this for bringing a
                                   -- piece down
  local deltaLines = 0

  for i = 0, 3 do
    heap[ squares[i].Y ][ squares[i].X ] = {}

    heap[ squares[i].Y ][ squares[i].X ].r = currentPiece.r
    heap[ squares[i].Y ][ squares[i].X ].g = currentPiece.g
    heap[ squares[i].Y ][ squares[i].X ].b = currentPiece.b
  end

  deltaLines = TakeOffCompleteLines()

  -- current piece = next piece
  currentPiece   = CopyPiece( nextPiece )
  currentPiece.X = math.floor( PFW/2 )
  currentPiece.Y = 0

  -- generate new next piece
  nextPiece = createPiece( PFW + 2, 0 )

  -- update the score and shit
  g_score   = g_score + deltaScore
  g_n_lines = g_n_lines + deltaLines
  g_level   = math.floor( g_n_lines / LV_DELTA_LINES ) + g_start_level

  g_Vinv = 1 / ( 1 + ( g_level / 4 ) )
end


function TakeOffCompleteLines()
  local totalCompleteLines = 0

  local ncl = 0 -- number of complete lines

  for l = 0, (PFH - 1) do
    if IsLineComplete( l ) then
      ncl = ncl + 1

    elseif ncl > 0 then

      totalCompleteLines = totalCompleteLines + ncl

      for y = (l-ncl-1), 0, -1 do
        heap[ y + ncl ] = heap[ y ]
      end

      for y = 0, (ncl - 1) do
        heap[y] = {}
        for x = 0, (PFW - 1) do
          heap[y][x] = -1
        end
      end

      ncl = 0
    end
  end

  -- take care of the bottom lines
  if ncl > 0 then

    totalCompleteLines = totalCompleteLines + ncl

    for y = (PFH-1-ncl), 0, -1 do
      heap[ y + ncl ] = heap[y]
    end

    for y = 0, (ncl - 1) do
      heap[y] = {}
      for x = 0, (PFW - 1) do
        heap[y][x] = -1
      end
    end

    ncl = 0
  end

  return totalCompleteLines
end


function IsLineComplete( l )
  for x = 0, (PFW - 1) do
    if type( heap[ l ][ x ] ) ~= "table" then
      return false
    end
  end

  return true
end


function love.update( dt )

  if not g_perdu then
    if g_dt_acc >= g_Vinv then

      CurrentPieceGoDown()

      g_dt_acc = g_dt_acc - g_Vinv

    else
      g_dt_acc = g_dt_acc + dt
    end
  end
end


function love.keypressed( key, unicode )
  if not g_perdu then
    if key == "down" then
      CurrentPieceGoDown()
    elseif key == "left" or key =="right" or key == "up" then
      MoveCurrentPiece( key )
    elseif key == " " then
      while CurrentPieceGoDown() do end
    elseif key == "p" then
      g_paused = not g_paused
    elseif key == "escape" or key == "q" then -- quit
      love.event.push( "q" )
    end
  end
end

function love.draw()
  r, g, b, a = love.graphics.getColor()

  drawFrame()

  drawInfo()

  drawPiece( nextPiece )
  drawPiece( currentPiece )

  drawHeap()

  if g_perdu then
    love.graphics.setColor( 255, 255, 255 )
    love.graphics.print( "You lose with a score of " .. g_score .. " !", PF_X + PFW*SQW, PF_Y + (PFH/2)*SQW )
  end

  love.graphics.setColor( r, g, b, a )
end
