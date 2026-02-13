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
def get(arr, num):
    left = 0
    s = 0
    ans = INF
    for right, v in enumerate(arr):
        s += v
        while s >= num:
            ans = min(ans, right - left + 1)
            s -= arr[left]
            left += 1
    return ans

def solve():
    k = iinp()
    nums = linp() 
    inc = sum(nums)
    deld = 0
    if k > 2 * inc:
        deld = (k - 2 * inc) // inc
        k -= deld * inc  

    arr = nums * 3 
    curr = get(arr, k)
    ans = deld * len(nums) + curr
    print(ans)


   
def main():
    t = 1
    t = int(input())
    for i in range(t):
        solve()

if __name__ == "__main__":
    main()