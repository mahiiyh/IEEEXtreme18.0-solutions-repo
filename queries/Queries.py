class FenwickTree:
    def __init__(self, n):
        self.data = [0] * (n + 1)

    def update(self, idx, delta):
        while idx < len(self.data):
            self.data[idx] += delta
            idx += idx & -idx

    def query(self, idx):
        sum = 0
        while idx > 0:
            sum += self.data[idx]
            idx -= idx & -idx
        return sum

    def range_query(self, l, r):
        return self.query(r) - self.query(l - 1)


def main():
    import sys
    input = sys.stdin.read
    data = input().split()

    idx = 0
    N = int(data[idx])
    idx += 1
    Q = int(data[idx])
    idx += 1

    P = [0] * (N + 1)
    for i in range(1, N + 1):
        P[i] = int(data[idx])
        idx += 1

    fenwick_tree = FenwickTree(N)
    A = [0] * (N + 1)

    while Q > 0:
        Q -= 1
        T = int(data[idx])
        idx += 1
        l = int(data[idx])
        idx += 1
        r = int(data[idx])
        idx += 1

        if T == 0:
            c = int(data[idx])
            idx += 1
            for i in range(l, r + 1):
                A[i] += c
                fenwick_tree.update(i, c)
        elif T == 1:
            c = int(data[idx])
            idx += 1
            for i in range(l, r + 1):
                A[P[i]] += c
                fenwick_tree.update(P[i], c)
        elif T == 2:
            print(fenwick_tree.range_query(l, r))
        elif T == 3:
            sum = 0
            for i in range(l, r + 1):
                sum += A[P[i]]
            print(sum)


if __name__ == "__main__":
    main()
