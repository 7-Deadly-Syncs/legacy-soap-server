package axis2.services.BankService;

import com.sun.jna.Library;
import com.sun.jna.Native;

public interface CobLib extends Library {

    CobLib INSTANCE =
        (CobLib) Native.load(
            "cob",
            CobLib.class
        );

    void cob_init(
        int argc,
        String[] argv
    );
}