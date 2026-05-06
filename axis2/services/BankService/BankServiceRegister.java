package axis2.services.BankService;

public class BankServiceRegister {

    static {
    CobLib.INSTANCE.cob_init(0, new String[0]);
    }
    public String register(String name, String pin) {
        
        

        byte[] result = new byte[50];

        BankRegisterLib.INSTANCE.REGISTER(
            String.format("%-20s", name).getBytes(),
            String.format("%-10s", pin).getBytes(),
            result
        );

        return new String(result).trim();
    }
}