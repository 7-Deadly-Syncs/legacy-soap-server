package axis2.services.BankService;

// This is the wrapper
// I seperated the functions to make it easier to debug
// I think its the right move, probably

public class BankService {
        private BankServiceGetBankDetails getBankDetailsService = new BankServiceGetBankDetails();

        private BankServiceBalance balanceService = new BankServiceBalance();

        private BankServiceRegister registerService = new BankServiceRegister();

        private BankServiceDeposit depositService = new BankServiceDeposit();

        private BankServiceTransfer transferService = new BankServiceTransfer();

        private BankServiceLogout logoutService = new BankServiceLogout();

        private BankServiceLogin loginService = new BankServiceLogin();

        private BankServiceGetAccountProfile getAccountProfileService = new BankServiceGetAccountProfile();

        private BankServiceQris qrisService = new BankServiceQris();

        public String balance(String acc, String pin) {
                CobLib.INSTANCE.cob_init(0, new String[0]);
                return balanceService.balance(acc, pin);
        }

        public String register(String name, String email, String password, String pin) {

                CobLib.INSTANCE.cob_init(0, new String[0]);
                return registerService.register(
                                name,
                                email,
                                password,
                                pin);
        }

        public String deposit(String acc, String pin, String amount) {
                CobLib.INSTANCE.cob_init(0, new String[0]);
                return depositService.deposit(
                                acc,
                                pin,
                                amount);
        }

        public String getBankDetails(
                        String email,
                        String password) {
                CobLib.INSTANCE.cob_init(0, new String[0]);
                return getBankDetailsService
                                .getBankDetails(
                                                email,
                                                password);
        }

        public String transfer(
                        String fromAccount,
                        String pin,
                        String toAccount,
                        String amount) {
                CobLib.INSTANCE.cob_init(0, new String[0]);
                return transferService.transfer(
                                fromAccount,
                                pin,
                                toAccount,
                                amount);
        }

        public String login(
                        String email,
                        String password) {
                CobLib.INSTANCE.cob_init(0, new String[0]);
                return loginService.login(
                                email,
                                password);
        }

        public String logout(
                        String sessionId) {
                CobLib.INSTANCE.cob_init(0, new String[0]);
                return logoutService.logout(
                                sessionId);
        }

        public String getAccountProfile(
                        String accountId) {
                CobLib.INSTANCE.cob_init(0, new String[0]);
                return getAccountProfileService
                                .getAccountProfile(accountId);
        }

        public String qris(String accountId, String merchantId, String amount) {
                CobLib.INSTANCE.cob_init(0, new String[0]);
                return qrisService.qris(accountId, merchantId, amount);
        }
}