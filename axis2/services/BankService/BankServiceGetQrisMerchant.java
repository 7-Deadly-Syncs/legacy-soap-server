package axis2.services.BankService;

public class BankServiceGetQrisMerchant {
    public String getQrisMerchant(String merchantId) {
        try {
            byte[] result = new byte[300];
            BankNativeLib.GETQRISMERCHANT_INSTANCE.GETQRISMERCHANT(
                String.format("%-20s", merchantId).getBytes(),
                result
            );
            return new String(result).trim();
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}