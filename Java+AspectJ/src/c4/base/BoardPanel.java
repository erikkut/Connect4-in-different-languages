package c4.base;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;

import c4.model.Board;
import c4.model.Board.Place;

/**
 * A special panel class to display a connect-four grid modeled by the
 * {@link c4.model.Board} class.
 * 
 * @see c4.model.Board
 * @author Yoonsik Cheon
 */
@SuppressWarnings("serial")
public class BoardPanel extends JPanel {

    /** Provided interface to notify an occurrence of a click event 
     * on a board panel. */
    public interface BoardClickListener {
        
        /** Called when an open slot (column) of a board is clicked.
         * The 0-based index of the clicked slot is provided
         * as an argument. */
        void slotClicked(int slot);
    }
    
    /** Required interface to obtain the current game status. */
    public interface Game {
    	
        /** Is the game over? */
        boolean isGameOver();
        
        /** Return the player who has the turn. */
        ColorPlayer currentPlayer();
        
        /** Return the player who hasn't the turn. */
        ColorPlayer opponent();
    }
         
    /** Width and height of a place in pixels. */
    private final int placeSize = 30;

    /** Background color of the board. */
    private final Color boardColor = new Color(245, 184, 0);

    /** Color to draw an empty place. */
    private final Color placeColor = Color.WHITE;
    
    /** Color to highlight the checkers (discs) of the winning row. */
    private final Color winColor = Color.WHITE;
    
    /** The listener observing this board panel. */
    private BoardClickListener listener;

    /** Used to obtain the game status. */
    private final Game game;

    /** Game board. */
    private final Board board;

    /** Number of slots (width) of the board. */
    private final int numOfSlots;
    
    /** Number of rows (height) of the board. */
    private final int slotHeight;
        
    /** Constant denoting an invalid slot index. */
    private static final int NO_SLOT = -1;
    
    /** Index of the slot currently being pressed. */
    private int slotPressed = NO_SLOT;
    
    /** Create a new board panel to display the given board of
     * the given game. */
    public BoardPanel(final Board board, Game game) {
        this.board = board;
        this.game = game;
        slotHeight = board.slotHeight();
        numOfSlots = board.numOfSlots();
        addMouseListener(mouseAdapter);
    }
    
    /** Register the given listener to be notified for board 
     * clicking events. */
    public void setBoardClickListener(BoardClickListener listener) {
        this.listener = listener;
    }

    /** Handle a mouse event by repainting this panel or
     * or, if an open slot is clicked, reporting it to the listener. */
    private final MouseAdapter mouseAdapter = new MouseAdapter() {
        public void mousePressed(MouseEvent e) {
            if (!game.isGameOver()) {
                int slot = locateSlot(e.getX(), e.getY());
                if (slot >= 0 && board.isSlotOpen(slot)) {
                    slotPressed = slot;
                    repaint();
                }
            }
        }
        
        public void mouseReleased(MouseEvent e) {
            if (!game.isGameOver()) {
                slotPressed = NO_SLOT;
                repaint();                    
            }                
        }
        
        public void mouseClicked(MouseEvent e) {
            if (!game.isGameOver()) {
                int slot = locateSlot(e.getX(), e.getY());
                if (slot >= 0 && board.isSlotOpen(slot)) {
                    // report a slot clicking event
                    listener.slotClicked(slot);
                }
            }
        }        
    };

    /**
     * Given a screen coordinate, determine the index of the corresponding
     * slot (column) of the board; return NO_SLOT if it doesn't belong
     * to any slot.
     */
    private int locateSlot(int x, int y) {
        final int radius = (placeSize - 4) / 2;
        final int cy = radius + 2;
        for (int i = 0; i < numOfSlots; i++) {
            int cx = (i * placeSize) + 2 + radius;
            if (isIn(x, y, cx, cy, radius)) {
                return i;
            }
        }
        return NO_SLOT;
    }
         
    /** Overridden here to draw the board along with checkers
     *  (discs) dropped. */
    @Override
    public void paint(Graphics g) {
        super.paint(g); // clear the background
        drawGrid(g);
        drawDroppableCheckers(g);
        drawPlacedCheckers(g);
    }

    /** Draw the board grid. */ 
    private void drawGrid(Graphics g) {
        g.setColor(boardColor);
        g.fillRect(0, placeSize, placeSize * numOfSlots, 
                placeSize * slotHeight);
        for (int i = 0; i < numOfSlots; i++) {
            for (int j = 0; j <= slotHeight; j++) {
                drawChecker(g, placeColor, i, j - 1);
            }
        }
    }
    
    /** Draw the current player's drop-able checkers above the grid.
     * A user clicks these checkers to drop them into the corresponding
     * slots. */
    private void drawDroppableCheckers(Graphics g) {
        if (!game.isGameOver()) {
            Color color = game.currentPlayer().color();
            for (int i = 0; i < numOfSlots; i++) {
                if (board.isSlotOpen(i)) {
                    int margin = 2;
                    if (slotPressed == i) {
                        // animate a pressed checker
                        margin = margin * 2;
                    }
                    drawChecker(g, color, i, -1, margin);
                }
            }
        }
    }
    
    /** 
     * Draw checkers dropped (placed) in the grid. 
     * Checkers are displayed as filled circles. 
     * The last dropped checker, if exists, is highlighted.
     * If there is a winning row, their checkers are highlighted.
     */
    private void drawPlacedCheckers(Graphics g) {
        for (int i = 0; i < numOfSlots; i++) {
            for (int j = 0; j < slotHeight; j++) {
                ColorPlayer player = (ColorPlayer) board.playerAt(i, j);
                if (player != null) {
                    drawChecker(g, player.color(), i, j);
                }
            }
        }
        
        if (board.hasWinningRow()) {
            for (Place p: board.winningRow()) {
                ColorPlayer player = (ColorPlayer) board.playerAt(p.x, p.y);
                drawChecker(g, player.color(), p.x, p.y, true);
            }
        }
    }
    
    /** Draw a checker at the specified place in the given color. */
    private void drawChecker(Graphics g, Color color, int slot, int y) {
        drawChecker(g, color, slot, y, false);
    }
    
    /** Draw a checker at the specified place in the given color. */
    private void drawChecker(Graphics g, Color color, int slot, int y,
            boolean highlighted) {
        drawChecker(g, color, slot, y, 2);
        if (highlighted) {
            drawChecker(g, winColor, slot, y, 10);            
        }
    }
    
    /** Draw a checker at the specified place using the given margin. */
    private void drawChecker(Graphics g, Color color, 
            int slot, int y, int margin) {
        g.setColor(color); 
        int xx = slot * placeSize + margin;
        int yy = (y + 1) * placeSize + margin;
        g.fillOval(xx, yy, placeSize - margin * 2 , placeSize - margin * 2);
    }
        
    /** 
     * Return true if a given point (x, y) is inside a circle
     * specified by its center (cX, cY) and radius.
     */
    public static boolean isIn(int x, int y, int cX, int cY, int r) {
       int dx = x - cX;
       int dy = y - cY;
       return dx * dx + dy * dy <= r * r;
    }

}
