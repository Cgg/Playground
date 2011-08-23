function love.load()
  love.graphics.setMode( 640, 480 )
  love.graphics.setBackgroundColor( 255, 255, 255 )
  fps = 0
end

function love.update( dt )
  fps = 1 / dt

  -- update shadow layer

end

function love.draw()
  -- printing fps in the upper left corner
  love.graphics.print( math.ceil(fps), 5, 5 )

  -- saving previous color mode
  r, g, b, a = love.graphics.getColor()

  -- let's draw a RED rectangle. YAY.
  love.graphics.setColor( 255, 0, 0 )
  love.graphics.rectangle( "fill", 342, 120, 55, 70 )

  -- let's draw a BLUE rectangle. YATTA.
  love.graphics.setColor( 0, 0, 255 )
  love.graphics.rectangle( "fill", 360, 100, 30, 30 )

  dropShadow()

  -- restoring color
  love.graphics.setColor( r, g, b, a )
end

function love.keypressed( key, unicode )
  if key == "escape" then
    love.event.push( "q" )
  end
end

function dropShadow()
  -- this function takes a 2D array representing the drawing area, with one
  -- entry per pixel. Each entry is within 0 and 1. Each pixel is filled
  -- with black with according alpha level (scaled to 0-255)

  -- no shadow at all for now
  r, g, b, a = love.graphics.getColor()

  love.graphics.setColor( 255, 0, 0, 1000 )
  love.graphics.rectangle( "fill", 0, 0, 640, 480 )

  love.graphics.setColor( r, g, b, a )
end
