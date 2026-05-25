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

        BankNativeLib WITHDRAW_INSTANE = (BankNativeLib) Native.load(
                        "/app/cobol/bin/withdraw.so",
                        BankNativeLib.class);

        BankNativeLib GETBANKDETAILS_INSTANCE = (BankNativeLib) Native.load(
                        "/app/cobol/bin/getBankDetails.so",
                        BankNativeLib.class);
        BankNativeLib TRANSFER_INSTANCE = (BankNativeLib) Native.load(
                        "/app/cobol/bin/transfer.so",
                        BankNativeLib.class);
        BankNativeLib LOGIN_INSTANCE = (BankNativeLib) Native.load(
                        "/app/cobol/bin/login.so",
                        BankNativeLib.class);
        BankNativeLib LOGOUT_INSTANCE = (BankNativeLib) Native.load(
                        "/app/cobol/bin/logout.so",
                        BankNativeLib.class);

        BankNativeLib GET_ACCOUNT_PROFILE_INSTANCE = (BankNativeLib) Native.load(
                        "/app/cobol/bin/getAccountProfile.so",
                        BankNativeLib.class);

        BankNativeLib QRIS_INSTANCE = (BankNativeLib) Native.load(
                        "/app/cobol/bin/qris.so",
                        BankNativeLib.class);

        void BALANCE(
                        byte[] rekening,
                        byte[] password,
                        byte[] result);

        void REGISTER(
                        byte[] name,
                        byte[] email,
                        byte[] password,
                        byte[] pin,
                        byte[] result);

        void DEPOSIT(
                        byte[] rekening,
                        byte[] pin,
                        byte[] amount,
                        byte[] result);

        void GETBANKDETAILS(
                        byte[] email,
                        byte[] password,
                        byte[] result);

        void TRANSFER(
                        byte[] fromAccount,
                        byte[] pin,
                        byte[] toAccount,
                        byte[] amount,
                        byte[] result);

        void LOGIN(
                        byte[] email,
                        byte[] password,
                        byte[] result);

        void LOGOUT(
                        byte[] sessionId,
                        byte[] result);

        void GETACCOUNTPROFILE(
                        byte[] accountId,
                        byte[] password,
                        byte[] result);

        void QRIS(
                        byte[] accountId,
                        byte[] merchantId,
                        byte[] amount,
                        byte[] result);
}