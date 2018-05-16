# 3D notes #1

<span class="note1">written by Nick Shin - nick.shin@gmail.com<br>
this file is licensed under: [Unlicense - http://unlicense.org/](http://unlicense.org/)<br>
and, is from - <https://www.nickshin.com/CheatSheets/></span>

* * *
* * *

this file contains some of my 3D math notes
- matrix math
- vector math
- lines w/ points, lines, circles equations
- planes w/ points, lines, planes equations


* * *
* * *


## MATRIX MATH


<http://www.gamedev.net/community/forums/topic.asp?topic_id=288127&whichpage=1&#1817579>
- nice explaination between OGL vs D3D matrices operations

What is important is matching the order of operation in OpenGL to
the order of the parameters in D3DX.

#### OpenGL, matrix operations are pre-concatenated

That is, operation M1 followed by M2 results in this:
```c
v' = M1 x M2 x v
```
which is `D3DXMatrixMultiply( &M, &M2, &M1 )` in D3D


#### OGL:
- variables on left are the transformation matrix equivalent of the function on the right:
```c
TP  = glTranslatef( position[0], position[1], position[2] )
TC  = glTranslatef( centered[0], centered[1], centered[2] )
RA  = glRotatef   ( rotateAngle,        Raxis[0], Raxis[1], Raxis[2] )
RS  = glRotatef   ( ScaleRotateAngle,   Saxis[0], Saxis[1], Saxis[2] )
S   = glScalef    ( scalef[0], scalef[1], scalef[2] )
RSI = glRotatef   ( 0-ScaleRotateAngle, Saxis[0], Saxis[1], Saxis[2] )
TCI = glTranslatef( 0-centerd[0], 0-centerd[1], 0-centerd[2] )
```

note: matrix multiplication (transformation) is automatically applied (to an initial
identity matrix) after each function call above and is stored internally (in
that initial matrix).  to retrieve the results, use:
```c
glGet( GL_MODELVIEW_MATRIX, GLfloats* values );
// then multiply returned [ matrix *** ] with [ vector !!! ] to complete the transformation
```

If you expressed that code in column-major notation (used by OpenGL), you get this:
- note: **PRE-CONCATENATED** notation
```c
v' = TP x TC x RA x RS x S x RSI x TCI x v
```

The row-major (used by D3D) equivalent is this:
- note: **POST-CONCATENATED** notation
```c
  v' = v x TCI x RSI x S x RS x RA x TC x TP
```

#### The D3DX code equivalent is this:
```c
D3DXTranslation ( &TP,   position );
D3DXTranslation ( &TC,   centerd );
D3DXRotationAxis( &RA,   Raxis, rotateAngle );
D3DXRotationAxis( &RS,   Saxis, ScaleRotateAngle );
D3DXScaling     ( &S,    scalef );
D3DXRotationAxis( &RSI,  Saxis, -ScaleRotateAngle );
D3DXTranslation ( &TCI, -centerd );
```

#### note: the following is the PRE-CONCATENATED equivalent
```c
D3DXMatrixIdentity( &M );
D3DXMatrixMultiply( &M, &TP, &M );
D3DXMatrixMultiply( &M, &TC, &M );
D3DXMatrixMultiply( &M, &RA, &M );
D3DXMatrixMultiply( &M, &RS, &M );
D3DXMatrixMultiply( &M, &S,  &M );
D3DXMatrixMultiply( &M, &RSI, &M );
D3DXMatrixMultiply( &M, &TCI, &M );
glLoadMatrixf( &M );
// then multiply returned [ matrix *** ] with [ vector !!! ] to complete the transformation
```

note: the following is the **POST-CONCATENATED** implimentation
- see the difference between [ parameter AND implimentation ] order
```c
D3DXMatrixIdentity( &M );
D3DXMatrixMultiply( &M, &M, &TCI );
D3DXMatrixMultiply( &M, &M, &RSI );
D3DXMatrixMultiply( &M, &M, &S );
D3DXMatrixMultiply( &M, &M, &RS );
D3DXMatrixMultiply( &M, &M, &RA );
D3DXMatrixMultiply( &M, &M, &TC );
D3DXMatrixMultiply( &M, &M, &TP );
glLoadMatrixf( &M );
// then multiply [ vector !!! ] with returned [ matrix *** ] to complete the transformation
```

note: transposing the matrix can be used to go back and forth
between pre/post-concatenated notation -- but try NOT to do this...

* * *

<http://www.3dbuzz.com/vbforum/showthread.php?171267-Left-hand-and-Right-hand-Coordinate-Systems&p=1407846#post1407846>
- video1+4
	- some more difference between systems using RHCS vs LHCS
- video3
	- column-major & row-major (matrix & vector) math yields the SAME RESULTS
	  so, column-major vs row-major systems IS NOT IMPORTANT
	  just make sure to use ONE SYSTEM through out the code base
- video4+5
	- data interpretation IS IMPORTANT -- such as
	  - RHCS vs LHCS : z-in versus z-out
	  - matrix to (programming) array : column/row-major to array data
		- remember, internal math yields the SAME RESULTS,
		  but, make sure to remember which order of operation
		  is used -- PRE-CONCATENATED vs POST-CONCATENATED
		  so, PICK ONE order and stick with it through out the code base


#### RHCS

in general, uses column major:
- i.e:`4x1 *4 ==> matrix`
```
T (4x4) transformation matrix
v (4x1) a vector
Tv = v' (4x1)
```

axis rotation:
- positive rotation: CCW
- negative rotation:  CW

draw vs culling
-  CW verticies are drawn
- CCW verticies are culled

who uses RHCS
- openGL
- XNA
	- but, culling is like LHCS by default, to change it:
```c
RasterizerState stat = newRasterizerState();
stat.CullMode = CullMode.CullClockwiseFace;
stat.CullMode = CullMode.CullCounterClockwiseFace;
stat.CullMode = CullMode.None;
```

#### LHCS

in general, uses row major:
- i.e: `1x4 *4 ==> matrix`
```
v (1x4) a vector
T (4x4) transformation matrix
vT = v' (1x4)
```

axis rotation:
- positive rotation:  CW
- negative rotation: CCW

draw vs culling
- CCW verticies are drawn
-  CW verticies are culled

who uses LHCS
- mathematicans
- direct3D
- unreal

* * *
* * *

## VECTOR MATH

with unit vectors:
- `cos theta = dot_product` : yields the angle of incidence

otherwise:
- `dot_product` is the projection (length) of one vector onto another

- `normal_vector = cross_product` : and needs to be normalized to be a unit vector
	- because in general:
```
cross_product length is the area (parallelogram) between the two vectors
a.k.a: the magnitude of the two vector's perpendicular (normal) vector
```

<http://mathworld.wolfram.com/ScalarTripleProduct.html>

vector triple product notation:
```c
[ A, B, C ] = A dot ( B x C )
            = B dot ( C x A )
            = C dot ( A x B )
            = det ( A B C )
              | A1 A2 A3 |
            = | B1 B2 B3 |
              | C1 C2 C3 |
```

<http://mathworld.wolfram.com/VectorQuadrupleProduct.html>

lagrange's identity
```c
( A x B ) dot ( A x B ) = ( A dot A ) ( B dot B ) - ( A dot B ) ( A dot B )
( A x B ) dot ( C x D ) = ( A dot C ) ( B dot D ) - ( A dot D ) ( B dot C )
```

vector quadruple product:
```c
( A x B ) ^2 = A^2 B^2 - ( A dot B )^2
( A x B ) x ( A x B ) = B ( A dot ( A x B ) ) - ( A dot B ) ( A x B )
( A x B ) x ( C x D ) = B ( A dot ( C x D ) ) - ( A dot B ) ( C x D )
                      = ( C x D ) x ( B x A )
                      = [ A, B, D ] C - [ A, B, C ] D
                      = [ C, D, A ] B - [ C, D, B ] A
```

* * *

## TRIG MATH - TRY NOT TO USE THESE DIRECTLY...
####  (but use this to CONVERT trig equations INTO vector equations)

<http://en.wikipedia.org/wiki/Trigonometric_identity>

useful identities...
```c
sin theta = (+-) sqrt( 1 - dot_product )

                     1 - cos x
sin x/2 = (+-) sqrt( --------- )
                         2

                     1 + cos x
cos x/2 = (+-) sqrt( --------- )
                         2

sin2 x + cos2 x = 1

sin 2x = 2 * sin x * cos x

cos 2x = cos2 x - sin2 x = 2 cos2 x - 1 = 1 - 2sin2 x


sin ( a + b ) = sin a * cos b + cos a * sin b

sin ( a - b ) = sin a * cos b - cos a * sin b

cos ( a + b ) = cos a * cos b - sin a * sin b

cos ( a - b ) = cos a * cos b + sin a * sin b


2 sin a * sin b = cos( a - b ) - cos ( a + b )

2 cos a * cos b = cos( a - b ) + cos ( a + b )

2 sin a * cos b = sin( a + b ) + sin ( a - b )

2 cos a * sin b = sin( a + b ) - sin ( a - b )

                        a + b           a - b
sin a + sin b = 2 sin ( ----- ) * cos ( ----- )
                          2               2

                        a + b           a - b
sin a - sin b = 2 cos ( ----- ) * sin ( ----- )
                          2               2

                        a + b           a - b
cos a + cos b = 2 cos ( ----- ) * cos ( ----- )
                          2               2

                         a + b           a - b
cos a - cos b = -2 sin ( ----- ) * sin ( ----- )
                           2               2

A cos x + B sin x = sqrt( A2 + B2 ) cos( x - tan-1 ( B/A ) )
```

* * *
* * *


## LINES


<http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html>

```c
eq of a line = ( v3b - v3a )
```

* * *

#### LINES :: POINTS


<http://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html>

closest point (p) from point (v3c) to line (as noted above):
```c
          ( v3a - v3c ) dot ( line )
t = ( - ) --------------------------
                 dist2( line )
```

vector from point (v3c) to (v3a) flipped:
```c
          ( v3c - v3a ) dot ( line )
t = ( + ) --------------------------
                 dist2( line )

p = v3a + scale_v3( line, t );

note: if t < 0.0, p is behind segment AB
      if t > 1.0, p is past   segment AB
```

dist v3c to line:
```c
      dist2( ( line ) cross ( v3a - v3c ) )
d^2 = ------------------------------------------
                 dist2( line )
```

with vector quadruple product identity:
```c
      dist2( ( v3c - v3a ) cross ( v3c - v3b ) )
d^2 = ------------------------------------------
                 dist2( line )

note: if d == 0, v3c is ON the line at p
```

* * *

#### LINES :: LINES


<http://mathworld.wolfram.com/Line-LineIntersection.html>

equations require coplanar conditions

<http://www.softsurfer.com/Archive/algorithm_0106/algorithm_0106.htm>

it is best to restrict calculations to 2D (coplanar) and then check to see if
3rd coords values collapse (intersect) or differs (dist between 2 lines).

intersection of two lines:
```c
// commented out lines of code represent 3D vectors if all points were coplanar...
// inline comments, are 2D notes...
	line_a = p2 - p1			// (21) v2_sub_v2( line_a, p1, p2 );
	line_b = p4 - p3			// (22) v2_sub_v2( line_b, p3, p4 );
//	norm_ab  = line_a cross line_b
//	denom = dist2( norm_ab )	// i.e. norm_ab dot norm_ab
	denom  = line_a.y * line_b.x - line_a.x * line_b.y;
	if ! denom:
		// parallel, try with 3rd axis to at least get closest point...
		// i.e. y & z or x & z - but only need to one, not both...
		// if here again, lines are the same...
		return lines_collinear;
	
	line_c = p3 - p1			// (23) v2_sub_v2( line_c, p1, p3 );
//	norm_cb = line_c cross line_b
//	num_s = norm_cb dot norm_ab
	num_s = line_c.y * line_b.x - line_c.x * line_b.y;		// 2D
	s = num_s / denom;
	int_a = p1 + scale_v3( line_a, s );
	
//	norm_ca = line_c cross line_a
//	num_t = norm_ca dot norm_ab
	num_t = line_c.y * line_a.x - line_c.x * line_a.y;		// 2D
	t = num_t / denom;
	int_b = p2 + scale_v3( line_b, t );
	if int_a == int_b
		return lines_intersect;
	closest_dist = dist1( int_a, int_b )
	return lines_cross_but_do_not_intersect;
```

- note: both s and t will show if intersection is behind ( < 0 ) or ahead ( > 1 ) the respective vector<br>
if it is between ( 0 < s or t < 1 ), the intersection is within the (respective) vector length

<http://mathworld.wolfram.com/Line-LineDistance.html>

distance between lines: (can be skewed lines)
```c
      dist2( line_c dot ( line_a cross line_b ) )
d^2 = -------------------------------------------
             dist2( line_a cross line_b )
```

<http://www.softsurfer.com/Archive/algorithm_0106/algorithm_0106.htm>

closest point of approach (CPA):

```c
p1: with direction u
p2: with direction v

    ( p2 - p1 ) dot ( u - v )
t = -------------------------
        dist2( u - v )

note: if t < 0.0, points are going farther apart
      if dist1( u - v ) == 0 (denominator)
         then let t = 0, points traveling at same direction & speed
      if t > 1.0, points are closest at t unit(s) "of time"
         p1 at t: p1 + t * u
         p2 at t: p2 + t * v
         closest_dist at CPA is dist1( p1, p2 )
```

* * *

#### LINES :: CIRCLES / SPHERES

<http://mathworld.wolfram.com/Circle-LineIntersection.html>

use point (circle pos) to line dist calculations
```c
if dist is > radius - no intersection
if dist == radius - tangent
if dist < radius - intersects

then solve for p from "closest point to line" equations
then take unit vector of ( line ): u		// v3a to v3b, normalized
    and scale it by: s = sqrt( radius^2 - dist^2 )
    so, with: u0 = u * s
    finally: first intersection is at:       p - u0
             and section intersection is at: p + u0
```

* * *
* * *

## PLANES


<http://mathworld.wolfram.com/Plane.html>

components of a plane:
```
plane normal (n) -- a unit vector
"the" point (p) on the plane through the plane's normal from origin
plane's constant# (c)  a.k.a. dist of plane from origin
```

eq of a plane:
```c
n dot p = -c
n dot ( a - p ) = 0		// note: a-p need not be of unit length...
```

using (n) and (c) is the simplest to use and smallest memory space used<br>
for example, (p) can be calculated from (n) scaled by (c)

* * *

#### PLANES :: POINTS

<http://mathworld.wolfram.com/Point-PlaneDistance.html>

dist (d) of point (b) to plane is the projection of the line from a point (a)
(any point) on the plane to point (p) on the plane's (unit vector) normal (n)

```c
d = n dot ( b - a )
```

(a) can be points from either the plane's normal scaled by its constant# (yielding
"the" point) or any of the points from the vectors created to find the plane's normal

