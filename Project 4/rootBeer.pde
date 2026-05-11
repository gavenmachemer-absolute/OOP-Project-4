/**
 *      Author: Prof. Morales, Gaven Machemer, Flynn Quiram
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Project4.pde
 * Description: rootBeer interactable item- health pack/health
 *              point replenishing item of the game
 */
 
class rootBeer extends Interactable {
  PImage beer;

  rootBeer() {
    beer = loadImage("beersWithMorales2029.png");
  }
  
  /**
   * Constructor: rootBeer()
   *  Parameters: JSONObject object - A JSON serialization of the rootBeer
   * Description: Constructs a rootBeer from JSON save data
   */
  rootBeer(JSONObject object) {
    beer = loadImage("beersWithMorales2029.png");
  }

  boolean interact(Player player) {
    player.updateHealth(20);
    return true;
  }
  /**
 *      Method: draw()
 *  Parameters: void
 *      Return: void
 * Description: Draws the interactable item root beer.
 */
  void draw() {
    push();
    float offset = sin(frameCount * 0.1) * 0.08; //figured out how to do this sin wave from this forum https://forum.processing.org/beta/num_1266372115.html
    imageMode(CENTER);
    image(beer, 0.5, 0.5 + offset, 0.7, 0.7);
    pop();
  }
  
  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the object
   * Description: Serializes the object to JSON
   */
  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "rootBeer");
    return object;
  }
}
