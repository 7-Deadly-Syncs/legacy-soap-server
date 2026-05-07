package axis2.services.BankService;

public class BankServiceLogout {

    public String logout(
            String sessionId) {

        try {

            byte[] result = new byte[100];

            BankNativeLib.LOGOUT_INSTANCE.LOGOUT(
                String.format("%-100s", sessionId).getBytes(),
                result
            );

            return new String(result).trim();

        } catch (Exception e) {

            return "ERROR: " + e.getMessage();
        }
    }
}