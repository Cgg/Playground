// TODO deactivate mouse interactions when the ball is moving

/* FooPool
 *
 * A kind of pool simulation in JavaScript. Quite basic for now:
 * - the field is the canvas (same coordinate system)
 * - the user can give direct impulse to the ball only (no spin)
 * - basic bouncing behaviour against the edges
 * - only one ball
 * - no fancy visual effects
 */

/* Some guidelines I try to stick with :
 * 
 * - variables declarations are sorted between the different objects (ball,
 * field, ...) and the variable name is prefixed accordingly
 * - local variables may not use prefixes
 * - after the prefix I use camel case for the variables and underscore
 * separated uppercase for the constants
 * - if a variable is a constant its name is in uppercase (not the prefix)
 */

init = function()
{
  /* Wonderful html world */
  h_canvas = document.getElementById( "mainCanvas" )

  /* game variables */
  g_F_SCALE  = 8;    // scaling factor applied to the graphic vector to get
                     // force applied to the ball
  g_dtDraw   = 33;
  g_dtUpdate = 33;

  /* Field */
  f_W = h_canvas.width
  f_H = h_canvas.height
  f_F = 0.2;             // friction factor of the field

  /* Balls of steel */
  b_C_FR  = "rgb( 255, 94, 94 )";   // ball's color if not clicked
  b_C_CLK = "rgb( 121, 125, 242 )"; // ball's color if clicked
  b_C_HVR = "rgb( 150, 255, 150 )"; // ball's hover zone color
  b_R     = 10;      // ball's radius
  b_R_SP  = 40;      // radius for the "spin zone"
  b_WGT   = 0.21;    // ball's weight (in kg)
  b_x     = f_W / 2; // position
  b_y     = f_H / 2;
  b_sx    = 0;       // speed
  b_sy    = 0;
  b_ax    = 0;       // acceleration
  b_ay    = 0;
  b_click = false;   // b_click : the user clicked on the ball
  b_hover = false;   // b_hover : the mouse is hover the ball
  b_pClic = { X : 0, Y : 0 }; // point from where the user start to click
  b_force = { X : 0, Y : 0 }; // vertice of force applied to the ball

  h_canvas.addEventListener( "mousedown", onMouseDown, false );
  h_canvas.addEventListener( "mouseup"  , onMouseUp  , false );
  h_canvas.addEventListener( "mousemove", onMouseMove, false );

  setInterval( "draw()", g_dtDraw );
  setInterval( "update( g_dtUpdate / 1000 )", g_dtUpdate );
}


/* mouse events handlers */
onMouseDown = function( evt )
{
  var cursorPostion = getCursorPos( evt );

  // check if we are in the clickable zone
  if( Math.sqrt( Math.pow( b_x - cursorPostion.X, 2 ) +
                 Math.pow( b_y - cursorPostion.Y, 2 )   ) <= b_R_SP )
  {
    b_click = true;

    // if we are somewhere in the ball we stick the start point to the
    // middle of the ball
    if( Math.sqrt( Math.pow( b_x - cursorPostion.X, 2 ) +
                   Math.pow( b_y - cursorPostion.Y, 2 )   ) <= b_R )
    {
      b_pClic.X = b_x;
      b_pClic.Y = b_y;
    }
    else
    {
      b_pClic.X = cursorPostion.X;
      b_pClic.Y = cursorPostion.Y;
    }

    b_force.X = 0;
    b_force.Y = 0;
  }
}

onMouseUp = function( evt )
{
  b_click = false;
  b_hover = false;

  // then compute the norm of segment from mousedown point to here and
  // apply corresponding force to the ball

  var force = { X : b_force.X * g_F_SCALE, Y : b_force.Y * g_F_SCALE };

  b_ax = force.X / b_WGT;
  b_ay = force.Y / b_WGT;

  // bof
  b_sx = b_ax * g_dtUpdate / 1000;
  b_sy = b_ay * g_dtUpdate / 1000;

  // don't forget to set force back to zero otherwise every next click
  // anywher will move the ball
  b_force.X = 0;
  b_force.Y = 0;
  // OR I could check for b_click to be true.
}

onMouseMove = function( evt )
{
  var cursorPostion = getCursorPos( evt );

  if( b_click )
  {
    b_force.X = cursorPostion.X - b_pClic.X;
    b_force.Y = cursorPostion.Y - b_pClic.Y;
  }
  else
  {
    b_hover = ( Math.sqrt( Math.pow( b_x - cursorPostion.X, 2 ) +
                           Math.pow( b_y - cursorPostion.Y, 2 )   ) <= b_R_SP );
  }
}


/* Compute cursor postion from a mouse event */
getCursorPos = function( mouseEvt )
{
  var x;
  var y;

  if( mouseEvt.pageX != undefined && mouseEvt.pageY != undefined )
  {
    x = mouseEvt.pageX;
    y = mouseEvt.pageY;
  }
  else
  {
    x = mouseEvt.clientX + document.body.scrollLeft +
    document.documentElement.scrollLeft;

    y = mouseEvt.clientY +
    document.body.scrollTop + document.documentElement.scrollTop;
  }

  x -= h_canvas.offsetLeft;
  y -= h_canvas.offsetTop;

  var pos = { X : x, Y : y };

  return pos;
}


/* Responsible for drawing everything on the screen */
draw = function()
{
  var ctx = h_canvas.getContext( "2d" );

  ctx.save();

  ctx.clearRect( 0, 0, f_W, f_H );

  // draw the field
  ctx.strokeStyle = "rgb( 115, 115, 115 )"
  ctx.strokeRect( 0, 0, f_W, f_H )

  // draw the ball
  ctx.strokeStyle = "#000";
  ctx.lineWidth   = 2;

  if( b_hover || b_click )
  {
    ctx.fillStyle = b_C_HVR;

    ctx.beginPath();
    ctx.arc( b_x, b_y, b_R_SP, 0, Math.PI*2 );
    ctx.closePath();

    ctx.fill();
  }

  if( b_click )
  {
    ctx.fillStyle = b_C_CLK;
  }
  else
  {
    ctx.fillStyle = b_C_FR;
  }

  ctx.beginPath();
  ctx.arc( b_x, b_y, b_R, 0, Math.PI*2 );

  if( b_click )
  {
    ctx.moveTo( b_pClic.X, b_pClic.Y );
    ctx.lineTo( b_pClic.X + b_force.X, b_pClic.Y + b_force.Y );
  }

  ctx.closePath();

  ctx.fill();
  ctx.stroke();

  ctx.restore();
}


/* Update objects' properties with a dt timestep */
update = function( dt )
{
  var friction = { X : -b_sx * f_F, Y : -b_sy * f_F };

  b_ax = friction.X / b_WGT;
  b_ay = friction.Y / b_WGT;

  b_sx = b_sx + ( b_ax * dt );
  b_sy = b_sy + ( b_ay * dt );

  b_x = b_x + ( b_sx * dt );
  b_y = b_y + ( b_sy * dt );

  // now seems like a good time to detect and handle collisions
}
