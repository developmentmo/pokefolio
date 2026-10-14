package app.pokefolio.common;

/** Thrown when a request is valid but conflicts with the current state (e.g. selling an already sold copy). */
public class ConflictException extends RuntimeException {

    public ConflictException(String message) {
        super(message);
    }
}
