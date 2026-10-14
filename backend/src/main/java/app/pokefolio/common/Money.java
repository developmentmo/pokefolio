package app.pokefolio.common;

import java.math.BigDecimal;
import java.math.RoundingMode;

/** Money helpers. All monetary amounts are BigDecimal with scale 2 and HALF_EVEN rounding. */
public final class Money {

    public static final int SCALE = 2;
    public static final RoundingMode ROUNDING = RoundingMode.HALF_EVEN;

    private Money() {
    }

    public static BigDecimal normalize(BigDecimal amount) {
        return amount == null ? null : amount.setScale(SCALE, ROUNDING);
    }

    public static BigDecimal zero() {
        return BigDecimal.ZERO.setScale(SCALE, ROUNDING);
    }

    public static BigDecimal orZero(BigDecimal amount) {
        return amount == null ? zero() : amount;
    }
}
