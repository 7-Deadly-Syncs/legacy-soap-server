package axis2.services.BankService;

import axis2.services.utils.HashUtil;

public class BankServiceGetAccountProfile {

    public String getAccountProfile(
            String accountId,
            String password) {

        byte[] result = new byte[200];

        String hashedPassword =
            HashUtil.sha256(password);

        BankNativeLib.GET_ACCOUNT_PROFILE_INSTANCE
            .GETACCOUNTPROFILE(
                String.format("%-20s", accountId).getBytes(),
                String.format("%-64s", hashedPassword).getBytes(),
                result
            );

        return new String(result).trim();
    }
}