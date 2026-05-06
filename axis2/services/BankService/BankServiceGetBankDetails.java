package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceGetBankDetails {

    static {
        CobLib.INSTANCE.cob_init(0, new String[0]);
    }

    public String getBankDetails(
            String email,
            String password) {

        try {

            byte[] result = new byte[300];

            String hashedPassword =
                HashUtil.sha256(password);

            BankNativeLib.GETBANKDETAILS_INSTANCE.GETBANKDETAILS(
                String.format("%-100s", email).getBytes(),
                String.format("%-64s", hashedPassword).getBytes(),
                result
            );

            return new String(result).trim();

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}