	package c4.base;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import c4.model.Board;

/** The main game class including the UI and the control. */
@SuppressWarnings("serial")
public class C4Dialog extends JDialog implements BoardPanel.Game {
	
    private final static Dimension DIMENSION = new Dimension(265, 340);
    
    /** The game board. */
    private Board board;
    
    /** True if a game is not in progress; false otherwise. */
    private boolean isGameOver;
    
    /** Two players of the game. */
    private ColorPlayer[] players;
    
    /** The player who has the turn. */
    private ColorPlayer currentPlayer;

    /** To display the game board. */
    private BoardPanel boardPanel;
    
    /** To start a new game. */
    private final JButton playButton = new JButton("Play");

    /** Message bar to display various messages. */
    private JLabel msgBar = new JLabel();
    
    public C4Dialog() {
        super((JFrame) null, "Connect Four");
        setSize(DIMENSION);
        
        board = new Board();
        players = createPlayers();
        currentPlayer = players[0];
        
        configureUI();
        setLocationRelativeTo(null);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        setVisible(true);
        setResizable(false);
    }
    
    /** Create two players. */
    private ColorPlayer[] createPlayers() {
        return new ColorPlayer[] {
            new ColorPlayer("Blue", Color.BLUE), 
            new ColorPlayer("Red", Color.RED)};
    }
    
    /** Configure UI. */
    private void configureUI() {
        setLayout(new BorderLayout());
        add(makeControlPanel(), BorderLayout.NORTH);
        JPanel panel = new JPanel();
        panel.setBorder(BorderFactory.createEmptyBorder(10,20,10,20));
        panel.setLayout(new GridLayout(1,1));
        panel.add(makeBoardPanel(board));
        add(panel, BorderLayout.CENTER);
    }
    
    /**
     * Create a control panel consisting of a play button and
     * a message bar.
     */
    private JPanel makeControlPanel() {
        JPanel content = new JPanel(new BorderLayout());
        JPanel buttons = new JPanel(new FlowLayout(FlowLayout.LEFT));
        buttons.setBorder(BorderFactory.createEmptyBorder(5,15,0,0));
        buttons.add(playButton);
        playButton.setFocusPainted(false);
        playButton.addActionListener(this::playButtonClicked);
        content.add(buttons, BorderLayout.NORTH);
        msgBar.setText(currentPlayer.name() + "' turn.");
        msgBar.setBorder(BorderFactory.createEmptyBorder(5,20,0,0));
        content.add(msgBar, BorderLayout.SOUTH);
        return content;
    }
    
    /** Create a panel to display the given board. */
    private BoardPanel makeBoardPanel(Board board) {
        boardPanel = new BoardPanel(board, this);
        boardPanel.setBoardClickListener(new BoardPanel.BoardClickListener() {
            @Override
            public void slotClicked(int slot) {
                if (!isGameOver && board.isSlotOpen(slot)) {
                    makeMove(slot);
                }
            }
        });
        
        return boardPanel;
    }
    
    /** Show the given string on the message bar. */
    private void showMessage(String msg) {
        msgBar.setText(msg);
    }
    
    /** To be called when the play button is clicked. If the current game
     * is over, start a new game; otherwise, prompt the user for
     * confirmation and then proceed accordingly. */
    private void playButtonClicked(ActionEvent event) {
        if (isGameOver()) {
            startNewGame();
        } else {
            if (JOptionPane.showConfirmDialog(C4Dialog.this, 
                "Play a new game?", "Connect Four", JOptionPane.YES_NO_OPTION)
                == JOptionPane.YES_OPTION) {
                startNewGame();
            }
        }
    }    

    /** Start a new game. */
    private void startNewGame() {
        board.clear();
        isGameOver = false;
        currentPlayer = players[0];
        showMessage(currentPlayer.name() + "' turn.");
        repaint();
    }
    
    /** Return true if the game is over or no game is in progress. */
    @Override
    public boolean isGameOver() {
        return isGameOver;
    }
    
    /** Return the player who has the turn. */
    @Override
    public ColorPlayer currentPlayer() {
        return currentPlayer;
    }
    
    /** Return the opponent who doesn't have the turn. */
    @Override
    public ColorPlayer opponent() {
        return currentPlayer == players[0] ? players[1] : players[0];
    }
    
    /** Slide a checker at the specified slot for the current player. */
    private void makeMove(int slot) {
        board.dropInSlot(slot, currentPlayer());
        if (board.isWonBy(currentPlayer())) {
            markWin();
        } else if (board.isFull()) {
            markDraw();
        } else {
            changeTurn();
        }
        repaint();
    }
    
    /** End the current game by indicating the current player's win. */
    private void markWin() {
        showMessage(currentPlayer.name() + " won!");
        isGameOver = true;
    }
    
    /** End the current game by indicating a draw. */
    private void markDraw() {
        showMessage("Draw!");
        isGameOver = true;
    }
    
    /** Change the playing turn. */
    private void changeTurn() {
        currentPlayer = opponent();
        showMessage(currentPlayer.name() + "'s turn.");
    }
    
    public static void main(String[] args) {
        new C4Dialog();
    }
}
