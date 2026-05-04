/**
 *      Author: Prof. Morales
 *      Course: CPSC 220
 *  Instructor: Prof. Morales
 *     Created: 2026-04-15
 *         Due: 2026-05-10
 *  Assignment: Project 4
 *        File: Scene.pde
 * Description: The game scene that handles each room
 *              and all objects within those rooms,
 *              including the player and enemies
 */

import java.util.LinkedList;

class Scene {
  private int roomWidth;
  private int roomHeight;
  private WorldObject[][] room;
  private Direction entry;
  private Player player;
  private LinkedList<Actor> enemies;
  private HashMap<WorldObject, Position> positions;
  private HashMap<Direction, Position> doors;
  Position[][] positionArray;    //array to create a cell for every position index; so world Objects can later be put into it


  //scene constructor used WHEN NO JSON FILE IS BEING LOADED FROM
  Scene(){
    roomWidth = 10 + int(random(6));
    roomHeight = 8 + int(random(6));
    
    room = new WorldObject[roomWidth][roomHeight];
    enemies = new LinkedList<Actor>();
    positions = new HashMap<WorldObject, Position>();
    doors = new HashMap<Direction, Position>();
    
    //entry needs to = the direction the player was facing when they entered the door
    entry = Direction.SOUTH; //temp, needs to be changed
    player = new Player(entry);
    positionArray = new Position[roomWidth][roomHeight]; //array to create a cell for every position index; so world Objects can later be put into it
    
    reset(entry);
  }
  
  
  
  //scene constructor used WHEN LOADING FROM A JSON FILE
  Scene(JSONObject object){
    this.roomWidth = object.getInt("roomWidth");
    this.roomHeight = object.getInt("roomHeight");
    
    //need to finish setting the info in here so that when scene is constructed from a JSON it has the data it needs
  }
  
  
  
  //sets everything INSIDE A JSON OBJECT THAT CAN LATER BE LOADED
  JSONObject serialize(){
    JSONObject object = new JSONObject();
    object.setInt("roomWidth", this.roomWidth);
    object.setInt("roomHeight", this.roomHeight);
    
    
    
    //how do you set these arrays up to save data when the size of the array will be random because of the room generation
    
    //when making array of arrays you have to construct new jsonarrays for every row of arrays
    //make a 2d array to store what data is on what tile/square (enemy, player, obstacle, interactable, null)
    //need to serialize everything in the room HERE
    return object;
    
  }


  /**
   *      Method: private reset()
   *  Parameters: Direction entry - The direction from which
   *                                the player entered the room
   *      Return: void
   * Description: Resets the room to a random state
   */


  private void reset(Direction entry) {
    if (entry == null) {
      return;
    }
    
    positions.clear();
    
    //array creates the room logically (used for collision and other functions); currently fills it with null (add an algorythym that determines where to put obstacles)
    for( int i = 0; i < roomHeight; i++){
      
      for( int q = 0; q < roomWidth; q++){    
        room[q][i] = null;   
        positionArray[q][i] = new Position(q, i, this);   //array essentialy creates a map of the room (used for tracking positions so objects know where to be drawn)
      }
      
    }
    
    
    //this is where you can put obstacles and interactables into the hashmap now that all positions have been created
    room[int(roomWidth / 2)][int(roomHeight / 2)] = player; //temp, maybe make it so player starts by whatever door they came through
    positions.put(player,  positionArray[int(roomWidth / 2)][int(roomHeight / 2)] );  //everytime you set the player or anything elses position in room you HAVE TO SET the position in the position hashmap immediately after

  }

  /**
   *      Method: private updateActions()
   *  Parameters: Actor actor - The actor whose actions will be
   *                            updated to reflect their validity
   *      Return: void
   * Description: Updates an actor's list of valid actions
   */

  private void updateActions(Actor actor) {
    for (Action action : Action.values()) {
      actor.setActionValidity(action, this.isActionValid(actor, action));
    }
  }

  /**
   *      Method: public tryTurn()
   *  Parameters: void
   *      Return: boolean - Whether or not the state of
   *                        the scene should be saved
   * Description: Tries to execute a single turn of game
   *              logic for the player and all enemies
   */

  public boolean tryTurn() {
    // If the player is dead, reset the room
    if (this.player == null || this.player.getHealth() == 0) {
      Direction[] directions = Direction.values();
      Direction direction = directions[int(random(directions.length))];
      this.player = new Player(direction);
      this.reset(direction);
    }

    // Get the player's action
    this.updateActions(this.player); //trying to make actions update before checking what action is being made, same one used in the enemies check action
    Action action = this.player.getAction();

    // If no action was chosen, do nothing
    if (action == null) {
      return false;
    }

    // If the player attacked or entered a new room, save the game
    Position door = this.doors.get(action.direction);
    boolean save = action.isAttack || door != null && door.equals(this.positions.get(this.player)) && this.enemies.size() == 0;

    // If the action failed, do nothing
    if (!this.tryAction(this.player, action)) {
      return false;
    }

    for (int i = 0; i < this.enemies.size(); ++i) {
      Actor enemy = this.enemies.get(i);

      // Remove dead enemies
      if (enemy.getHealth() == 0) {
        this.enemies.remove(i--);
        continue;
      }

      // Get the enemy's action
      this.updateActions(enemy);
      action = enemy.getAction();

      if (this.tryAction(enemy, action) && action.isAttack) {
        // If the player died, reset the room and save the game
        if (player.getHealth() == 0) {
          Direction[] directions = Direction.values();
          Direction direction = directions[int(random(directions.length))];
          this.player = new Player(direction);
          this.reset(direction);
          return true;
        }

        // If the enemy attacked, save the game
        save = true;
      }
    }

    this.updateActions(this.player);
    return save;
  }

