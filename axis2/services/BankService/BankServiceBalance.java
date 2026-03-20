package axis2.services.BankService;

public class BankServiceBalance {

    public String balance(String accountId, String password) {

        try {

            ProcessBuilder pb = new ProcessBuilder(
                "/app/cobol/bin/balance"
            );

            Process p = pb.start();

            var writer = new java.io.BufferedWriter(
                new java.io.OutputStreamWriter(p.getOutputStream())
            );

            writer.write(accountId);
            writer.newLine();
            writer.write(password);
            writer.newLine();
            writer.flush();
            writer.close();

            var reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(p.getInputStream())
            );

            StringBuilder output = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                output.append(line);
            }

            p.waitFor();

            return output.toString();

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}