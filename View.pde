/* View */
class View {

  float[][] dotPoints;


  View() {
    rectMode(CORNER);
    ellipseMode(CENTER);
    textAlign(LEFT, TOP);
    textFont(createFont("Consolas", 24));
    this.initView();
  }


  void initView() {

    this.dotPoints = new float[4][2];
    for ( int i = 0; i < this.dotPoints.length; i++ ) {
      this.dotPoints[i][x] = (i % 2 == 0)? SQUARE_SIZE * 2 : SQUARE_SIZE * 6; 
      this.dotPoints[i][y] = (i <= 1 )? SQUARE_SIZE * 2 : SQUARE_SIZE * 6;
    }

    return ;
  }


  public void board() {

    // squares
    for ( int r = 0; r < BOARD_SIZE; r++ ) {
      for ( int c = 0; c < BOARD_SIZE; c++ ) {
        this.drawSquare(r, c);
        this.drawDisk(r, c);
      }
    }

    this.drawBoardElements();

    // selected square
    int[] idx = mdl.getSelSqrIdx();
    if ( mdl.isValidIndex(idx[row], idx[clm]) ) {
      this.drawSelSqrEdge(idx);
    }

    return ;
  }


  private void drawSquare(int r, int c) {

    float[] sc = mdl.getSquareCorner(r, c);
    strokeWeight(1.5);
    stroke(160, 160, 160);  // gray
    fill(25, 125, 25);  // forest green
    rect(sc[x], sc[y], SQUARE_SIZE, SQUARE_SIZE);

    return ;
  }


  private void drawDisk(int r, int c) {

    if ( mdl.getSquareState(r, c) == EMPTY ) {
      return ;
    }

    float[] dc = mdl.getDiskCenter(r, c);
    noStroke();
    fill(mdl.getDiskCol(r, c));  // black or white
    ellipse(dc[x], dc[y], DISK_SIZE, DISK_SIZE);

    return ;
  }


  private void drawBoardElements() {

    // console frame
    strokeWeight(3.0);
    stroke(200, 200, 200);  
    noFill();
    rect(0, width, width, 50);

    // dots
    noStroke();
    fill(160, 160, 160);  // gray
    for ( int i = 0; i < this.dotPoints.length; i++ ) {
      ellipse(this.dotPoints[i][x], this.dotPoints[i][y], 20, 20);
    }

    return ;
  }


  private void drawSelSqrEdge(int[] idx) {

    float[] sc = mdl.getSquareCorner(idx[row], idx[clm]);
    strokeWeight(2.0);
    stroke(125, 240, 230);  // light blue
    noFill();
    rect(sc[x], sc[y], SQUARE_SIZE, SQUARE_SIZE);

    return ;
  }


  public void console() {

    strokeWeight(2.0);
    stroke(255, 255, 255);  // white
    fill(255, 255, 255);  // white
    text(mdl.getConsole(), 10, 1005);

    return ;
  }
}
