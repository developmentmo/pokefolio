package app.pokefolio.account;

import app.pokefolio.account.AuthDtos.AccountDto;
import app.pokefolio.account.AuthDtos.ChangePasswordRequest;
import app.pokefolio.account.AuthDtos.DeleteAccountRequest;
import app.pokefolio.account.AuthDtos.UpdateAccountRequest;
import app.pokefolio.security.CurrentUser;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/account")
@Tag(name = "Account")
public class AccountController {

    private final AuthService authService;
    private final CurrentUser currentUser;

    public AccountController(AuthService authService, CurrentUser currentUser) {
        this.authService = authService;
        this.currentUser = currentUser;
    }

    @GetMapping
    public AccountDto get() {
        return authService.account(currentUser.id());
    }

    @PatchMapping
    public AccountDto update(@Valid @RequestBody UpdateAccountRequest request) {
        return authService.updateAccount(currentUser.id(), request.displayName(), request.preferredCurrency());
    }

    @PostMapping("/password")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void changePassword(@Valid @RequestBody ChangePasswordRequest request) {
        authService.changePassword(currentUser.id(), request.currentPassword(), request.newPassword());
    }

    @DeleteMapping
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@Valid @RequestBody DeleteAccountRequest request) {
        authService.deleteAccount(currentUser.id(), request.password());
    }
}
