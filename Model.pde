/* Model */

public final int INIT_VALUE = -1;
public final boolean NO_STACK = true;
public final boolean INDEX = true;
public final boolean ERRMSG = false;


class Model {

  private boolean player;
  private Board[][] board;
  private int sp;
  private int[][] revStack;
  private int[] selSqrIdx;

  private Console console;

  private boolean finFlag;


  Model() {
    this.initModel();
  }


  private void initModel() {

    // generate board
    this.board = new Board[BOARD_SIZE][BOARD_SIZE];
    for ( int r = 0; r < BOARD_SIZE; r++ ) {
      for ( int c = 0; c < BOARD_SIZE; c++ ) {
        this.board[r][c] = new Board(r, c);
      }
    }

    // init components
    this.sp = INIT_VALUE;
    this.revStack = new int[BOARD_SIZE*4][2];
    this.selSqrIdx = new int[2];
    this.setSelSqrIdx();
    this.console = new Console();
    this.player = BLACK;  
    this.finFlag = false;

    // set initial disks
    this.board[3][3].setDisk(WHITE);
    this.board[3][4].setDisk(BLACK);
    this.board[4][3].setDisk(BLACK);
    this.board[4][4].setDisk(WHITE);

    return ;
  }


  public float[] getSquareCorner(int r, int c) {
    return this.board[r][c].squareCorner;
  }


  public float[] getDiskCenter(int r, int c) {
    return this.board[r][c].diskCenter;
  }


  public boolean getSquareState(int r, int c) {
    return this.board[r][c].squareState;
  }


  public color getDiskCol(int r, int c) {
    return this.board[r][c].boolcolToColor();
  }


  public void setSelSqrIdx() {

    this.selSqrIdx[row] = INIT_VALUE;
    this.selSqrIdx[clm] = INIT_VALUE;

    return ;
  }

  public void setSelSqrIdx(int r, int c) {

    this.selSqrIdx[row] = r;
    this.selSqrIdx[clm] = c;

    return ;
  }

  public void setSelSqrIdx(int[] idx) {

    if ( idx.length == 2 ) {
      this.setSelSqrIdx(idx[row], idx[clm]);
    }

    return ;
  }


  public int[] getSelSqrIdx() {
    return this.selSqrIdx;
  }


  public void setMessage() {
    
    this.console.message = INIT_MESG;
    
    return ;
  }

  public void setMessage(String msg) {
    
    this.console.message = msg;
    
    return ;
  }

  public void setMessage(int[] idx, boolean idxOrErr) {

    if ( idxOrErr == INDEX ) {
      this.console.message = this.getANIdx(idx) + " is selected.";
    } else {
      this.console.message = "Cannot set there (" + this.getANIdx(idx) + ")";
    }

    return ;
  }
  
  
  public void setFinConsole(int[] diskNums) {
    
    this.console.setFinConsole(diskNums);
    
    return ;
  }


  public String getConsole() {
    
    if ( this.finFlag ) {
      return this.console.getFinConsole();
    } else {
      return this.console.getConsole(this.boolcolToInt(this.player));
    }
  }


  public boolean isGameFinished() {
    return this.finFlag;
  }


  public String getANIdx(int[] idx) {
    return intToChar(idx[clm]) + str(idx[row] + 1);
  }


  private char intToChar(int idx) {

    char rowAlpha = 'A';
    for ( int i = 0; i < idx; i++ ) {
      rowAlpha++;
    }

    return rowAlpha;
  }


  private int boolcolToInt(boolean col) {

    if ( col == BLACK ) {
      return BLACK_IDX;
    } else {
      return WHITE_IDX;
    }
  }


  public boolean isSameAsSelSqrIdx(int r, int c) {

    if ( r == this.selSqrIdx[row] && c == this.selSqrIdx[clm] ) {
      return true;
    }

    return false;
  }

  public boolean isSameAsSelSqrIdx(int[] idx) {

    if ( idx.length != 2 ) {
      return false;
    } else {
      return this.isSameAsSelSqrIdx(idx[row], idx[clm]);
    }
  }


  public boolean isValidIndex(int r, int c) {

    if ( r < 0 || BOARD_SIZE <= r || c < 0 || BOARD_SIZE <= c ) {
      return false;
    } else {
      return true;
    }
  }

  public boolean isValidIndex(int[] idx) {

    if ( idx.length != 2 ) {
      return false;
    } else {
      return this.isValidIndex(idx[row], idx[clm]);
    }
  }


  public void setDisks(int r, int c) {

    if ( this.canSetDisk(r, c) ) {
      this.reverseDisks();

      for ( int skip = 0; skip < 2; skip++ ) {
        this.player = ! this.player;  // change player
        if ( isTherePlaceToSet() ) {
          return ;
        }
      }

      // both player cannot set next disk
      this.finishTheGame();
    }

    return ;
  }
  
