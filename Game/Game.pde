//Note: We decided to make many variables in order to modify the code more easily

//parameters for the plate
int boxLength = 300;
int boxDepth = 5;

//axis angles (X, Z)
float rx = 0.0;
float rz = 0.0;

//rotation speed
float speed = 1.0;

//mover for the ball
Mover mover;
int sphereRadius = 15;

//cylinderMode parameters
boolean cylinderMode = false;
boolean isClicked = false;

//int cylinderBaseSize;          //MODIF
//int cylinderHeight;
//int cylinderResolution;
//ArrayList<PVector> cylinders;
//Cylinder c; //"model" for the cylinder to avoid reconstruction (retained-style)

//Data visualization surfaces
int panelHeight;
PGraphics dataBackGround;
PGraphics topView;
PGraphics scoreboard;

//Tree visualization
int treeBaseSize;
PShape tree;
ArrayList<PVector> trees;

void setup() {
  //Setup
  size(600, 600, P3D);
  stroke(0);
  
  //Ball
  mover = new Mover(boxDepth, sphereRadius);
  
  //Cylinders                                                              //MODIF
  //cylinderBaseSize = 25;
  //cylinderHeight = 25;
  //cylinderResolution = 40;
  //c = new Cylinder(cylinderBaseSize, cylinderHeight, cylinderResolution);
  //cylinders = new ArrayList();
  
  //Panel
  panelHeight = 100;
  dataBackGround = createGraphics(width, panelHeight, P2D);
  topView = createGraphics(8 * panelHeight / 10, 8 * panelHeight / 10, P2D);
  scoreboard = createGraphics(8 * panelHeight / 10, 8 * panelHeight / 10, P2D);
  
  //Trees
  treeBaseSize = 20;
  tree = loadShape("simpleTree.obj");
  tree.scale(50);
  trees = new ArrayList();
}

void draw() {
  lights();
  background(141, 182, 205);
  fill(255, 250, 205);
  drawBackGround();
  image(dataBackGround, 0, 500);
  drawTopView();
  image(topView, panelHeight/10, height - panelHeight + panelHeight/10);
  drawScoreBoard();
  image(scoreboard, panelHeight, height - panelHeight + panelHeight/10);
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
  mover.checkCylinderCollision(trees, treeBaseSize, boxDepth);                    //MODIF : cylinders -> trees, cylinderBaseSize -> treeBaseSize
  translate(mover.getX(), - (boxDepth/2 + sphereRadius), mover.getZ());
  mover.display();
  popMatrix();
  
  //Draw all the added trees on the plate
  for(PVector t : trees) {
     pushMatrix();
     rotate(PI);
     translate(- t.x, -boxDepth/2, t.y);
     shape(tree);
     popMatrix();
     //c.display(p.x, p.y, boxDepth);                                              //MODIF
  }
  
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
   
   //Add trees on the plate
   pushMatrix();
   
   //Display the moving cylinder
   //c.display(mouseX - (width/2), mouseY - (height/2), boxDepth);                            //MODIF
   
   //Display the tree                                                                         
   pushMatrix();
   rotate(PI);
   translate(- mouseX + (width/2), -boxDepth/2, mouseY - (height/2));
   shape(tree);
   popMatrix();
   //If a click occurs, add a new tree on the plate at that position
   //Check if the cylinder is beyond the edges of the plate and
   //if so, do not place it
   if(isClicked) {
     if((- mouseX + (width/2) >= (- boxLength/2 + treeBaseSize/2)) && (- mouseX + (width/2) <= (boxLength/2 - treeBaseSize/2))
       && (mouseY - (height/2) <= (boxLength/2 - treeBaseSize/2)) && (mouseY - (height/2) >= (-boxLength/2 + treeBaseSize/2))) {
         
       //cylinders.add(new PVector(mouseX - (width/2), mouseY - (height/2)));                                                    //MODIF
       
       trees.add(new PVector(mouseX - width/2, mouseY - height/2));
     }
     isClicked = false;
   }
   //Display the added trees on the plate
   for(PVector t : trees) {
     pushMatrix();
     rotate(PI);
     translate(- t.x, -boxDepth/2, t.y);
     shape(tree);
     popMatrix();
     //c.display(p.x, p.y, boxDepth);                              //MODIF
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

void drawTopView() {
  topView.beginDraw();
  
  topView.background(0, 130, 0);
  topView.rect(panelHeight/10, height - panelHeight + panelHeight/10, 8 * panelHeight / 10, 8 * panelHeight / 10);
  
  float ballPanelWidth = map(2 * sphereRadius, 0, boxLength, 0, 8 * panelHeight / 10);
  float ballPanelX = map(mover.getX(), -boxLength / 2, boxLength / 2, 0, 8 * panelHeight / 10);
  float ballPanelY = map(mover.getZ(), -boxLength / 2, boxLength / 2, 0, 8 * panelHeight / 10);
  topView.fill(139, 10, 90);
  topView.ellipse(ballPanelX, ballPanelY, ballPanelWidth, ballPanelWidth);
  
  for(PVector t : trees) {
    float cylinderPanelX = map(t.x, -boxLength / 2, boxLength / 2, 0, 8 * panelHeight / 10);              //MODIF : CYLINDER -> TREE
    float cylinderPanelY = map(t.y, -boxLength / 2, boxLength / 2, 0, 8 * panelHeight / 10);
    float cylinderPanelBaseSize = map(2 * treeBaseSize, 0, boxLength, 0, 8 * panelHeight / 10);
    topView.fill(0, 139, 0);
    topView.ellipse(cylinderPanelX, cylinderPanelY, cylinderPanelBaseSize, cylinderPanelBaseSize);
  }
  
  topView.endDraw();
}

void drawScoreBoard() {
  scoreboard.beginDraw();
  
  scoreboard.background(141, 182, 205);
  scoreboard.rect(panelHeight, height - panelHeight + panelHeight/10, 8 * panelHeight / 10, 8 * panelHeight / 10);
  
  scoreboard.textSize(7);
  scoreboard.fill(139, 10, 90);
  //Total Score
  scoreboard.text("Total Score :" + mover.getScore(), 8 * panelHeight / 200, 8 * panelHeight / 50);
  //Current velocity magnitude
  scoreboard.text("Velocity: " + mover.getVelocityMagnitude(), 8 * panelHeight / 200, 2.5 * 8 * panelHeight / 50);
  //Points achieved in the last hitting event
  scoreboard.text("Last score: " + mover.getLastScore(), 8 * panelHeight / 200, 4 * 8 * panelHeight / 50);
  
  scoreboard.endDraw();
}
