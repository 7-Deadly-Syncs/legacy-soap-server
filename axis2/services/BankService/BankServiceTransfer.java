package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceTransfer {

    public String transfer(
            String fromAccount,
            String pin,
            String toAccount,
            String amount) {

        try {

            byte[] result = new byte[100];

            String hashedPin =
                HashUtil.sha256(pin);

            BankNativeLib.TRANSFER_INSTANCE.TRANSFER(
                String.format("%-20s", fromAccount).getBytes(),
                String.format("%-64s", hashedPin).getBytes(),
                String.format("%-20s", toAccount).getBytes(),
                String.format("%-20s", amount).getBytes(),
                result
            );

            return new String(result).trim();

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}