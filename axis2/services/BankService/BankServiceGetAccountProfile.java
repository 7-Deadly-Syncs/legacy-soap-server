package axis2.services.BankService;

public class BankServiceGetAccountProfile {

    public String getAccountProfile(
            String accountId) {

        byte[] result = new byte[200];

        BankNativeLib.GET_ACCOUNT_PROFILE_INSTANCE
            .GETACCOUNTPROFILE(
                String.format(
                    "%-20s",
                    accountId
                ).getBytes(),
                result
            );

        return new String(result).trim();
    }
}