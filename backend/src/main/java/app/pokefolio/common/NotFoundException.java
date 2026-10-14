package app.pokefolio.common;

/** Thrown when a resource does not exist or is not owned by the current user (we never reveal which). */
public class NotFoundException extends RuntimeException {

    public NotFoundException(String message) {
        super(message);
    }
}
