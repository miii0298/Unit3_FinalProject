float x = 50;
float y = 200;
float velocity = 5;
float ex = 500;
float ey = 200;
Ship player;
Ship enemy;
ArrayList<Bullet> bullets = new ArrayList();
PImage[] playerImages;
PImage[] enemyImages;
int count = 0;
Wall[] walls;
Space[] spaces;
void setup() {
  spaces = new Space[50];
  for(int i = 0; i < 50; i++){
    Space s = new Space();
    s.x = random(width);
    s.y = random(height);
    s.speed = random(1,5);
    spaces[i] = s;
  }
  size(600, 400);
  player = new Ship();
  player.x = 50;
  player.y = 200;
  enemy = new Ship();
  enemy.x = 500;
  enemy.y = 200;
  enemy.velocity = 3;
  playerImages = new PImage[]{
    loadImage("player01.png"), loadImage("player02.png")
  };
  enemyImages = new PImage[]{
    loadImage("enemy01.png"), loadImage("enemy02.png")
  };
  walls = new Wall[3];
  for (int i = 0; i < 3; i++) {
    Wall w = new Wall();
    w.x = i * 100 + 200;
    w.y = 0;
    w.velocity = random(5) + 1;
    w.size = random(height-200, height-100);
    walls[i] = w;
  }
}
int status =0;
void draw() {
  background(0);
  for(int i = 0; i < 50; i++){
    Space s = spaces[i];
    s.x -= s.speed;
    if(s.x < 0){
      s.x = width;
    }
    fill(255,255,255,s.speed / 5 * 255);
    ellipse(s.x, s.y, 3, 3);
  }
  count += 1;
  player.y += player.velocity;
  if(player.y < 0 || player.y + 50 > height){
    player.velocity *= -1;
    
  }
  if(status != 2){
  image(playerImages[count / 10 % 2], player.x, player.y, 50, 50);
  }
  enemy.y += enemy.velocity;
  if(enemy.y < 0 || enemy.y + 50 > height){
    enemy.velocity *= -1;
  }
  if(status != 1){
  image(enemyImages[count / 10 % 2], enemy.x, enemy.y, 50, 50);
  }
  int bulletCount = bullets.size();
  for (int i = 0; i < walls.length; i++) {
    Wall w = walls[i];
    w.y += w.velocity;
    if (w.y < 0 || w.y + w.size > height) {
      w.velocity *= -1;
    }
    fill(255);
    rect(w.x, w.y, 20, w.size);
  }
 bulletCount = bullets.size();
  for (int i = 0; i < bulletCount; i++) {
    Bullet bullet = bullets.get(i);
    bullet.x += bullet.velocity;
    for(int j = 0; j < walls.length; j++){
      Wall w = walls[j];
      boolean isWallHit = isHit(w.x, w.y,20,w.size,bullet.x,bullet.y,10,10);
      if(isWallHit){
        w.size *= 0.9;
        bullet.velocity *= -1;
      }
    }
    fill(255);
    boolean isPlayerHit = isHit(player.x, player.y, 50, 50,bullet.x, bullet.y, 10, 10);
    if(isPlayerHit && status == 0){
      status = 2;
    }
    boolean isHit = isHit(enemy.x, enemy.y, 50, 50, bullet.x, bullet.y, 10, 10);
    if(isHit && status == 0){
      status = 1;
    }
  ellipse(bullet.x, bullet.y, 10, 10);
  }
  if(status == 1){
    fill(0,100);
    rect(0,0,width,height);
    fill(255);
    textAlign(CENTER);
    text("GAME CLEAR!!!!!!", width / 2, height / 2);
    }
    if(status == 2){
      fill(0, 100);
      rect(0,0,width,height);
      fill(255);
      textAlign(CENTER);
      text("GAME OVER",width / 2, height / 2);
    }
}


void shot() {
 if(status == 0){
  Bullet bullet = new Bullet();
  bullet.x = player.x + 50;
  bullet.y = player.y + 25;
  bullet.velocity = 5;
  bullets.add(bullet);
  }
}

void keyPressed() {
  if (keyCode == UP) {
    player.velocity = -5;
  }
  if (keyCode == DOWN) {
    player.velocity = 5;
  }
  if (key == ' ') {
    shot();
  }
}

boolean isHit(float px, float py, float pw, float ph, float ex, float ey, float ew, float eh) {

  float centerPx = px + pw / 2;
  float centerPy = py + ph / 2;
  float centerEx = ex + ew / 2;
  float centerEy = ey + eh / 2;
  if (abs(centerPx- centerEx) < pw / 2 + ew / 2) {
    if (abs(centerPy - centerEy) < ph / 2 + eh / 2) {
      return true;
    }
  }
  return false;
}
