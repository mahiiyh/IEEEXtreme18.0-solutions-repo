def maximize_number(N, K):
    N = list(str(N))
    length = len(N)
    
    for i in range(length):
        if K == 0:
            break
        
        max_digit = max(N[i:])
        if N[i] != max_digit:
            max_digit_index = ''.join(N).rfind(max_digit)
            N[i], N[max_digit_index] = N[max_digit_index], N[i]
            K -= 1
    
    return int(''.join(N))

N, K = map(int, input().split())

result = maximize_number(N, K)

print(result)