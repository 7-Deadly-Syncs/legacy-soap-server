package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceRegister {

    public String register(
            String name,
            String email,
            String password,
            String pin) {

        byte[] result = new byte[100];

        String hashedPassword =
            HashUtil.sha256(password);

        String hashedPin =
            HashUtil.sha256(pin);

        BankNativeLib.REGISTER_INSTANCE.REGISTER(
            String.format("%-50s", name).getBytes(),
            String.format("%-100s", email).getBytes(),
            String.format("%-64s", hashedPassword).getBytes(),
            String.format("%-64s", hashedPin).getBytes(),
            result
        );

        return new String(result).trim();
    }
}