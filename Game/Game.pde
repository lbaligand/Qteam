//Note: We decided to make many variables in order to modify the code more easily

//parameters for the plate
int boxLength = 300;
int boxDepth = 5;

//axis angles (X, Y, Z)
float rx = 0.0;
float rz = 0.0;

//rotation speed
float speed = 1.0;
float currentX;
float currentY;

//mover for the ball
Mover mover;
int sphereRadius = 10;

//cylinderMode parameters
boolean cylinderMode = false;
boolean isClicked = false;
ArrayList<PVector> cylinders;
Cylinder c; //"model" for the cylinder to avoid reconstruction (retained-style)

//Data visualization surfaces
PGraphics dataBackGround;

void setup() {
  size(600, 600, P3D);
  stroke(0);
  mover = new Mover(boxDepth, sphereRadius);
  c = new Cylinder(25, 25, 40);
  cylinders = new ArrayList();
  dataBackGround = createGraphics(600, 100, P2D);
}

void draw() {
  lights();
  background(141, 182, 205);
  fill(255, 250, 205);
  drawBackGround();
  image(dataBackGround, 0, 500);
  fill(0, 100, 0);
  translate(width/2, height/2, 0);
  
 if(!cylinderMode) {
  if(rx > PI/3) {
    rx = PI/3;
  } else if(rx < -PI/3) {
    rx = -PI/3;
  }
  if(rz > PI/3) {
    rz = PI/3;
  } else if(rz < -PI/3) {
    rz = -PI/3;
  }
  rotateX(rx);
  rotateZ(rz);
  box(boxLength, boxDepth, boxLength);
  
  //Draw the ball on the plate
  pushMatrix();
  mover.update(rx, rz);
  mover.checkEdges(boxLength);
  mover.checkCylinderCollision(cylinders, 50, boxDepth);
  translate(mover.getX(), - (boxDepth/2 + sphereRadius), mover.getZ());
  mover.display();
  popMatrix();
  
  //Draw all the added cylinders on the plate
  pushMatrix();
  for(PVector p : cylinders) {
     c.display(p.x, p.y, boxDepth);
  }
  popMatrix();
  
 } else {
   pushMatrix();
   //Displays the setup for add-cylinder Mode
   rotateX(-PI/2);
   box(boxLength, boxDepth, boxLength);
 
   //Displays the ball  
   pushMatrix();
   fill(120, 150, 50);
   translate(mover.getX(), - (boxDepth + sphereRadius), mover.getZ());
   mover.display();
   popMatrix();
   
   //Add cylinders on the plate
   pushMatrix();
   //Display the moving cylinder
   c.display(mouseX - (width/2), mouseY - (height/2), boxDepth);
   //If a click occurs, add a new cylinder on the plate at that position
   //Check if the cylinder is beyond the edges of the plate and
   //if so, do not place it
   if(isClicked) {
     if((mouseX - (width/2) >= (- boxLength/2 + 50/2)) && (mouseX - (width/2) <= (boxLength/2 - 50/2)) 
       && (mouseY - (height/2) <= (boxLength/2 - 50/2)) && (mouseY - (height/2) >= (-boxLength/2 + 50/2))) {
       cylinders.add(new PVector(mouseX - (width/2), mouseY - (height/2)));
     }
     isClicked = false;
   }
   //Display the added cylinders on the plate
   for(PVector p : cylinders) {
     c.display(p.x, p.y, boxDepth);
   }
   popMatrix();
   
   popMatrix();
 }
 
}

//To switch to the add-cylinder Mode if the key SHIFT is pressed
void keyPressed() {
  if(key == CODED) {
    if(keyCode == SHIFT) {
      //Activate add-cylinder Mode
      cylinderMode = true;
    }
  }
}

//To recover from add-cylinder Mode
void keyReleased() {
  if(key == CODED) {
    if(keyCode == SHIFT) {
      cylinderMode = false;
    }
  }
}

//Tilt the plate around x & z axis if the mouse is Pressed, according to the speed
//Note: we do not limit the mouseX and mouseY to the display window
void mouseDragged() {
  rx = map(mouseY, 0, height, PI/3, -PI/3) * speed;
  rz = map(mouseX, 0, width, PI/3, -PI/3) * speed;
}

//Increment/Decrement the speed of rotation via the wheel
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e > 0) {
    if(speed > 0.2) {
      speed -= 0.1;
    }
  } else {
     if (speed < 1.5) {
      speed += 0.1;
     }
   }
}

//Set the boolean indicator isClicked to true when a click occurs
void mouseClicked() {
  isClicked = true;
}

void drawBackGround() {
  dataBackGround.beginDraw();
  dataBackGround.background(255, 250, 205);
  dataBackGround.endDraw();
}
