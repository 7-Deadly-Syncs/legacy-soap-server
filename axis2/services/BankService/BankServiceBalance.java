package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceBalance {

    public String balance(
            String rekening,
            String pin) {

        byte[] result = new byte[100];

        String hashedPin =
            HashUtil.sha256(pin);

        BankNativeLib.BALANCE_INSTANCE.BALANCE(
            String.format("%-16s", rekening).getBytes(),
            String.format("%-64s", hashedPin).getBytes(),
            result
        );

        return new String(result).trim();
    }
}
