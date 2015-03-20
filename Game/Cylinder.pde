//This class represents a cylinder
class Cylinder {
//Cylinder attributes:
  //parameters:
  int cylinderBaseSize;
  int cylinderHeight;
  int cylinderResolution;

  //the 3 faces of the closed cylinder:
  PShape openCylinder;
  PShape topFace;
  PShape bottomFace;

  //Constructor for a new Cylinder:
  Cylinder(int cylinderBaseSize, int cylinderHeight, int cylinderResolution) {
  this.cylinderBaseSize = cylinderBaseSize;
  this.cylinderHeight = cylinderHeight;
  this.cylinderResolution = cylinderResolution;
  openCylinder = new PShape();
  topFace = new PShape();
  bottomFace = new PShape();
   
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  
  //get the x and y position on a circle for all the sides
  for(int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  
  //Open Cylinder:
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  //draw the border of the cylinder
  for(int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i] , 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();
  
  //Top Face:
  topFace = createShape();
  topFace.beginShape(TRIANGLES);
  //draw the topFace of the closed cylinder
  for(int i = 0; i < x.length - 1; i++) {
    topFace.vertex(x[i], y[i], cylinderHeight);
    topFace.vertex(x[i+1], y[i+1], cylinderHeight);
    topFace.vertex(0, 0, cylinderHeight);
  }
  topFace.endShape();
  
  //Bottom Face
  bottomFace = createShape();
  bottomFace.beginShape(TRIANGLES);
  //draw the bottomFace of the closed cylinder
  for(int i = 0; i < x.length - 1; i++) {
    bottomFace.vertex(x[i], y[i], 0);
    bottomFace.vertex(x[i+1], y[i+1], 0);
    bottomFace.vertex(0, 0, 0);
  }
  bottomFace.endShape();
  
}

void display(float x, float y, int boxDepth) {
  pushMatrix();
  //rotate the cylinder to obtain view from the top
  rotateX(PI/2);
  //follow the mouse
  translate(x, y, boxDepth/2);
  //display the shapes
  shape(openCylinder);
  shape(topFace);
  shape(bottomFace);
  popMatrix();
}

}
