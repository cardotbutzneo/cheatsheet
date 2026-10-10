## Data structures in Python ##

Unlike C, Python already ships with powerful built-in data structures (`list`, `tuple`, `dict`, `set`) and a standard library module `collections` with more.
There are no pointers, but every variable is a reference to an object, so we can build linked structures with classes.

**Built-in structures**

| Structure | Syntax | Ordered | Mutable | Duplicates |
|:----------|:-------|:--------|:--------|:-----------|
| list      | `[1, 2, 3]` | yes | yes | yes |
| tuple     | `(1, 2, 3)` | yes | no  | yes |
| set       | `{1, 2, 3}` | no  | yes | no  |
| frozenset | `frozenset({1, 2})` | no | no | no |
| dict      | `{"a": 1}` | yes (insertion order, since Python 3.7) | yes | unique keys |

~~~python
point = (3, 4)            # tuple: fixed, can be used as a dict key
x, y = point              # unpacking

unique = set([1, 2, 2, 3])   # {1, 2, 3}
unique.add(4)
print(2 in unique)           # True, O(1) on average

ages = {"Bob": 25, "Alice": 31}
ages["John"] = 42
print(ages.get("Zoe", 0))    # 0 (no KeyError)
~~~

---

**List (dynamic array)**

A Python list is a dynamic array: elements are stored contiguously (as references), and the array grows automatically.

- Access `arr[i]`: O(1)
- `.append(x)`: O(1) amortized
- `.pop()` (last element): O(1)
- `.insert(i, x)` and `.pop(i)`: O(n), because elements must be shifted
- `x in arr`: O(n)

Because of that, a list is a bad choice when you often remove from the front (use a `deque` instead).

---

**Linked list**

A linked list is a sequence of nodes. Each node contains some data and a reference to the next node.

~~~python
class Node:
    def __init__(self, data, next=None):
        self.data = data
        self.next = next
~~~

The last node usually has `next = None` (the equivalent of `NULL`).

[Data | next] -> [Data | next] -> [Data | None]

~~~python
class LinkedList:
    def __init__(self):
        self.head = None

    def push_front(self, data):
        self.head = Node(data, self.head)      # O(1)

    def __iter__(self):
        current = self.head
        while current is not None:
            yield current.data
            current = current.next

lst = LinkedList()
for value in (10, 20, 30):
    lst.push_front(value)
print(list(lst))   # [30, 20, 10]
~~~

Accessing the nth element requires traversing the list, so it is O(n).
In practice, Python programmers rarely write linked lists: `list` and `deque` are faster in most cases (better memory locality, implemented in C).
A linked list is mostly useful for learning, interviews, or when you need O(1) insertion in the middle while already holding a reference to a node.

---

**Stack**

A stack is a LIFO (Last In, First Out) structure.
In Python, a plain `list` is a perfectly good stack:

~~~python
stack = []
stack.append(10)    # push
stack.append(20)
stack.append(30)

top = stack[-1]     # peek -> 30
print(stack.pop())  # 30
print(stack)        # [10, 20]
~~~

Top of the stack = end of the list.

[10] -> [20] -> [30]
                  ↑ top

Both `append` and `pop` are O(1).
Use cases: function calls (the call stack), undo operations, expression evaluation, depth-first search.

---

**Queue**

A queue is a FIFO (First In, First Out) structure.
Do **not** use `list.pop(0)`: it is O(n). Use `collections.deque` (double-ended queue), which has O(1) operations at both ends.

~~~python
from collections import deque

queue = deque()
queue.append(10)       # enqueue
queue.append(20)
queue.append(30)

print(queue.popleft()) # dequeue -> 10
print(queue)           # deque([20, 30])
~~~

A `deque` can also be used as a stack, or as a sliding window with `deque(maxlen=n)`.
Use cases: task scheduling, breadth-first search, buffering.

Note: the module `queue` (`queue.Queue`) also exists, but it is designed for communication between threads (it has locking, which makes it slower).

---

**Heap / priority queue**

A heap is a binary tree stored in a list where the smallest element is always at index 0 (min-heap).
The module `heapq` provides the functions:

~~~python
import heapq

heap = []
heapq.heappush(heap, 5)
heapq.heappush(heap, 1)
heapq.heappush(heap, 3)

print(heapq.heappop(heap))   # 1 (smallest first)
print(heap[0])               # 3 (peek)
~~~

- `heappush` / `heappop`: O(log n)
- peek `heap[0]`: O(1)
- `heapq.heapify(list)`: O(n)

For a max-heap, store negative values. For priorities, store tuples: `(priority, item)`.
Use cases: Dijkstra, schedulers, "top k" problems (`heapq.nlargest`).

---

**Binary tree**

A binary tree is a tree in which each node has at most two children: a left child and a right child.

~~~python
class TreeNode:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None
~~~

For example:

        10
       /  \
      5    20
     / \     \
    2   7     30

A binary tree is not necessarily sorted.

**Binary Search Tree (BST)**

