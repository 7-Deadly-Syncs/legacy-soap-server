package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceBalance {

    static {
        CobLib.INSTANCE.cob_init(0, new String[0]);
    }

    public String balance(String accountId, String password) {

        try {

            byte[] result = new byte[50];


            String hashedPassword = HashUtil.sha256(password);
            
            BankNativeLib.BALANCE_INSTANCE.BALANCE(
                String.format("%-20s", accountId).getBytes(),
                String.format("%-10s", hashedPassword).getBytes(),
                result
            );

            return new String(result).trim();

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}