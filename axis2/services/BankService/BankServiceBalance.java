package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceBalance {

    public String balance(
            String rekening,
            String password) {

        byte[] result = new byte[100];

        String hashedPassword =
            HashUtil.sha256(password);

        BankNativeLib.BALANCE_INSTANCE.BALANCE(
            String.format("%-16s", rekening).getBytes(),
            String.format("%-64s", hashedPassword).getBytes(),
            result
        );

        return new String(result).trim();
    }
}