package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
)

type Beam struct {
	ti    int64
	typ   byte
}

func computeTiA(direction byte, C, L int) int64 {
	if direction == 'U' {
		return 2*int64(L) + int64(L-C)
	}
	return int64(L) + int64(C)
}

func computeTiB(direction byte, C, L int) int64 {
	if direction == 'U' {
		return 2*int64(L) + int64(L-C)
	}
	return 3*int64(L) + int64(L-C)
}

func main() {
	var L, N, M int
	fmt.Scanf("%d %d %d\n", &L, &N, &M)

	beams := make([]Beam, N+M)

	scanner := bufio.NewScanner(os.Stdin)
	for i := 0; i < N; i++ {
		scanner.Scan()
		var dir byte
		var C int
		fmt.Sscanf(scanner.Text(), "%c %d", &dir, &C)
		beams[i] = Beam{computeTiA(dir, C, L), 'A'}
	}

	for i := 0; i < M; i++ {
		scanner.Scan()
		var dir byte
		var C int
		fmt.Sscanf(scanner.Text(), "%c %d", &dir, &C)
		beams[N+i] = Beam{computeTiB(dir, C, L), 'B'}
	}

	sort.Slice(beams, func(i, j int) bool {
		if beams[i].ti != beams[j].ti {
			return beams[i].ti < beams[j].ti
		}
		return beams[i].typ > beams[j].typ
	})

	totalRegions := int64(N + M + 1)
	countA, K := 0, int64(0)

	for _, beam := range beams {
		if beam.typ == 'A' {
			countA++
		} else {
			K += int64(countA)
		}
	}

	totalRegions += K
	fmt.Println(totalRegions)
}