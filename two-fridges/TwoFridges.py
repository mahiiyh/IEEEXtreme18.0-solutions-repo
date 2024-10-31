def fridge_temp(N, ranges):
    best_T1, best_T2 = 101, 101

    for T1 in range(-100, 101):
        for T2 in range(T1, 101):
            valid = True
            for a, b in ranges:
                can_be_stored = (a <= T1 <= b) or (a <= T2 <= b)
                if not can_be_stored:
                    valid = False
                    break
            if valid:
                if T1 < best_T1 or (T1 == best_T1 and T2 < best_T2):
                    best_T1, best_T2 = T1, T2

    if best_T1 == 101:
        return -1, -1
    else:
        return best_T1, best_T2


def main():
    N = int(input())
    ranges = [tuple(map(int, input().split())) for _ in range(N)]

    result = fridge_temp(N, ranges)
    if result[0] == -1:
        print(-1)
    else:
        print(result[0], result[1])


if __name__ == "__main__":
    main()