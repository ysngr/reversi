/* Board */

public final float SQUARE_SIZE = 125.0;
public final float DISK_SIZE = 95.0;

public final int BLACK_IDX = 0;
public final int WHITE_IDX = 1;
public final boolean BLACK = true;
public final boolean WHITE = false;
public final boolean FILL = true;
public final boolean EMPTY = false;



class Board {

  int br, bc;
  float[] squareCorner;
  float[] diskCenter;
  boolean squareState;
  boolean diskCol;


  Board(int row, int column) {
    this.br = row;
    this.bc = column;
    this.calcPositions();
    this.squareState = EMPTY;
  }


  private void calcPositions() {

    this.squareCorner = new float[2];
    this.squareCorner[x] = bc * SQUARE_SIZE;
    this.squareCorner[y] = br * SQUARE_SIZE;

    this.diskCenter = new float[2];
    this.diskCenter[x] = this.squareCorner[x] + SQUARE_SIZE / 2;
    this.diskCenter[y] = this.squareCorner[y] + SQUARE_SIZE / 2;

    return ;
  }


  public void setDisk(boolean col) {
    
    this.squareState = FILL;
    this.diskCol = col;
    
    return ;
  }


  public color boolcolToColor() {
    
    if ( this.diskCol == BLACK ) {
      return color(0, 0, 0);  // black
    } else {
      return color(255, 255, 255);  // white
    }
  }
}
