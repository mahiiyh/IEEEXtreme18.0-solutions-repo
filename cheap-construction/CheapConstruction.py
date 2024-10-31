import sys

def build_suffix_array(s):
    n = len(s)
    sa = list(range(n))
    r = list(map(ord, s))
    nr = [0] * n

    k = 1
    while k < n:
        def comp(x, y):
            if r[x] != r[y]:
                return r[x] < r[y]
            rx = r[x + k] if x + k < n else -1
            ry = r[y + k] if y + k < n else -1
            return rx < ry

        sa.sort(key=lambda x: (r[x], r[x + k] if x + k < n else -1))

        nr[sa[0]] = 0
        for i in range(1, n):
            nr[sa[i]] = nr[sa[i - 1]]
            if comp(sa[i - 1], sa[i]):
                nr[sa[i]] += 1
        r = nr[:]
        if r[sa[n - 1]] == n - 1:
            break
        k <<= 1

    return sa

def build_lcp_array(s, sa):
    n = len(s)
    r = [0] * n
    for i in range(n):
        r[sa[i]] = i
    lcp = [0] * (n - 1)
    h = 0
    for i in range(n):
        if r[i] == n - 1:
            h = 0
            continue
        j = sa[r[i] + 1]
        while i + h < n and j + h < n and s[i + h] == s[j + h]:
            h += 1
        lcp[r[i]] = h
        if h > 0:
            h -= 1
    return lcp

def main():
    input = sys.stdin.read
    s = input().strip()
    n = len(s)

    sa = build_suffix_array(s)
    lcp = build_lcp_array(s, sa)

    ans = [float('inf')] * (n + 1)

    for length in range(1, n + 1):
        i = 0
        while i < n:
            j = i
            while j < n - 1 and lcp[j] >= length:
                j += 1

            pos = [sa[k] for k in range(i, j + 1) if sa[k] + length <= n]

            if pos:
                pos.sort()
                cnt = 0
                cs, ce = -1, -1
                for p in pos:
                    s = p
                    e = p + length - 2
                    if e < s:
                        continue
                    if ce < s:
                        cnt += (e - s + 1)
                        cs, ce = s, e
                    elif e > ce:
                        cnt += (e - ce)
                        ce = e

                rem = n - cnt
                if 1 <= rem <= n:
                    ans[rem] = min(ans[rem], length)
            i = j + 1

    for k in range(1, n + 1):
        if ans[k] == float('inf'):
            ans[k] = 0
        print(ans[k], end=' ' if k < n else '\n')

if __name__ == "__main__":
    main()
