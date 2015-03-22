//This class represents a mover for the Ball
class Mover {
  
//Mover attributes:
  //Ball attributes:
  PVector location;
  PVector velocity;
  int sphereRadius;
  
  //Forces & parameters:
  PVector gravity;
  PVector friction;
  PVector totalForce;
  float g = 0.981;
  float normalForce;
  float mu;
  float frictionMagnitude;
  float elasticity;
  
  //Constructor for a new Mover
  Mover(int boxDepth, int sphereRadius) {
    location = new PVector(0, -(boxDepth/2 + sphereRadius), 0);
    velocity = new PVector(0, 0, 0);
    this.sphereRadius = sphereRadius;
    gravity = new PVector(0, 0, 0);
    totalForce = new PVector(0, 0, 0);
    normalForce = 1;
    mu = 0.01;
    frictionMagnitude = normalForce * mu;
    elasticity = 0.8;
  }

//Getter for x coordinate
float getX() {
  return location.x;
}

//Getter for z coordinate
float getZ() {
  return location.z;
}

//Update the velocity & location according to the total force exerted on the ball
void update(float x, float z) {
  updateForces(x, z);
  velocity.add(totalForce);
  location.add(velocity);
}

//Update the forces according to the plate position
void updateForces(float x, float z) {
  gravity.x = sin(z) * g;
  gravity.z = sin(-x) * g;
  friction = velocity.get();
  friction.mult(-1);
  friction.normalize();
  friction.mult(frictionMagnitude);
  totalForce = friction.get();
  totalForce.add(gravity);
}

//Display the ball on the plate
void display() {
  pushMatrix();
  noStroke();
  fill(139, 10, 80);
  sphere(sphereRadius);
  popMatrix();
}

//Check if the ball is on the edges of the plate
void checkEdges(int boxLength) {
  if (location.x >= (boxLength/2.0)) {
    velocity.x = velocity.x * -elasticity;
    location.x = (boxLength / 2.0);
  }
  else if (location.x <= - (boxLength / 2.0)) {
    velocity.x = velocity.x * (- elasticity);
    location.x = - (boxLength / 2.0);
  }
  if (location.z >= (boxLength / 2.0)) {
    velocity.z = velocity.z * (- elasticity);
    location.z = (boxLength / 2.0);
  }
  else if (location.z <= - (boxLength / 2.0)) {
    velocity.z = velocity.z * (- elasticity);
    location.z = - (boxLength / 2.0);
  }
}

//Check if the ball hits a cylinder
void checkCylinderCollision(ArrayList<PVector> a, int cylinderBaseSize, int boxDepth) {
  for(PVector c : a) {
      //Create a new cylinder vector adapted to the location
      PVector correctedC = new PVector(c.x, location.y, c.y);
      if(correctedC.dist(location) <= (sphereRadius + cylinderBaseSize)) {
        //Compute the normal vector
        PVector normal = correctedC.get();
        normal.sub(location);
        normal.normalize();
        //Compute the new correct location
        PVector updatedLocation = normal.get();
        updatedLocation.mult(-(cylinderBaseSize + sphereRadius));
        updatedLocation.add(correctedC);
        location = new PVector(updatedLocation.x, -(boxDepth / 2 + sphereRadius), updatedLocation.z); //to avoid enter the cylinder we update the location
        //Update the velocity
        normal.mult(2 * velocity.dot(normal));
        velocity.sub(normal);
        velocity.mult(elasticity);
      }
  }
}

}
