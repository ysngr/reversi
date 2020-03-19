/* reversi */

public final int BOARD_SIZE = 8;

public final int x = 1, y = 0;
public final int row = 0, clm = 1;


Model mdl;
View vw;
Control ctrl;


void setup() {
  size(1000, 1030);
  noLoop();
  initalize();
}


void initalize() {

  mdl = new Model();
  vw = new View();
  ctrl = new Control();

  return ;
}


void draw() {
  background(0);
  vw.board();
  vw.console();
}
