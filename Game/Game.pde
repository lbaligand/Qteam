//Note: We decided to make many variables in order to modify the code more easily

//parameters for the plate
int boxLength = 500;
int boxDepth = 20;

//axis angles (X, Y, Z)
float rx = 0.0;
float ry = 0.0;
float rz = 0.0;

//rotation speed
float speed = 1.0;

//mover for the ball
Mover mover;
int sphereRadius = 20;

//cylinderMode parameters
boolean cylinderMode = false;
boolean isClicked = false;
ArrayList<PVector> cylinders;
Cylinder c; //"model" for the cylinder to avoid reconstruction (retained-style)

void setup() {
  size(1000, 1000, P3D);
  stroke(0);
  mover = new Mover(sphereRadius);
  c = new Cylinder(50, 100, 40);
  cylinders = new ArrayList();
}

void draw() {
  //camera(width/2, height/2, -2500, 250, 250, 0, 0, 1, 0);
  lights();
  ambientLight(mouseX, mouseX * mouseY, mouseY);
  background(255);
  translate(width/2, height/2, 0);
  
 if(!cylinderMode) {
  //pushMatrix();
  rotateX(rx);
  rotateZ(rz);
  //rotateY(ry); //OPTIONNAL
  box(boxLength, boxDepth, boxLength);
  
  //Draw the ball on the plate
  pushMatrix();
  mover.updateForces(rx, rz);
  mover.update();
  mover.checkEdges(boxLength);
  mover.checkCylinderCollision(cylinders, 100);
  translate(mover.getX(), - (boxDepth/2 + sphereRadius), mover.getZ());
  mover.display();
  popMatrix();
  
  //Draw all the cylinders on the plate
  pushMatrix();
  for(PVector p : cylinders) {
     c.display(p.x, p.y, boxDepth);
   }
  popMatrix();
  
  //popMatrix();
 } else {
   pushMatrix();
   //Displays the setup for add-cylinder Mode
   rotateX(-PI/2);
   box(boxLength, boxDepth, boxLength); //rotateX -> z becomes y and y becomes -z
   
   pushMatrix();
   //Displays the ball
   translate(mover.getX(), - (boxDepth + sphereRadius), mover.getZ());
   mover.display();
   popMatrix();
   
   //Add cylinders on the plate
   pushMatrix();
   c.display(mouseX - (width/2), mouseY - (height/2), boxDepth);
   if(isClicked) {
     //if click, add a new cylinder on the plate at that position
     cylinders.add(new PVector(mouseX - (width/2), mouseY - (height/2)));
     println(mouseX - width/2);
     println(mouseY - height/2);
     println(mover.getX());
     println(mover.getZ());
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

//To switch to the add-cylinder Mode if the shift-key is pressed
void keyPressed() {
  if(key == CODED) {
    if(keyCode == SHIFT) {
      //Branch to add-cylinder Mode
      cylinderMode = true;
    } /*else if(keyCode == RIGHT) { //OPTIONNAL
      ry += PI/16;
    } else if(keyCode == LEFT) {
      ry -= PI/16;
    }*/
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
  rx = map(mouseY * speed, 0, height, PI/3, -PI/3);
  rz = map(mouseX * speed, 0, width, PI/3, -PI/3);
}

//Increment/Decrement the speed of rotation via the wheel
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e > 0) {
    if(speed > 0.2) {
      speed -= 0.1;
    }
  } else {
    if(speed < 1.5) {
      speed += 0.1;
    }
  }
  println(speed);
}

//Set the indicator isClicked to true when click occurs
void mouseClicked() {
  isClicked = true;
}
