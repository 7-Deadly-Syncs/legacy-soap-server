package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceDeposit {

    public String deposit(
            String accountId,
            String pin,
            String amount) {

        try {

            byte[] result = new byte[100];

            String hashedPin =
                HashUtil.sha256(pin);

            BankNativeLib.DEPOSIT_INSTANCE.DEPOSIT(
                String.format("%-20s", accountId).getBytes(),
                String.format("%-64s", hashedPin).getBytes(),
                String.format("%-20s", amount).getBytes(),
                result
            );

            return new String(result).trim();

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}