  /**
   *      Method: private tryAction()
   *  Parameters: Actor  actor  - The actor performing the action
   *              Action action - The action being performed
   *      Return: boolean - Whether or not the action succeeded
   * Description: Tries to execute an action on behalf of an actor
   */

  private boolean tryAction(Actor actor, Action action) {
    if (!isActionValid(actor, action)) {
      return false;
    }

    Position position = this.positions.get(actor);

    if (position == null) {
      return false;
    }

    // Get the position of the cell being targeted
    int x = position.getX() + action.direction.x;
    int y = position.getY() + action.direction.y;

    // Check if the player can enter a new room
    if (!action.isAttack && actor == this.player && action.direction != this.entry.inverse() && this.enemies.size() == 0) {
      Position door = this.doors.get(action.direction);

      if (door != null && door.equals(position)) {
        this.reset(action.direction);
        return true;
      }
    }

    // Check if the actor is facing a wall
    if (x < 0 || x >= this.roomWidth || y < 0 || y >= this.roomHeight) {
      return false;
    }

    // Check if the actor can attack
    if (action.isAttack) {
      boolean isActionValid = this.room[x][y] instanceof Actor && (actor == this.player || this.room[x][y] == this.player);

      if (isActionValid) {
        Actor enemy = (Actor)this.room[x][y];

        if (enemy.getHealth() > 0) {
          enemy.updateHealth(-actor.getDamage());
        } else {
          this.room[x][y] = null;
          this.positions.remove(enemy); //if the enemy dies remove it from the positions map
        }
      }

      return isActionValid;
    }

    // Check if the actor can interact with an interactable object
    if (actor == this.player && this.room[x][y] instanceof Interactable) {
      Interactable interactable = (Interactable)this.room[x][y];

      if (!interactable.interact(this.player)) {
        return false;
      }
    } else if (this.room[x][y] != null) {
      return false;
    }

    // Check if the actor can move
    this.room[x][y] = actor;
    this.room[position.getX()][position.getY()] = null;
    position.move(action.direction);
    return true;
  }

  /**
   *      Method: private isActionValid()
   *  Parameters: Actor  actor  - The actor performing the action
   *              Action action - The action being performed
   *      Return: boolean - Whether or not the action is valid
   * Description: Determines if an actor's action would be valid
   */

  private boolean isActionValid(Actor actor, Action action) {
    if (actor == null || action == null || actor.getHealth() == 0) {
      return false;
    }

    Position position = this.positions.get(actor);

    if (position == null) {
      return false;
    }

    // Get the position of the cell being targeted
    int x = position.getX() + action.direction.x;
    int y = position.getY() + action.direction.y;

    // Check if the player can enter a new room
    if (!action.isAttack && actor == this.player && action.direction != this.entry.inverse() && this.enemies.size() == 0) {
      Position door = this.doors.get(action.direction);

      if (door != null && door.equals(position)) {
        return true;
      }
    }

    // Check if the actor is facing a wall
    if (x < 0 || x >= this.roomWidth || y < 0 || y >= this.roomHeight) {
      return false;
    }

    // Check if the actor can attack
    if (action.isAttack) {
      return this.room[x][y] instanceof Actor && (actor == this.player || this.room[x][y] == this.player);
    }

    // Check if the actor can move
    return this.room[x][y] == null || this.room[x][y] instanceof Interactable && actor == this.player;
  }

  /**
   *      Method: public getRoomWidth()
   *  Parameters: void
   *      Return: int - The width of the room, in number of columns
   * Description: Returns the width of the room
   */

  public int getRoomWidth() {
    return roomWidth;
  }

  /**
   *      Method: public getRoomHeight()
   *  Parameters: void
   *      Return: int - The height of the room, in number of rows
   * Description: Returns the height of the room
   */

  public int getRoomHeight() {
    return roomHeight;
  }

  /**
   *      Method: public keyPressed()
   *  Parameters: void
   *      Return: void
   * Description: Passes key press events to the player
   */

  public void keyPressed() {
    if (key == 'p'){
      print(positions.get(player).getX() + "," + positions.get(player).getY() + " ");
    }
    if (this.player != null) {
      this.player.keyPressed();
    }
  }

  /**
   *      Method: public keyReleased()
   *  Parameters: void
   *      Return: void
   * Description: Passes key release events to the player
   */

  public void keyReleased() {
    if (this.player != null) {
      this.player.keyReleased();
    }
  }

  /**
   *      Method: public draw()
   *  Parameters: void
   *      Return: void
   * Description: Draws the scene
   */

  public void draw() {
    
    // Determine the floor size
    float size = min((float)width / (this.roomWidth + 2), (float)height / (this.roomHeight + 2));
    
    translate( (width - roomWidth * size) * 0.5, (height - roomHeight * size) * 0.5 ); 
    push();
    fill(255);
    stroke(0);
    for(int i = 0; i < roomHeight; i++){
      
      for(int q = 0; q < roomWidth; q++){
        square( q * size, i * size, size);
      }
      
    }
    pop();
    
    //by scaling by size you are essentially making everything one to one
    scale(size);
    
  
    for (WorldObject obj : positions.keySet()) {  //trying to loop through every world object room to get their position and then translate them to the correct position visually

      if (positions.get(obj) != null) {
        push();
        translate(positions.get(obj).getX(), positions.get(obj).getY());
        obj.draw();
        pop();
      }
    }
   
  }
}


//whats left to do:
//1. add logic to spawn obstacles into the scene
//2. add logic to spawn enemies into the scene
//3. add logic to spawn interactables into the scene
//4. finish the JSON constructor and serialize function
//5. make doors
//6. figure out the how to make you enter the same direction you were facing
