package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceRegister {

    static {
        CobLib.INSTANCE.cob_init(0, new String[0]);
    }

    public String register(String name, String pin) {

        byte[] result = new byte[50];

        String hashedPin = HashUtil.sha256(pin);

        BankNativeLib.REGISTER_INSTANCE.REGISTER(
                String.format("%-20s", name).getBytes(),
                String.format("%-64s", hashedPin).getBytes(),
                result);

        return new String(result).trim();
    }
}