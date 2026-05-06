class Obstacle extends WorldObject{
  PImage vase;
  
  Obstacle(){
    vase = loadImage("vaseMorales.png");
  }
  
  
  public JSONObject serialize(){
    JSONObject object = new JSONObject();
    object.setString("className", "Obstacle");
    return object;
  }
  
  void draw(){
    push();
    image(vase, 0, 0, 1, 1);
    pop();
  }
    
}
