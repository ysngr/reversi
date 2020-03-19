/* Console */

public final String INIT_MESG = " ";


class Console {

  final String[] player = {"First player (BLACK)", "Second player (WHITE)"};
  private String message;
  private String finMessage;


  Console() {
    this.message = new String();
    this.message = INIT_MESG;
    this.finMessage = new String();
  }


  public String getConsole(int idx) {

    if ( this.message == INIT_MESG ) {
      return this.player[idx] + this.message;
    } else {
      return this.player[idx] + " : " + this.message;
    }
  }


  public void setFinConsole(int[] diskNums) {

    this.finMessage = "=== GAME SET ===  [BLACK : " + diskNums[BLACK_IDX] + "/ WHITE : " + diskNums[WHITE_IDX] + "]";

    return ;
  }


  public String getFinConsole() {
    return this.finMessage;
  }
}
