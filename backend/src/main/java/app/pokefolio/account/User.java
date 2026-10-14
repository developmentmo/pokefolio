package app.pokefolio.account;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import app.pokefolio.common.BaseEntity;
import jakarta.persistence.Version;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "users")
public class User extends BaseEntity {

    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(name = "display_name", nullable = false)
    private String displayName;

    @Column(name = "preferred_currency", nullable = false, length = 3)
    private String preferredCurrency;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Version
    private long version;

    protected User() {
    }

    public User(String email, String passwordHash, String displayName, String preferredCurrency, Instant now) {
        this.email = email;
        this.passwordHash = passwordHash;
        this.displayName = displayName;
        this.preferredCurrency = preferredCurrency;
        this.createdAt = now;
        this.updatedAt = now;
    }

    public String getEmail() {
        return email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getPreferredCurrency() {
        return preferredCurrency;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void changePassword(String newHash, Instant now) {
        this.passwordHash = newHash;
        this.updatedAt = now;
    }

    public void updateProfile(String displayName, String preferredCurrency, Instant now) {
        if (displayName != null) {
            this.displayName = displayName;
        }
        if (preferredCurrency != null) {
            this.preferredCurrency = preferredCurrency;
        }
        this.updatedAt = now;
    }
}
