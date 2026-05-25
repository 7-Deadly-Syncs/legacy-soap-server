package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceTransfer {

    public String transfer(
            String fromRekening,
            String pin,
            String toRekening,
            String amount) {

        byte[] result = new byte[100];

        String hashedPin =
            HashUtil.sha256(pin);

        BankNativeLib.TRANSFER_INSTANCE.TRANSFER(
            String.format("%-16s", fromRekening).getBytes(),
            String.format("%-64s", hashedPin).getBytes(),
            String.format("%-16s", toRekening).getBytes(),
            String.format("%-20s", amount).getBytes(),
            result
        );

        return new String(result).trim();
    }
}