In a BST:

- values smaller than the current node are stored in the left subtree;
- values greater than the current node are stored in the right subtree.

~~~python
def insert(node, data):
    if node is None:
        return TreeNode(data)
    if data < node.data:
        node.left = insert(node.left, data)
    elif data > node.data:
        node.right = insert(node.right, data)
    return node

def search(node, data):
    while node is not None:
        if data == node.data:
            return True
        node = node.left if data < node.data else node.right
    return False

root = None
for v in (10, 5, 20, 2, 7, 30):
    root = insert(root, v)
print(search(root, 7))   # True
~~~

To search for 7:

7 < 10  -> go left
7 > 5   -> go right
7 found

When the tree is reasonably balanced, search, insertion and deletion are O(log n).
However, a normal BST can become unbalanced (for example if we insert already sorted values):

10
  \
   20
     \
      30
        \
         40

In this case, performance degrades to O(n).
Careful: recursive functions are limited by Python's recursion limit (1000 by default), so a degenerate tree with many nodes can raise a `RecursionError`.

**In-order traversal** of a BST gives the values in sorted order:

~~~python
def inorder(node):
    if node:
        yield from inorder(node.left)
        yield node.data
        yield from inorder(node.right)

print(list(inorder(root)))   # [2, 5, 7, 10, 20, 30]
~~~

---

**AVL tree**

An AVL tree is a self-balancing BST. Each node stores its height:

~~~python
class AVLNode:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None
        self.height = 1
~~~

An AVL tree maintains the following property for every node:

|height(left subtree) - height(right subtree)| <= 1

When an insertion or deletion breaks this property, the tree performs rotations to restore the balance.

     30                20
    /                 /  \
  20       ->       10    30
 /
10

This is a right rotation:

~~~python
def height(node):
    return node.height if node else 0

def rotate_right(y):
    x = y.left
    y.left = x.right
    x.right = y
    y.height = 1 + max(height(y.left), height(y.right))
    x.height = 1 + max(height(x.left), height(x.right))
    return x          # new root of this subtree
~~~

Search, insertion and deletion are O(log n) in the worst case.
Python has no balanced tree in its standard library. In practice, use `sorted` + `bisect` for static data, or the third-party library `sortedcontainers` (`SortedList`, `SortedDict`).

---

**Hash table**

A hash table stores and retrieves values using a key.
The idea is to use a hash function to convert a key into an index in an array.

In Python, hash tables are built in: `dict` and `set` are both hash tables.

~~~python
ages = {"Bob": 25, "Alice": 31, "John": 42}
print(ages["Bob"])      # 25, O(1) on average
~~~

Internally:

hash("Bob")   -> some integer -> index in an internal array
hash("Alice") -> another integer -> another index

This allows us to find a value very quickly instead of searching through every element.
In a well-designed hash table, insertion, deletion and lookup are O(1) on average.

**Hash function**

The built-in `hash()` returns an integer:

~~~python
print(hash(42))        # 42
print(hash("Alice"))   # different at each run!
~~~

The hash of a `str` is randomized at each Python process (security feature, can be fixed with `PYTHONHASHSEED`), so never rely on its value or on the order it would give.

A simple hash function, equivalent to the C version:

~~~python
def my_hash(key: str) -> int:
    result = 0
    for char in key:
        result = result * 31 + ord(char)
    return result

index = my_hash("Alice") % 10    # table_size = 10
~~~

**Hashable objects**

To be used as a dict key or a set element, an object must be *hashable*: it must have a stable hash, so it must be immutable (or at least never change its hash).

~~~python
d = {}
d[(1, 2)] = "ok"       # tuple: OK
d[[1, 2]] = "error"    # TypeError: unhashable type: 'list'
~~~

- Hashable: `int`, `float`, `str`, `bool`, `tuple` (if its content is hashable), `frozenset`
- Not hashable: `list`, `dict`, `set`

For your own classes, define `__eq__` and `__hash__` together (two objects that are equal must have the same hash).

**Collision**

Two different keys can produce the same index.

hash("Alice") % 10 -> 6
hash("Bob")   % 10 -> 6

A hash table needs a way to handle collisions. There are two common approaches.

**Separate chaining**

Each position of the array contains a linked list (or a list) of entries.

Index 0 -> None
Index 1 -> None
Index 2 -> [Bob, 25] -> [Alice, 31]
Index 3 -> [John, 42]

A possible implementation:

~~~python
class HashTable:
    def __init__(self, size=8):
        self.size = size
        self.buckets = [[] for _ in range(size)]   # list of buckets
        self.count = 0

    def _index(self, key):
        return hash(key) % self.size

    def put(self, key, value):
        bucket = self.buckets[self._index(key)]
        for i, (k, _) in enumerate(bucket):
            if k == key:
                bucket[i] = (key, value)    # update
                return
        bucket.append((key, value))
        self.count += 1

    def get(self, key, default=None):
        for k, v in self.buckets[self._index(key)]:
            if k == key:
                return v
        return default

