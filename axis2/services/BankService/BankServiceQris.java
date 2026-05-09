package axis2.services.BankService;

public class BankServiceQris {

    public String qris(String accountId, String merchantId, String amount) {
        try {
            byte[] result = new byte[100];
            BankNativeLib.QRIS_INSTANCE.QRIS(
                    String.format("%-20s", accountId).getBytes(),
                    String.format("%-20s", merchantId).getBytes(),
                    String.format("%-20s", amount).getBytes(),
                    result);
            return new String(result).trim();
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}