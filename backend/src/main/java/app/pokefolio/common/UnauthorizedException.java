package app.pokefolio.common;

/** Thrown for failed authentication (bad credentials, invalid or expired tokens). */
public class UnauthorizedException extends RuntimeException {

    public UnauthorizedException(String message) {
        super(message);
    }
}