* * *

#### PLANES :: LINES

<http://mathworld.wolfram.com/Line-PlaneIntersection.html>

intersection point (p) of line ( v3b - v3a ) to plane ( n & a )
- (a) again, is any point on the plane...

```c
    n dot ( a - v3a )
s = -----------------
     n dot ( line )

p = v3a + scale_v3( line, s )
```

* * *

#### PLANES :: PLANES

<http://mathworld.wolfram.com/Plane-PlaneIntersection.html>

<http://softsurfer.com/Archive/algorithm_0104/algorithm_0104B.htm>

intersection line of two planes:
- line = a vector (direction)
- a point on the line

```c
vector = n1 cross n2
```

a point on the line can be found with either:
1. intersection of two lines (can be done with restricted 2D calculations) using one line from each plane
1. intersection of a line (from one of the planes) to the other plane

* * *
* * *

## CYLINDERS

cylinder collisions: are basically, "line intersection" tests
- using the returned s and t values, add respective cylinder radius values
  to them and compare/calculate hit/miss results to ensure full size coverage
- then, use (with both cylinder radius values) "distance between lines" to
  further determine compare/calculate hit/miss results
- finally, check end caps properly or use the results from the "pill" shape
  object (instead of a true cylinder shape)

* * *
* * *

## BOXES

two box tests:
- use two sphere distance test for fast miss check
- then use terse checks: "point plane" tests against all sides on the other box

line & box tests:
- use line and sphere (circle) intersection test for fast miss check
- then use terse checks: "line plane" tests against all sides on the box

* * *




<style>
.note1                    { font-size: 11px; }
pre                       { margin-left: 2em; }
.markdown-body pre code   { font-size: 80%; }
</style>

