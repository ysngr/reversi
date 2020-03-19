/* Control */
class Control {

  
  Control() {
  }


  public int[] getIndex(float mx, float my) {

    int[] idx = {INIT_VALUE, INIT_VALUE};

    for ( int r = 0; r < BOARD_SIZE; r++ ) {
      if ( r * SQUARE_SIZE <= my && my < (r + 1) * SQUARE_SIZE ) {
        idx[row] = r;
        break;
      }
    }

    for ( int c = 0; c < BOARD_SIZE; c++ ) {
      if ( c * SQUARE_SIZE <= mx && mx < (c + 1) * SQUARE_SIZE ) {
        idx[clm] = c;
        break;
      }
    }

    return idx;
  }


  public void selPutRedraw(int[] idx) {

    if ( mdl.isSameAsSelSqrIdx(idx) ) {
      mdl.setDisks(idx);
      mdl.setSelSqrIdx();
      mdl.setMessage();
    } else if ( mdl.canSetDisk(idx, NO_STACK) ) {
      mdl.setSelSqrIdx(idx);
      mdl.setMessage(idx, INDEX);
    } else { 
      mdl.setSelSqrIdx();
      mdl.setMessage(idx, ERRMSG);
    }
    redraw();

    return ;
  }
}



void mouseClicked() {

  int[] idx = ctrl.getIndex(mouseX, mouseY);
  if ( ! mdl.isValidIndex(idx) ) {
    return ;
  }
  ctrl.selPutRedraw(idx);

  return ;
}


void keyPressed() {

  if ( key != ENTER ) {
    return ;
  }

  if ( mdl.isGameFinished() ) {
    mdl.permuteDisks();
    redraw();
  }

  int[] idx = mdl.getSelSqrIdx();
  if ( mdl.isValidIndex(idx) ) {
    ctrl.selPutRedraw(idx);
  }

  return ;
}
