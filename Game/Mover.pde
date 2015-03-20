//This class represents a mover for the Ball
class Mover {
  
  //Mover attributes:
  PVector location;
  PVector velocity;
  PVector gravity;
  PVector friction;
  PVector totalForce;
  float g = 0.981;
  float normalForce;
  float mu;
  float frictionMagnitude;
  float elasticity;
  int sphereRadius;
  
  //Constructor for a new Mover
  Mover(int sphereRadius) {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
    totalForce = new PVector(0, 0, 0);
    normalForce = 1;
    mu = 0.01;
    frictionMagnitude = normalForce * mu;
    elasticity = 0.8;
    this.sphereRadius = sphereRadius;
  }

//Update the velocity & location according to the total force exerted on the ball
void update() {
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
  stroke(0);
  strokeWeight(3);
  sphere(sphereRadius);
  popMatrix();
}

//Check if the ball is on the edges of the plate and update its coordinates/velocity accordingly
void checkEdges(int boxLength) {
  if (location.x >= (boxLength/2.0)) {
    velocity.x = velocity.x * -elasticity;
    location.x = (boxLength/2.0);
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
void checkCylinderCollision(ArrayList<PVector> a, int cylinderBaseSize) {
  for(PVector c : a) {
      if(location.dist(c) <= sphereRadius + cylinderBaseSize) {
        PVector newLocation = new PVector(location.x, location.z, -(boxDepth/2 + sphereRadius));
        PVector normal = c.get();
        normal.sub(newLocation);
        normal.normalize();
        PVector replace = normal.get();
        replace.mult(sphereRadius + cylinderBaseSize);
        newLocation = PVector.add(c, replace); //to avoid enter the cylinder
        normal.mult(2 * velocity.dot(normal));
        velocity.sub(normal);
      }
  }
}

//Getters for x & z coordinates
float getX() {
  return location.x;
}

float getZ() {
  return location.z;
}

}
