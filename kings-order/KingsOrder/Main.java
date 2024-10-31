package KingsOrder;

import java.util.*;

public class Main {
    
    public static String findProjectOrder(int n, int m, int[] groupIds, int[][] dependencies) {
        List<List<Integer>> graph = new ArrayList<>();
        int[] inDegree = new int[n];
        
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }
        
        for (int[] dependency : dependencies) {
            int a = dependency[0] - 1;
            int b = dependency[1] - 1;
            graph.get(a).add(b);
            inDegree[b]++;
        }
        
        PriorityQueue<int[]> zeroInDegreeProjects = new PriorityQueue<>(
            Comparator.comparingInt((int[] project) -> project[0])
                      .thenComparingInt(project -> project[1])
        );
        
        for (int i = 0; i < n; i++) {
            if (inDegree[i] == 0) {
                zeroInDegreeProjects.add(new int[]{groupIds[i], i});
            }
        }
        
        List<Integer> result = new ArrayList<>();
        
        while (!zeroInDegreeProjects.isEmpty()) {
            int[] project = zeroInDegreeProjects.poll();
            int projectId = project[1];
            result.add(projectId + 1);
            
            for (int neighbor : graph.get(projectId)) {
                inDegree[neighbor]--;
                if (inDegree[neighbor] == 0) {
                    zeroInDegreeProjects.add(new int[]{groupIds[neighbor], neighbor});
                }
            }
        }
        
        if (result.size() != n) {
            return "-1";
        }
        
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < result.size(); i++) {
            if (i > 0) sb.append(" ");
            sb.append(result.get(i));
        }
        
        return sb.toString();
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        int n = scanner.nextInt();
        int m = scanner.nextInt();
        int[] groupIds = new int[n];
        for (int i = 0; i < n; i++) {
            groupIds[i] = scanner.nextInt();
        }
        
        int[][] dependencies = new int[m][2];
        for (int i = 0; i < m; i++) {
            dependencies[i][0] = scanner.nextInt();
            dependencies[i][1] = scanner.nextInt();
        }
        
        String order = findProjectOrder(n, m, groupIds, dependencies);
        System.out.println(order);
        
        scanner.close();
    }
}