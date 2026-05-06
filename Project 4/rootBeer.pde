class rootBeer extends Interactable {
  PImage beer;

  rootBeer() {
    beer = loadImage("beersWithMorales2029.png");
  }

  boolean interact(Player player) {
    player.updateHealth(20);
    return true;
  }

  void draw() {
    push();
    float offset = sin(frameCount * 0.1) * 0.08; //figured out how to do this sin wave from this forum https://forum.processing.org/beta/num_1266372115.html
    imageMode(CENTER);
    image(beer, 0.5, 0.5 + offset, 0.7, 0.7);
    pop();
  }

  public JSONObject serialize() {
    JSONObject object = new JSONObject();
    object.setString("className", "rootBeer");
    return object;
  }
}
