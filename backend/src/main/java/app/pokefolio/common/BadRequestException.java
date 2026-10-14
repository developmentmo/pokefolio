package app.pokefolio.common;

/** Thrown for semantically invalid input that Bean Validation cannot express. */
public class BadRequestException extends RuntimeException {

    public BadRequestException(String message) {
        super(message);
    }
}
