package axis2.services.BankService;

import com.sun.jna.Library;
import com.sun.jna.Native;

public interface BankNativeLib extends Library {

    BankNativeLib REGISTER_INSTANCE = (BankNativeLib) Native.load(
            "/app/cobol/bin/bankRegister.so",
            BankNativeLib.class);

    BankNativeLib BALANCE_INSTANCE = (BankNativeLib) Native.load(
            "/app/cobol/bin/balance.so",
            BankNativeLib.class);

    BankNativeLib DEPOSIT_INSTANCE = (BankNativeLib) Native.load(
            "/app/cobol/bin/deposit.so",
            BankNativeLib.class);

    void BALANCE(
            byte[] accountId,
            byte[] password,
            byte[] result);

    void REGISTER(
            byte[] name,
            byte[] email,
            byte[] password,
            byte[] pin,
            byte[] result);

    void DEPOSIT(
            byte[] accountId,
            byte[] password,
            byte[] amount,
            byte[] result);
}