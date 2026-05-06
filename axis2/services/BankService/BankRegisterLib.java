package axis2.services.BankService;

import com.sun.jna.Library;
import com.sun.jna.Native;

public interface BankRegisterLib extends Library {

    BankRegisterLib INSTANCE =
        (BankRegisterLib) Native.load(
            "/app/cobol/bin/bankRegister.so",
            BankRegisterLib.class
        );

    void REGISTER(
    byte[] name,
    byte[] pin,
    byte[] result
    );
}