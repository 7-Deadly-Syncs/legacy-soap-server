package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceDeposit {

    static {
        CobLib.INSTANCE.cob_init(0, new String[0]);
    }

    public String deposit(
            String accountId,
            String password,
            String amount) {

        try {

            byte[] result = new byte[50];

            String hashedPassword =
                HashUtil.sha256(password);

            BankNativeLib.DEPOSIT_INSTANCE.DEPOSIT(
                String.format("%-20s", accountId).getBytes(),
                String.format("%-64s", hashedPassword).getBytes(),
                String.format("%-20s", amount).getBytes(),
                result
            );

            return new String(result).trim();

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}