table = HashTable()
table.put("Bob", 25)
table.put("Alice", 31)
print(table.get("Bob"))   # 25
~~~

**Open addressing**

All entries are stored directly inside the array. If a position is already occupied, the table looks for another free position.

hash("Alice") -> 3
index 3 is occupied
        ↓
try index 4
        ↓
index 4 is free
        ↓
store Alice at index 4

Ways to choose the next position: linear probing, quadratic probing, double hashing.

With linear probing:

index
  3 -> occupied
  4 -> occupied
  5 -> free

So the element is stored at index 5.

CPython's `dict` and `set` use open addressing (with a pseudo-random probing sequence, not plain linear probing).
Since Python 3.6, a dict stores its entries in a compact array in insertion order, plus a sparse index array: this is why dicts keep insertion order and use less memory.

**Load factor**

A hash table should not become too full.

load factor = number of elements / table size

10 elements
20 slots

load factor = 10 / 20 = 0.5

When the load factor becomes too high, collisions become more frequent and the table becomes slower.
The table is then resized:

small table
     ↓
too many elements
     ↓
create a bigger table
     ↓
rehash all elements
     ↓
new table

This operation is called rehashing. CPython does it automatically when a dict is about two-thirds full.

**Complexity**

| Operation | Average | Worst case |
|:----------|:--------|:-----------|
| Search    | O(1)    | O(n)       |
| Insert    | O(1) amortized | O(n) |
| Delete    | O(1)    | O(n)       |

The worst case happens when many keys collide. The quality of the hash function and the way collisions are handled have a major impact on performance.

**Useful dict-like structures (module `collections`)**

~~~python
from collections import defaultdict, Counter

# defaultdict: automatic default value
groups = defaultdict(list)
groups["a"].append(1)          # no KeyError

# Counter: counting occurrences
c = Counter("abracadabra")
print(c.most_common(2))        # [('a', 5), ('b', 2)]
~~~

Use cases: dictionaries, caches (`functools.lru_cache`), symbol tables, counting occurrences, grouping, removing duplicates (`set`), fast membership tests.

A `set` is a hash table that only stores keys:

~~~python
usernames = {"Alice", "Bob", "John"}
print("Alice" in usernames)     # True, O(1) on average

a, b = {1, 2, 3}, {2, 3, 4}
print(a | b)    # union        {1, 2, 3, 4}
print(a & b)    # intersection {2, 3}
print(a - b)    # difference   {1}
~~~

---

**Structured data: tuple, namedtuple, dataclass**

To group fields (the equivalent of a C `struct`):

~~~python
from collections import namedtuple
from dataclasses import dataclass

Point = namedtuple("Point", ["x", "y"])      # immutable
p = Point(3, 4)
print(p.x, p[1])                             # 3 4

@dataclass
class Player:                                # mutable, with __init__/__repr__ generated
    name: str
    score: int = 0

player = Player("Alice", 2300)
player.score += 100
~~~

---

**Sorted data and binary search (module `bisect`)**

On a sorted list, `bisect` finds a position in O(log n):

~~~python
import bisect

data = [2, 5, 7, 10, 20, 30]
i = bisect.bisect_left(data, 7)    # 2
bisect.insort(data, 8)             # insertion keeps the list sorted (O(n) because of shifting)
~~~

---

**Complexity summary**

| Structure | Access | Search | Insert | Delete |
|:----------|:-------|:-------|:-------|:-------|
| list | O(1) | O(n) | O(1) at the end, O(n) elsewhere | O(1) at the end, O(n) elsewhere |
| deque | O(n) in the middle | O(n) | O(1) at both ends | O(1) at both ends |
| linked list | O(n) | O(n) | O(1) at the head | O(1) at the head |
| dict / set | - | O(1) avg | O(1) avg | O(1) avg |
| sorted list + bisect | O(1) | O(log n) | O(n) | O(n) |
| BST (balanced) | - | O(log n) | O(log n) | O(log n) |
| heap (`heapq`) | O(1) min | O(n) | O(log n) | O(log n) |

**Important idea**

A hash table trades some memory for very fast access.

Compared with a list, a sorted list or a balanced tree:

| Structure | Property |
|:----------|:---------|
| list | simple, compact, O(n) search |
| sorted list | O(log n) search, but insertion can be expensive |
| BST | O(log n) if balanced |
| dict / set | O(1) average lookup |

Since Python 3.7, a dict remembers insertion order, but it is not sorted by key.
If you need to iterate in sorted order, use `sorted(d)`, or a structure like `SortedDict` from `sortedcontainers`.

**Which one should I use?**

- Ordered collection, access by index: `list`
- Fixed, immutable group of values: `tuple`
- Fast lookup by key: `dict`
- Uniqueness, fast membership test, set operations: `set`
- Stack: `list`
- Queue: `collections.deque`
- Priority queue: `heapq`
- Counting: `collections.Counter`
- Always sorted data: `bisect` or `sortedcontainers`