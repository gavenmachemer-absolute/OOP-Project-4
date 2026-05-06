class Obstacle extends Actor {
  PImage vase;

  Obstacle() {
    super(10, 0, Direction.NORTH);
    vase = loadImage("vaseMorales.png");
  }

  Action getAction() {
    return null;
  }

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "Obstacle");
    return object;
  }

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
