package axis2.services.BankService;

import axis2.services.utils.HashUtil;

import java.io.BufferedWriter;
import java.io.FileWriter;

import java.security.SecureRandom;

public class BankServiceLogin {

    private static final SecureRandom random =
        new SecureRandom();

    public String login(
            String email,
            String password) {

        try {

            byte[] result = new byte[300];

            String hashedPassword =
                HashUtil.sha256(password);

            BankNativeLib.LOGIN_INSTANCE.LOGIN(
                String.format("%-100s", email).getBytes(),
                String.format("%-64s", hashedPassword).getBytes(),
                result
            );

            String response =
                new String(result).trim();

            if (!response.startsWith("OK|")) {
                return response;
            }

            String[] parts =
                response.split("\\|");

            String customerId = parts[1];
            String accountId = parts[2];
            String customerName = parts[3];

            String sessionId =
                generateSessionId();

            long expiresAt =
                (System.currentTimeMillis() / 1000L)
                + 3600;

            saveSession(
                sessionId,
                accountId,
                expiresAt
            );

            return String.format(
                "OK|%s|%s|%s|%s|%d",
                customerId,
                accountId,
                customerName,
                sessionId,
                expiresAt
            );

        } catch (Exception e) {

            return "ERROR: " + e.getMessage();
        }
    }

    private String generateSessionId() {

        byte[] bytes = new byte[16];

        random.nextBytes(bytes);

        StringBuilder sb =
            new StringBuilder("SESS-");

        for (byte b : bytes) {

            sb.append(
                String.format("%02X", b)
            );
        }

        return sb.toString();
    }

    private void saveSession(
            String sessionId,
            String accountId,
            long expiresAt)
            throws Exception {

        BufferedWriter writer =
            new BufferedWriter(
                new FileWriter(
                    "/app/data/sessions.dat",
                    true
                )
            );

        writer.write(
            sessionId
            + "|"
            + accountId
            + "|"
            + expiresAt
        );

        writer.newLine();

        writer.close();
    }
}