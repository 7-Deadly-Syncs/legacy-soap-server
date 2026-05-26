package axis2.services.BankService;

public class BankServiceQris {

    public String qris(
            String rekening,
            String merchantId,
            String amount) {

        byte[] result = new byte[100];

        BankNativeLib.QRIS_INSTANCE.QRIS(
            String.format("%-16s", rekening).getBytes(),
            String.format("%-20s", merchantId).getBytes(),
            String.format("%-20s", amount).getBytes(),
            result
        );

        return new String(result).trim();
    }
}