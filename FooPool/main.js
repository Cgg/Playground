/* FooPool
 *
 * A kind of pool simulation in JavaScript. Quite basic for now:
 * - the field is the canvas
 * - the user can give direct impulse to the ball only
 * - basic bouncing behaviour against the edges
 * - only one ball
 * - no fancy visual effects
 */

/* Some guidelines I try to stick with :
 * 
 * - variables declarations are sorted between the different objects (ball,
 * field, ...) and the variable name is prefixed accordingly
 * - local variables may not use prefixes
 * - after the prefix I use camel case
 * - if a variable is a constant its name is in uppercase (not the prefix)
 */

init = function()
{
  /* Wonderful html world */
  h_canvas = document.getElementById( "mainCanvas" )

  /* game variables */
  g_dtDraw   = 33;
  g_dtUpdate = 33;

  /* Field */
  f_W = h_canvas.width
  f_H = h_canvas.height

  /* Balls of steel */
  b_x  = f_W / 2; // position
  b_y  = f_H / 2;
  b_sx = 0;       // speed
  b_sy = 0;
  b_ax = 0;       // acceleration
  b_ay = 0;
  b_R  = 10;      // ball's radius

  setInterval( "draw()", g_dtDraw );
  setInterval( "update( g_dtUpdate )", g_dtUpdate );
}


/* Responsible for drawing everything on the screen */
draw = function()
{
  // TODO save context and restore it
  var ctx = h_canvas.getContext( "2d" );

  ctx.clearRect( 0, 0, f_W, f_H );

  // draw the field
  ctx.strokeStyle = "rgb( 115, 115, 115 )"
  ctx.strokeRect( 0, 0, f_W, f_H )

  // draw the ball
  ctx.strokeStyle = "#000"
  ctx.lineWidth   = 2;
  ctx.fillStyle   = "rgb( 255, 94, 94 )"

  ctx.beginPath();
  ctx.arc( b_x - b_R, b_y, b_R, 0, Math.PI*2 );
  ctx.closePath();

  ctx.fill();
  ctx.stroke();
}


/* Update objects' properties with a dt timestep */
update = function( dt )
{
}
