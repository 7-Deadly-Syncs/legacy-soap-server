package axis2.services.BankService;

// This is the wrapper
// I seperated the functions to make it easier to debug
// I think its the right move, probably

public class BankService {
    private BankServiceGetBankDetails getBankDetailsService = new BankServiceGetBankDetails();

    private BankServiceBalance balanceService = new BankServiceBalance();

    private BankServiceRegister registerService = new BankServiceRegister();

    private BankServiceDeposit depositService = new BankServiceDeposit();

    private BankServiceTransfer transferService = new BankServiceTransfer();

    public String balance(String acc, String pin) {
        return balanceService.balance(acc, pin);
    }

    private BankServiceLogin loginService = new BankServiceLogin();

    public String register(String name, String email, String password, String pin) {

        return registerService.register(
                name,
                email,
                password,
                pin);
    }

    public String deposit(String acc, String pin, String amount) {

        return depositService.deposit(
                acc,
                pin,
                amount);
    }

    public String getBankDetails(
            String email,
            String password) {

        return getBankDetailsService
                .getBankDetails(
                        email,
                        password);
    }

    public String transfer(
            String fromAccount,
            String pin,
            String toAccount,
            String amount) {

        return transferService.transfer(
                fromAccount,
                pin,
                toAccount,
                amount);
    }

    public String login(
            String email,
            String password) {

        return loginService.login(
                email,
                password);
    }
}