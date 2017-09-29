package c4.base;

import java.awt.*;

import c4.model.Player;

/**
 * An player who knows his or her checker color.
 *
 * @author Yoonsik Cheon
 * @version $Revision: 1.1 $
 */
public class ColorPlayer extends Player {

    /** Color of this player's checkers. */
    private final Color color;

    /** Create a new player whose name and checker color are given. */
    public ColorPlayer(String name, Color color) {
        super(name);
        this.color = color;
    }

    /** Returns the color of this player's checkers. */
    public Color color() {
        return color;
    }
    
}
