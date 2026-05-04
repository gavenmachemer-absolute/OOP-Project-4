/**
 *      Author: Ethan Rutkowski
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-05-04
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Enemy.pde
 * Description: basic enemy actor
 */
 
 class Goblin extends Actor {
  /**
   * Constructor: public Goblin()
   *  Parameters: Direction facing - The direction the enemy starts facing
   * Description: constructs an enemy
   */
   
   public Goblin(Direction facing) {
     super(40, 8, facing);
   }
   
  /**
   *      Method: public serialize()
   *  Parameters: void
   *      Return: JSONObject - A JSON serialization of the enemy
   * Description: Serializes the enemy to JSON
   */
   
   public JSONObject serialize() {
     JSONObject object = super.serialize();
     object.setString("className", "Goblin");
     return object;
   }
   
  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the enemy and shows which direction it is facing
   */

  public void draw() {
    //draw health bar from extended actor class
    super.draw();
    
    //draw body of enemy
    push();
    fill(40, 160, 40);
    stroke(0);
    ellipse(0.5, 0.6, 0.6, 0.6);
    pop();
    
    push();
    fill(255);
    ellipse(.5, .6, .6, .6);
    
    switch (this.facing) {
    case NORTH:
      triangle(0.5, 0.25, 0.35, 0.50, 0.65, 0.50);
      break;

    case SOUTH:
      triangle(0.5, 0.90, 0.35, 0.65, 0.65, 0.65);
      break;

    case EAST:
      triangle(0.85, 0.60, 0.60, 0.45, 0.60, 0.75);
      break;

    case WEST:
      triangle(0.15, 0.60, 0.40, 0.45, 0.40, 0.75);
      break;
    }
    
    pop();
  }
  

  /**
   *      Method: public getAction()
   *  Parameters: void
   *      Return: Action - The selected action
   * Description: Attacks when possible; otherwise moves randomly but only validly
   */
   
   public Action getAction() {
     
     // first priority: attack if possible
     if (this.getActionValidity(Action.ATTACK_NORTH)) {
       this.facing = Direction.NORTH;
       return Action.ATTACK_NORTH;
     }
     
     if (this.getActionValidity(Action.ATTACK_SOUTH)) {
       this.facing = Direction.SOUTH;
       return Action.ATTACK_SOUTH;
     }
     
     if (this.getActionValidity(Action.ATTACK_EAST)) {
       this.facing = Direction.EAST;
       return Action.ATTACK_EAST;
     }
     
     if (this.getActionValidity(Action.ATTACK_WEST)) {
       this.facing = Direction.WEST;
       return Action.ATTACK_WEST;
     }
     
    //second pirority: move forward
    if (this.facing == Direction.NORTH && this.getActionValidity(Action.MOVE_NORTH) && random(1) < 0.6) {
      return Action.MOVE_NORTH;
    }

    if (this.facing == Direction.SOUTH && this.getActionValidity(Action.MOVE_SOUTH) && random(1) < 0.6) {
      return Action.MOVE_SOUTH;
    }

    if (this.facing == Direction.EAST && this.getActionValidity(Action.MOVE_EAST) && random(1) < 0.6) {
      return Action.MOVE_EAST;
    }

    if (this.facing == Direction.WEST && this.getActionValidity(Action.MOVE_WEST) && random(1) < 0.6) {
      return Action.MOVE_WEST;
    }
    
    //fallback: if movement is blocked, randomly attampt valid moves
    Action[] moves = {
      Action.MOVE_NORTH,
      Action.MOVE_SOUTH,
      Action.MOVE_EAST,
      Action.MOVE_WEST
    };
    
    int start = int(random(moves.length));
    
    for (int i = 0; i > moves.length; i++) {
      Action action = moves[(start+1) % moves.length];
      
      if (this.getActionValidity(action)) {
        this.facing = action.direction;
        return action;
      }
    }
    
    // none valid, trapped or otherwise
    
    return null;
  }
}
