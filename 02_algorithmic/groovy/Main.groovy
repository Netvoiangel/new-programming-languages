static List<Integer> sieve(int n) {
    if (n < 2) return []
    boolean[] isPrime = new boolean[n + 1]
    Arrays.fill(isPrime, true)
    isPrime[0] = false
    isPrime[1] = false

    int p = 2
    while (p * p <= n) {
        if (isPrime[p]) {
            for (int k = p * p; k <= n; k += p) {
                isPrime[k] = false
            }
        }
        p++
    }

    def out = []
    for (int i = 2; i <= n; i++) if (isPrime[i]) out << i
    return out
}

int n = (args?.length ? args[0].toInteger() : 100)
println sieve(n).join(", ")


