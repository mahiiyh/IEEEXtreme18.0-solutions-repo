MAX = 41
$memo = []
$computed = []

def main
    input = gets.strip.split.map(&:to_i)
    r1, b1, r2, b2 = input
    size = MAX * MAX * MAX * MAX * 2
    $memo = Array.new(size)
    $computed = Array.new(size, false)
    result = dfs(r1, b1, r2, b2, true)
    printf("%.10f\n", result)
end

def dfs(r1, b1, r2, b2, is_alice)
    return 0.0 if r1 == 0 || b1 == 0
    return 1.0 if r2 == 0 || b2 == 0

    index = r1 + b1 * 41 + r2 * 41 * 41 + b2 * 41 * 41 * 41 + (is_alice ? 1 : 0) * 41 * 41 * 41 * 41
    return $memo[index] if $computed[index]

    $computed[index] = true
    e00, e01, e10, e11 = 0.0, 0.0, 0.0, 0.0

    if is_alice
        e00 = dfs(r1 - 1, b1, r2, b2, false)
        e01 = dfs(r1, b1, r2, b2 - 1, false)
        e10 = dfs(r1, b1, r2 - 1, b2, false)
        e11 = dfs(r1, b1 - 1, r2, b2, false)
    else
        e00 = dfs(r1 - 1, b1, r2, b2, true)
        e01 = dfs(r1, b1, r2, b2 - 1, true)
        e10 = dfs(r1, b1, r2 - 1, b2, true)
        e11 = dfs(r1, b1 - 1, r2, b2, true)
    end

    denominator = e00 - e01 - e10 + e11
    e = if denominator.abs > 1e-9
                (e00 * e11 - e01 * e10) / denominator
            else
                e00
            end

    $memo[index] = e
    e
end

main if __FILE__ == $PROGRAM_NAME
