package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

var (
    graph       [][]int
    values      []int
    memo        []int
    numCities   int
)

func explore(city int, lastValue int) int {
    if memo[city] != -1 {
        return memo[city]
    }

    maxCount := 1
    for _, neighbor := range graph[city] {
        if values[neighbor] > lastValue {
            maxCount = max(maxCount, 1+explore(neighbor, values[neighbor]))
        }
    }

    memo[city] = maxCount
    return memo[city]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func main() {
    reader := bufio.NewReader(os.Stdin)
    writer := bufio.NewWriter(os.Stdout)
    defer writer.Flush()

    numCitiesStr, _ := reader.ReadString('\n')
    numCities, _ = strconv.Atoi(strings.TrimSpace(numCitiesStr))

    graph = make([][]int, numCities+1)
    values = make([]int, numCities+1)
    memo = make([]int, numCities+1)
    for i := range memo {
        memo[i] = -1
    }

    valuesStr, _ := reader.ReadString('\n')
    valuesArr := strings.Fields(valuesStr)
    for i := 1; i <= numCities; i++ {
        values[i], _ = strconv.Atoi(valuesArr[i-1])
    }

    for i := 0; i < numCities-1; i++ {
        edgeStr, _ := reader.ReadString('\n')
        edge := strings.Fields(edgeStr)
        u, _ := strconv.Atoi(edge[0])
        v, _ := strconv.Atoi(edge[1])
        graph[u] = append(graph[u], v)
        graph[v] = append(graph[v], u)
    }

    maxPath := 0
    for i := 1; i <= numCities; i++ {
        maxPath = max(maxPath, explore(i, -1))
    }

    fmt.Fprintln(writer, maxPath)
}
