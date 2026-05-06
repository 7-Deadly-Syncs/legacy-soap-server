package axis2.services.BankService;

public class BankServiceBalance {

    static {
        CobLib.INSTANCE.cob_init(0, new String[0]);
    }

    public String balance(String accountId, String password) {

        try {

            byte[] result = new byte[50];

            BankNativeLib.BALANCE_INSTANCE.BALANCE(
                String.format("%-20s", accountId).getBytes(),
                String.format("%-10s", password).getBytes(),
                result
            );

            return new String(result).trim();

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}