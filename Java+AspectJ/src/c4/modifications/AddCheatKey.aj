package c4.modifications;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.util.ArrayList;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.InputMap;
import javax.swing.JComponent;
import javax.swing.KeyStroke;
import c4.base.BoardPanel;
import c4.base.ColorPlayer;
import c4.base.BoardPanel.Game;
import c4.model.*;
import c4.model.Board.Place;

public privileged aspect AddCheatKey{
	private List<Place> Board.almostWinningRow = new ArrayList<>();
    public Iterable<Place> Board.almostWinningRow(){
        return almostWinningRow;
    }
    public boolean Board.hasAlmostWinningRow(){
        return !almostWinningRow.isEmpty();
    }
	public boolean Board.isAlmostWonBy(Player player){
		for (int i = 0; i < NUM_OF_SLOTS; i++) {
			for (int j = 0; j < SLOT_HEIGHT; j++) {
				boolean won = isAlmostWonBy(i, j, 1, 0, player); // horizontal
				won = won || isAlmostWonBy(i, j, 0, 1, player);  // vertical
				won = won || isAlmostWonBy(i, j, 1, 1, player);  // diagonal(\)
				won = won || isAlmostWonBy(i, j, 1, -1, player); // diagonal(/)
				if (won) {
					return won;
				}
			}
		}
		return false;
	}
	private boolean Board.isAlmostWonBy(int x, int y, int dx, int dy, Player player) {
		final int FOUR = 3;
		final int[] row = new int[FOUR]; // winning row, encoded: x*100 + y

		// check and expand to the left/below of (x, y)
		int cnt = 0;
		int sx = x; // start x
		int sy = y; // start y
		while (!(dx > 0 && sx < 0) && !(dx < 0 && sx >= NUM_OF_SLOTS) 
				&& !(dy > 0 && sy < 0) && !(dy < 0 && sy >= SLOT_HEIGHT) 
				&& isOccupiedBy(sx, sy, player) && cnt < FOUR) {
			row[cnt++] = sx * 100 + sy; // encode: x * 100 + y
			sx = sx - dx;
			sy = sy - dy;
		}

		// check and expand to the right/above of (x, y)
		int ex = x + dx; // end x
		int ey = y + dy; // end y
		while (!(dx > 0 && ex >= NUM_OF_SLOTS) && !(dx < 0 && ex < 0) 
				&& !(dy > 0 && ey >= SLOT_HEIGHT) && !(dy < 0 && ey < 0) 
				&& isOccupiedBy(ex, ey, player) && cnt < FOUR) {
			row[cnt++] = ex * 100 + ey; // encode: x * 100 + y
			ex = ex + dx;
			ey = ey + dy;
		}
		if (cnt >= FOUR) {
			for (int xy: row) {
				almostWinningRow.add(new Place(xy / 100, xy % 100));
			}
		}
		return cnt >= FOUR;
	}
	public void BoardPanel.drawHintRow(Graphics g){
        if (board.hasAlmostWinningRow()){
            for (Place p: board.almostWinningRow()) {
                ColorPlayer player = (ColorPlayer) board.playerAt(p.x, p.y);
                if(player.name()=="Red")
                	drawChecker(g, Color.PINK, p.x, p.y, true);
                else
                	drawChecker(g, Color.CYAN, p.x, p.y, true);
            }
        }
	}
	
	pointcut panel (BoardPanel board): target(board) && initialization(BoardPanel.new(Board, Game));
	before(BoardPanel board) : panel(board){
		ActionMap actionMap = board.getActionMap();
		int condition = JComponent.WHEN_IN_FOCUSED_WINDOW;
		InputMap inputMap = board.getInputMap(condition);
		String cheat = "Cheat";
		inputMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0), cheat);
		actionMap.put(cheat, new KeyAction(board, cheat));
	}

	boolean isF5Pressed = false;
//	Graphics temp;
//	pointcut highlight(Graphics g): execution(void *(Graphics)) && args(g);
//	void around(Graphics g):highlight(g){
//		temp = g;
//	}
	
	@SuppressWarnings("serial")
	private class KeyAction extends AbstractAction {
		private final BoardPanel boardPanel;
		
		public KeyAction(BoardPanel boardPanel, String command) {
			this.boardPanel = boardPanel;
			putValue(ACTION_COMMAND_KEY, command);
		}
		

		/** Called when a cheat is requested. */
		public void actionPerformed(ActionEvent event) {
			System.out.println("F5 pressed");
			if(isF5Pressed){
				isF5Pressed = false;
//				this.boardPanel.drawHintRow(temp);
			}
			else{
				isF5Pressed = true;
			}
		}
	}
	
//	pointcut highlight(Graphics g): execution(void BoardPanel.drawPlacedCheckers(Graphics)) && args(g);
//	void around(Graphics g):within(AddCheatKey) && highlight(g){
//		Board temp = BoardPanel.getBoard();
//        if (BoardPanel.getBoard.hasAlmostWinningRow()){
//            for (Place p: BoardPanel.board.hasAlmostWinningRow()) {
//                ColorPlayer player = (ColorPlayer) BoardPanel.board.playerAt(p.x, p.y);
//                if(player.name()=="Red")
//                	BoardPanel.drawChecker(g, Color.PINK, p.x, p.y, true);
//                else
//                	BoardPanel.drawChecker(g, Color.CYAN, p.x, p.y, true);
//            }
//        }
//	}
}