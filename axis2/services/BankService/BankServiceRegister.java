package axis2.services.BankService;

public class BankServiceRegister {

    public String register(String name, String pin) {
        try {

            ProcessBuilder pb = new ProcessBuilder(
                "/app/cobol/register",
                name,
                pin
            );

            pb.redirectErrorStream(true);

            Process process = pb.start();

            java.io.BufferedReader reader =
                new java.io.BufferedReader(
                    new java.io.InputStreamReader(process.getInputStream())
                );

            StringBuilder output = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                output.append(line);
            }

            process.waitFor();

            return output.toString();

        } catch (Exception e) {
            return "ERR|" + e.getMessage();
        }
    }
}