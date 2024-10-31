package IEEE754Emulator;
import java.util.*;
import java.nio.ByteBuffer;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int T = scanner.nextInt();
        scanner.nextLine(); // Consume the newline character

        List<String> results = new ArrayList<>();

        for (int t = 0; t < T; t++) {
            String initialHex = scanner.nextLine().trim();
            float initialValue = hexToFloat(initialHex);
            List<Float> C = new ArrayList<>();
            C.add(initialValue);

            int L = scanner.nextInt();
            scanner.nextLine(); // Consume the newline character

            List<List<Float>> LUTs = new ArrayList<>();
            for (int l = 0; l < L; l++) {
                int size = scanner.nextInt();
                List<Float> LUT = new ArrayList<>();
                for (int s = 0; s < size; s++) {
                    LUT.add(hexToFloat(scanner.next()));
                }
                LUTs.add(LUT);
                scanner.nextLine(); // Consume the newline character
            }

            int Q = scanner.nextInt();
            scanner.nextLine(); // Consume the newline character

            for (int q = 0; q < Q; q++) {
                String[] command = scanner.nextLine().trim().split(" ");
                switch (command[0]) {
                    case "L":
                        int i = Integer.parseInt(command[1]);
                        int j = Integer.parseInt(command[2]);
                        int b = Integer.parseInt(command[3]);
                        int mask = getBits(Float.floatToIntBits(C.get(0)), j, b);
                        C.add(LUTs.get(i).get(mask));
                        break;
                    case "N":
                        int ni = Integer.parseInt(command[1]);
                        int nj = Integer.parseInt(command[2]);
                        int nandResult = ~(Float.floatToIntBits(C.get(ni)) & Float.floatToIntBits(C.get(nj)));
                        nandResult &= 0xFFFFFFFF; // Ensure it's a 32-bit result
                        C.add(Float.intBitsToFloat(nandResult));
                        break;
                    case "F":
                        int fi = Integer.parseInt(command[1]);
                        int fj = Integer.parseInt(command[2]);
                        int fk = Integer.parseInt(command[3]);
                        float fmaResult = C.get(fi) * C.get(fj) + C.get(fk);
                        C.add(fmaResult);
                        break;
                    case "C":
                        String hexValue = command[1];
                        C.add(hexToFloat(hexValue));
                        break;
                }
            }

            results.add(floatToHex(C.get(C.size() - 1)));
        }

        for (String result : results) {
            System.out.println(result);
        }

        scanner.close();
    }

    private static float hexToFloat(String hex) {
        int intBits = (int) Long.parseLong(hex, 16);
        return Float.intBitsToFloat(intBits);
    }

    private static String floatToHex(float value) {
        int intBits = Float.floatToIntBits(value);
        return String.format("%08x", intBits);
    }

    private static int getBits(int value, int start, int length) {
        int mask = (1 << length) - 1;
        return (value >> start) & mask;
    }
}