MOD = 1000000000 + 99999

def main
    n = gets.to_i

    weights = gets.split.map(&:to_i).map { |w| w % MOD }
    weights.unshift(0) # Adjusting index to start from 1

    edges = []
    degrees = Array.new(n + 1, 0)
    (n - 1).times do
        u, v = gets.split.map(&:to_i)
        edges << [u, v]
        degrees[u] += 1
        degrees[v] += 1
    end

    adj = Array.new(n + 1) { [] }
    edges.each do |u, v|
        adj[u] << v
        adj[v] << u
    end

    sizes = Array.new(n + 1, 0)
    s1 = Array.new(n + 1, 0)
    s2 = Array.new(n + 1, 0)

    iterative_dfs(1, adj, sizes, s1, weights, n)

    (1..n).each do |v|
        remaining_size = n - sizes[v]
        if remaining_size >= 0 && remaining_size <= n
            s2[remaining_size] = (s2[remaining_size] + weights[v]) % MOD
        end
    end

    total_weight = weights.sum % MOD

    fact = Array.new(n + 1, 1)
    inv_fact = Array.new(n + 1, 1)
    (1..n).each { |i| fact[i] = fact[i - 1] * i % MOD }
    inv_fact[n] = mod_inverse(fact[n], MOD)
    (n - 1).downto(0) { |i| inv_fact[i] = inv_fact[i + 1] * (i + 1) % MOD }

    c_n_k = Array.new(n + 1, 0)
    (0..n).each { |k| c_n_k[k] = comb(n, k, fact, inv_fact) }

    sum_s1 = Array.new(n + 1, 0)
    c = Array.new(n + 1, 0)
    c[0] = 1
    (1..n).each do |s|
        [s, n].min.downto(1) { |k| c[k] = (c[k] + c[k - 1]) % MOD }
        s1_s = s1[s]
        if s1_s != 0
            (0..s).each { |k| sum_s1[k] = (sum_s1[k] + s1_s * c[k] % MOD) % MOD }
        end
    end

    sum_s2 = Array.new(n + 1, 0)
    c.fill(0)
    c[0] = 1
    (1..n).each do |r|
        [r, n].min.downto(1) { |k| c[k] = (c[k] + c[k - 1]) % MOD }
        s2_r = s2[r]
        if s2_r != 0
            (0..r).each { |k| sum_s2[k] = (sum_s2[k] + s2_r * c[k] % MOD) % MOD }
        end
    end

    result = []
    (1..n).each do |k|
        ans = (total_weight * c_n_k[k]) % MOD
        ans = (ans - sum_s1[k] - sum_s2[k] + 2 * MOD) % MOD
        result << ans
    end

    puts result
end

def iterative_dfs(root, adj, sizes, s1, weights, n)
    stack = [root]
    parent = Array.new(n + 1, -1)
    post_order = []

    until stack.empty?
        node = stack.pop
        post_order << node
        adj[node].each do |neighbor|
            next if neighbor == parent[node]
            parent[neighbor] = node
            stack << neighbor
        end
    end

    post_order.reverse_each do |node|
        sizes[node] = 1
        adj[node].each do |neighbor|
            next if neighbor == parent[node]
            sizes[node] += sizes[neighbor]
            s1[sizes[neighbor]] = (s1[sizes[neighbor]] + weights[node]) % MOD
        end
    end
end

def comb(n, k, fact, inv_fact)
    return 0 if k < 0 || k > n
    fact[n] * inv_fact[k] % MOD * inv_fact[n - k] % MOD
end

def mod_inverse(a, mod)
    pow(a, mod - 2, mod)
end

def pow(a, b, mod)
    res = 1
    a %= mod
    while b > 0
        res = res * a % mod if b.odd?
        a = a * a % mod
        b >>= 1
    end
    res
end

main
