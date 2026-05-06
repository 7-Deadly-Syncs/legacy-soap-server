package axis2.services.BankService;

// This is the wrapper
// I seperated the functions to make it easier to debug
// I think its the right move, probably

public class BankService {

    private BankServiceBalance balanceService = new BankServiceBalance();

    private BankServiceRegister registerService = new BankServiceRegister();

    private BankServiceDeposit depositService = new BankServiceDeposit();

    public String balance(String acc, String pin) {
        return balanceService.balance(acc, pin);
    }

    public String register(String email, String name, String password, String pin) {
        return registerService.register(email, password, name, pin);
    }

    public String deposit(
            String acc,
            String pin,
            String amount) {

        return depositService.deposit(
                acc,
                pin,
                amount);
    }
}