  public void setDisks(int[] idx) {
    
    if ( idx.length == 2 ) {
      this.setDisks(idx[row], idx[clm]);
    }
    
    return ;
  }


  public boolean canSetDisk(int r, int c) {

    int idxr, idxc;
    int replSp;

    if ( this.board[r][c].squareState == FILL ) {
      this.sp = INIT_VALUE;
      return false;
    }
    // set disk
    this.sp++;
    this.revStack[this.sp][row] = r;
    this.revStack[this.sp][clm] = c;

    // find disks which are reversed
    for ( int vr = -1; vr <= 1; vr++ ) {
      for ( int vc = -1; vc <= 1; vc++ ) {
        if ( vr == 0 && vc == 0 ) {
          continue;
        }
        idxr = r;
        idxc = c;
        replSp = this.sp;

        // liner search
        while ( true ) {
          idxr += vr;
          idxc += vc;
          if ( ! isValidIndex(idxr, idxc) || this.board[idxr][idxc].squareState == EMPTY ) {
            // discard pushed elements in this search
            this.sp = replSp;
            break;
          }
          if ( this.board[idxr][idxc].diskCol == this.player ) {
            break;
          }
          // push
          this.sp++;
          revStack[this.sp][row] = idxr;
          revStack[this.sp][clm] = idxc;
        }
      }
    }

    if ( this.sp > 0 ) {
      return true;
    } else {
      return false;
    }
  }
  
  public boolean canSetDisk(int[] idx) {
    
    if ( idx.length != 2 ) {
      return false;
    }
    
    return this.canSetDisk(idx[row], idx[clm]);
  }
  
  public boolean canSetDisk(int r, int c, boolean flag) {

    if ( flag != NO_STACK ) {
      return this.canSetDisk(r, c);
    }

    if ( this.board[r][c].squareState == FILL ) {
      return false;
    }

    int idxr, idxc;

    // find disks which are reversed
    for ( int vr = -1; vr <= 1; vr++ ) {
      for ( int vc = -1; vc <= 1; vc++ ) {
        if ( vr == 0 && vc == 0 ) {
          continue;
        }

        idxr = r;
        idxc = c;
        for ( int dst = 1;; dst++ ) { 
          idxr += vr;
          idxc += vc;
          if ( ! isValidIndex(idxr, idxc) || this.board[idxr][idxc].squareState == EMPTY ) {
            break;
          }
          if ( this.board[idxr][idxc].diskCol == this.player ) {
            if ( dst > 1 ) {
              return true;
            } else {
              break;
            }
          }
        }
      }
    }

    return false;
  }
  
  public boolean canSetDisk(int[] idx, boolean flag) {
    
    if ( idx.length != 2 ) {
      return false;
    }
    
    return this.canSetDisk(idx[row], idx[clm], flag);
  }


  private void reverseDisks() {

    for ( int i = 0; i <= this.sp; i++ ) {
      this.board[this.revStack[i][row]][this.revStack[i][clm]].setDisk(this.player);
    }
    this.sp = INIT_VALUE;

    return ;
  }


  private boolean isTherePlaceToSet() {

    for ( int r = 0; r < BOARD_SIZE; r++ ) {
      for ( int c = 0; c < BOARD_SIZE; c++ ) {
        if ( this.board[r][c].squareState == FILL ) {
          continue;
        }
        if ( this.canSetDisk(r, c, NO_STACK) ) {
          return true;
        }
      }
    }

    return false;
  }


  private void finishTheGame() {

    for ( int r = 0; r < BOARD_SIZE; r++ ) {
      for ( int c = 0; c < BOARD_SIZE; c++ ) {
        this.board[r][c].squareState = FILL;
      }
    }

    this.finFlag = true;
    this.setFinConsole(this.calcDiskNums());

    return ;
  }


  private int[] calcDiskNums() {

    int[] diskNums = {0, 0};
    
    for ( int r = 0; r < BOARD_SIZE; r++ ) {
      for ( int c = 0; c < BOARD_SIZE; c++ ) {
        if ( this.board[r][c].diskCol == BLACK ) {
          diskNums[BLACK_IDX]++;
        } else {
          diskNums[WHITE_IDX]++;
        }
      }
    }

    return diskNums;
  }


  public void permuteDisks() {

    int[] diskNums = this.calcDiskNums();

    int blk = 0, wht = 0;
    for ( int r = 0; r < BOARD_SIZE; r++ ) {
      for ( int c = 0; c < BOARD_SIZE; c++ ) {
        if ( blk++ < diskNums[BLACK_IDX] ) {
          this.board[r][c].diskCol = BLACK;
        } else if ( wht++ < diskNums[WHITE_IDX] ) {
          this.board[r][c].diskCol = WHITE;
        } else {
          this.board[r][c].squareState = EMPTY;
        }
      }
    }

    return ;
  }
}
