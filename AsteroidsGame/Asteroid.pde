class Asteroid {
  PVector pos;
  PVector vel; 
  int size = 3;//3 = large 2 = medium and 1 = small
  float radius;
  ArrayList<Asteroid> chunks = new ArrayList<Asteroid>();//each asteroid contains 2 smaller asteroids which are released when shot
  boolean split = false;//whether the asteroid has been hit and split into to 2

  //------------------------------------------------------------------------------------------------------------------------------------------
  //constructor 
  Asteroid(float posX, float posY, float velX, float velY, int sizeNo) {
    pos = new PVector(posX, posY);
    size = sizeNo;
    vel = new PVector(velX, velY);

    switch(sizeNo) {//set the velocity and radius depending on size
    case 1:
      radius = 15;
      vel.normalize();
      vel.mult(1.25);
      break;
    case 2:
      radius = 30;
      vel.normalize();
      vel.mult(1);
      break;
    case 3:
      radius = 60;
      vel.normalize();
      vel.mult(0.75);
      break;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //draw the asteroid
  void show() {
    if (split) {//if split show the 2 chunks
      for (Asteroid a : chunks) {
        a.show();
      }
    } else {// if still whole
      noFill();
      stroke(255);
      polygon(pos.x, pos.y, radius, 12);//draw the dodecahedrons
      
    }
  }
//--------------------------------------------------------------------------------------------------------------------------
  //draws a polygon 
  //not gonna lie, I copied this from https://processing.org/examples/regularpolygon.html
  void polygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;//set the angle between vertexes
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {//draw each vertex of the polygon
      float sx = x + cos(a) * radius;//math
      float sy = y + sin(a) * radius;//math
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //adds the velocity to the position
  void move() {
    if (split) {//if split move the chunks
      for (Asteroid a : chunks) {
        a.move();
      }
    } else {//if not split
      pos.add(vel);//move it
      if (isOut(pos)) {//if out of the playing area wrap (loop) it to the other side
        loopy();
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //if out moves it to the other side of the screen
  void loopy() {
    if (pos.y < -50) {
      pos.y = height + 50;
    } else
      if (pos.y > height + 50) {
        pos.y = -50;
      }
    if (pos.x< -50) {
      pos.x = width +50;
    } else  if (pos.x > width + 50) {
      pos.x = -50;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //checks if a bullet hit the asteroid 
  boolean checkIfHit(PVector bulletPos) {
    if (split) {//if split check if the bullet hit one of the chunks
      for (Asteroid a : chunks) {
        if (a.checkIfHit(bulletPos)) {
          return true;
        }
      }
      return false;
    } else {
      if (dist(pos.x, pos.y, bulletPos.x, bulletPos.y)< radius) {//if it did hit
        isHit();//boom
        return true;
      }
      return false;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //probs could have made these 3 functions into 1 but whatever
  //this one checks if the player hit the asteroid
  boolean checkIfHitPlayer(PVector playerPos) {
    if (split) {//if split check if the player hit one of the chunks
      for (Asteroid a : chunks) {
        if (a.checkIfHitPlayer(playerPos)) {
          return true;
        }
      }
      return false;
    } else {
      if (dist(pos.x, pos.y, playerPos.x, playerPos.y)< radius + 15) {//if hit player 
        isHit();//boom

        return true;
      }
      return false;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //same as checkIfHit but it doesnt destroy the asteroid used by the look function
  boolean lookForHit(PVector bulletPos) {
    if (split) {
      for (Asteroid a : chunks) {
        if (a.lookForHit(bulletPos)) {
          return true;
        }
      }
      return false;
    } else {
      if (dist(pos.x, pos.y, bulletPos.x, bulletPos.y)< radius) {
        return true;
      }
      return false;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  //destroys/splits asteroid
  void isHit() {
    split = true;
    if (size == 1) {//can't split the smallest asteroids
      return;
    } else {
      //add 2 smaller asteroids to the chunks array with slightly different velocities
      PVector velocity = new PVector(vel.x,vel.y);
      velocity.rotate(-0.3);
      chunks.add(new Asteroid(pos.x, pos.y, velocity.x, velocity.y , size-1)); 
      velocity.rotate(0.5);
      chunks.add(new Asteroid(pos.x, pos.y, velocity.x, velocity.y , size-1)); 
    }
  }
}