static String boardString(int[] pos) {
    int n = pos.length
    def sb = new StringBuilder()
    for (int r = 0; r < n; r++) {
        int c = pos[r]
        for (int j = 1; j <= n; j++) {
            sb.append(j == c ? "Q" : ".")
            if (j < n) sb.append(" ")
        }
        sb.append("\n")
    }
    return sb.toString()
}

static Map solveNQueens(int n) {
    if (n < 1) throw new IllegalArgumentException("N must be >= 1")
    if (n > 62) throw new IllegalArgumentException("N too large for long bitmask demo (use N <= 62)")

    long all = (1L << n) - 1L
    int[] pos = new int[n]
    int[] first = null
    long[] count = [0L]

    def backtrack
    backtrack = { int row, long cols, long d1, long d2 ->
        if (row == n) {
            count[0]++
            if (first == null) first = pos.clone()
            return
        }

        long avail = all & ~(cols | d1 | d2)
        while (avail != 0L) {
            long bit = Long.lowestOneBit(avail)
            int col = Long.numberOfTrailingZeros(bit) + 1
            pos[row] = col
            backtrack(row + 1, cols | bit, (d1 | bit) << 1, (d2 | bit) >> 1)
            avail &= (avail - 1L)
        }
    }

    long t0 = System.nanoTime()
    backtrack(0, 0L, 0L, 0L)
    long t1 = System.nanoTime()

    return [count: count[0], solution: first, timeMs: (t1 - t0) / 1_000_000.0]
}

int n = (args?.length ? args[0].toInteger() : 12)
def res = solveNQueens(n)
println "N = ${n}"
println "solutions = ${res.count}"
println String.format("time_ms = %.3f", res.timeMs)
if (res.solution != null) {
    println "\none solution:"
    print boardString((int[]) res.solution)
} else {
    println "no solution"
}


