package axis2.services.BankService;

// This is the wrapper
// I seperated the functions to make it easier to debug
// I think its the right move, probably

public class BankService {

    private BankServiceBalance balanceService =
        new BankServiceBalance();

    private BankServiceRegister registerService =
        new BankServiceRegister();

    public String balance(String acc, String pin) {
        return balanceService.balance(acc, pin);
    }

    public String register(String name, String pin) {
        return registerService.register(name, pin);
    }
}