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
    # n = iinp()
    n , m = minp()
    nums1 = linp()
    nums2 = linp()
    ans = 0
    heap = []
    seen = set()
    nums = [(nums2[i], nums1[i]) for i in range(n)]
    nums.sort(reverse=True)
    # print(nums)
    for num2 , num1 in nums:
        if num1 not in seen:
            seen.add(num1)
            continue
        heappush(heap, num2)
    rem = m - len(seen)
    # print(heap)
    while rem:
        ans += heappop(heap)
        rem -= 1
    print(ans)

def main():
    t = 1
    # t = int(input())
    for i in range(t):
        solve()

if __name__ == "__main__":
    main()