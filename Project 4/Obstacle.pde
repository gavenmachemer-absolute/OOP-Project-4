/**
 *      Author: Flynn Quiram
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Project4.pde
 * Description: Obstacles for the game
 */
 

class Obstacle extends Actor {
  PImage vase;

  Obstacle() {
    super(10, 0, Direction.NORTH);
    vase = loadImage("vaseMorales.png");
  }
  /**
   * Constructor:  Obstacle()
   *  Parameters: JSONObject object - A JSON serialization of the obstacle
   * Description: Constructs an obstacle from JSON save data
   */
  Obstacle(JSONObject object) {
    super(object);
    vase = loadImage("vaseMorales.png");
  }

  Action getAction() {
    return null;
  }
  
  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the object to JSON
   */
  public JSONObject serialize() {
    JSONObject object = super.serialize();
    object.setString("className", "Obstacle");
    return object;
  }

 /**
 *      Method: draw()
 *  Parameters: void
 *      Return: void
 * Description: Draws the obstacles and health bar
 */
  void draw() {
    float healthWidth = 0.4;
    float healthHeight = 0.05;
    float healthPercent = getHealth();

    //health depleted background - red
    push();
    rectMode(CENTER);
    noStroke();
    fill(255, 0, 0);
    rect( 0.5, .1, healthWidth, healthHeight);

    //current health - green
    noStroke();
    fill(0, 255, 0);
    rect( 0.5, .1, healthWidth * healthPercent, healthHeight);

    image(vase, 0, 0, 1, 1);
    pop();
  }
}
