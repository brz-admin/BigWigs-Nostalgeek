 BigWigs Strategy Module for Thaddius in Naxxramas.

BigWigs_ThaddiusArrows is a separate module for BigWigs because it involves
strategy and tells the player directly what to do, instead of simply providing
information on what happens in the encounter.

It supports 4 strategies; Circular with both left and right as first direction
based on what debuff you get, "run through" where the raid is split in 2
groups on either side of him according to their debuff, and "four states"
where raid changes diagonals on each polarity shift.

Currently it can announce the direction to move in 3 ways:
 * Displaying huge arrows on-screen.
 * A BigWigs text message with directional text arrows like "<---", etc.
 * A female voice that says "Go right", etc.

BW_TA assumes that your raid is bunched up at the start of phase 2. After the
first Polarity Shift it will tell you which direction you should move based on
the selected strategy.

Strategies:
 * Circular R/L
 * Circular L/R
   Both strategies involve everyone in the raid rotating 90 degrees when a
   Polarity Shift occurs. If your debuff changed, you move in one direction,
   and if it didn't, you move in another.
   The only difference between these two is the starting direction based on
   debuff; R/L goes right for Positive on the first charge and left for
   Negative on the first charge and then right if you did not change and left
   if you did.

 * Run Through
   Simply running through Thaddius to your charges camp. Typically Positive
   charged people will stand on the initial tank spot and Negative charged
   people will move to his back.

 * Four States
   Imagine a square, which has + charges on the top/wall (NW, NE), - charges
   on the bottom/edge (SW, SE). Key rule is this: On each polarity change, you
   always move, and to the nearest area which matches your polarity charge.
   Movement is conducted along the sides of the square, with people grouping
   at corners. Everyone starts bottom right (SE) on the square with no
   polarity. On the first polarity charge, if you get +, you move to nearest
   + area, which is NE. If you get -, you move to the nearest - area, which is SW.
   On the second polarity charge, if you are +, you could either remain + (move
   to NW), or change to - (move to SE). If you are -, you could either remain -
   (move to SE), or change to + (move to NW). At all times you always move, and
   to the nearest +/- charge area to match your polarity, along the sides of
   the square, which itself is defined to have + on the top, and - on the
   bottom. This pattern now repeats on all subsequent polarity changes,
   always following the key rule above.

You should make *absolutely sure* that everyone uses the same tactic, or you
will wipe for sure.

