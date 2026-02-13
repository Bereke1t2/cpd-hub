import sys , threading
from heapq import heapify, heappop, heappush
from functools import wraps

from math import gcd, lcm, ceil, sqrt
from functools import cmp_to_key
from operator import itemgetter
from bisect import bisect_left, bisect_right
from collections import Counter, defaultdict, deque
from itertools import combinations, permutations , accumulate

input = sys.stdin.readline

def iinp(): return (int(input()))
def linp(): return (list(map(int, input().split())))
def sinp(): return (input().strip())
def lsinp(): return (map(str, input().split()))
def minp(): return (map(int, input().split()))
def matinp(rows, cols, is_int=True):
    return [linp() if is_int else lsinp() for _ in range(rows)]

yn = lambda condition: 'YES' if condition else 'NO'
pf = lambda arr: list(accumulate(arr))

MAXN = int(1e5)
MAXM = int(2e5)

MOD = 10**9 + 7
MOD2 = 998244353
INF = float('inf')
def solve():
    n, k = minp()
    nums = linp()
    total = sum(nums)
    if total % k != 0:
        print('No')
        return
    target = total // k
    lengths = []
    if target == 0:
        if any(x != 0 for x in nums):
            print("No")
            return
        lengths = [1] * (k - 1) + [n - (k - 1)]
        print(*lengths)
        return
    curr = 0
    seg_len = 0
    for i, x in enumerate(nums):
        curr += x
        seg_len += 1
        if curr == target:
            lengths.append(seg_len)
            curr = 0
            seg_len = 0
            if len(lengths) > k:
                print("No")
                return
        elif curr > target:
            print("No")
            return
    if curr != 0 or len(lengths) != k or sum(lengths) != n:
        print("No")
    else:
        print("Yes")
        print(*lengths)


def main():
    t = 1
    # t = int(input())
    for i in range(t):
        solve()

if __name__ == "__main__":
    main()