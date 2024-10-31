def calculate_union_area(N, K, L):
    single_square_area = (2 * L) * (2 * L)

    if K > 2 * L:
        return N * single_square_area

    total_area = N * single_square_area

    overlap_width = 2 * L - K
    overlap_area = overlap_width * overlap_width
    total_overlap_area = (N - 1) * overlap_area
    return total_area - total_overlap_area

N, K, L = map(int, input().split())
print(calculate_union_area(N, K, L))