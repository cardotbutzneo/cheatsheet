## Complex data structures ##

C structures can be combined with pointers to create more complex data structures such as linked lists, stacks, queues, and trees.

**Linked list**  
A linked list is a sequence of nodes. Each node contains some data and a pointer to the next node.
```C
typedef struct _node {
    [type] data;
    struct _node *next;
} Node;
```
The next pointer points to the next node in the list.

The last node usually has next = NULL.

For example:

[Data | next] -> [Data | next] -> [Data | NULL]

A linked list is useful when you need a dynamic collection of elements and frequently insert or remove elements.

However, unlike an array, accessing the nth element requires traversing the list from the beginning, so access is O(n).

---
**Stack**


A stack is a LIFO (Last In, First Out) data structure: the last element inserted is the first one removed.

A stack can be implemented using a linked list:
```C
typedef struct {
    Node *head;
} Stack;
```
The head points to the top of the stack.
The two main operations are:
- push → add an element to the top of the stack.
- pop → remove the element from the top of the stack.

Example:

push(10)


push(20)


push(30)

Top
 ↓
[30] -> [20] -> [10] -> NULL

pop() -> 30


A stack can be used for things such as function calls, undo operations, expression evaluation, and depth-first search.

---
**Queue**

A queue is a FIFO (First In, First Out) data structure: the first element inserted is the first one removed.

A queue can be implemented using a linked list:
```C
typedef struct {
    Node *head;
    Node *tail;
} Queue;
```
The head points to the first element, while tail points to the last element.

The two main operations are:

- enqueue → add an element to the end of the queue.
- dequeue → remove an element from the front of the queue.

enqueue(10)


enqueue(20)


enqueue(30)

head                    tail
 ↓                        ↓
[10] -> [20] -> [30] -> NULL

dequeue() -> 10


Keeping both a head and a tail pointer allows insertion at the end and removal from the beginning in O(1) time.

Queues are useful for task scheduling, breadth-first search, buffering, and many other situations where elements must be processed in arrival order.

---

**Binary tree**

A binary tree is a tree data structure in which each node has at most two children: a left child and a right child.

A basic binary tree node can be represented as:
```C
typedef struct _treeNode {
    [type] data;
    struct _treeNode *left;
    struct _treeNode *right;
} TreeNode;
```

For example:

        10
       /  \
      5    20
     / \     \
    2   7     30
A binary tree is not necessarily sorted.

If we want a binary tree with a specific ordering rule, we can use a Binary Search Tree (BST), also called an ABR (Arbre Binaire de Recherche) in French.

Binary Search Tree
In a BST:

values smaller than the current node are stored in the left subtree;
values greater than the current node are stored in the right subtree.
For example:

        10
       /  \
      5    20
     / \     \
    2   7     30
To search for 7:

7 < 10  -> go left
7 > 5   -> go right
7 found


When the tree is reasonably balanced, searching, inserting, and deleting can be performed in approximately O(log n) time.

However, a normal BST can become unbalanced:

10
  \
   20
     \
      30
        \
         40
In this case, its performance can degrade to O(n).

---

**AVL tree**


An AVL tree is a self-balancing Binary Search Tree.

Each node stores information about its height:
```C
typedef struct _treeNode {
    [type] data;
    struct _treeNode *left;
    struct _treeNode *right;
    int height;
} AVLNode;
```
An AVL tree maintains the following property:

|height(left subtree) - height(right subtree)| <= 1
for every node.

When an insertion or deletion makes the tree unbalanced, the tree performs rotations to restore its balance.

For example:
```
     30 
    /
  20
 /
10
```
This tree is unbalanced. A right rotation can transform it into:
```

    20
   /  \
  10   30
```
Because an AVL tree remains balanced, searching, insertion, and deletion are all O(log n) in the worst case.

AVL trees are useful when fast lookup is important and the tree is modified frequently.

---

**Hash table**


A hash table is a data structure used to store and retrieve values using a key.

The main idea is to use a hash function to convert a key into an index in an array.

For example, imagine we want to store people's ages:

Key       Value


"Bob"  -> 25


"Alice" -> 31


"John" -> 42


Instead of searching through every element, we calculate a hash from the key:

hash("Bob")   -> 3


hash("Alice") -> 7


hash("John")  -> 2


We can then store the values at these positions in an array:

| Index | value |
|:-----|:-----|
|  0    | NULL |
|  1    | NULL |
|  2    | John -> 42 |
|  3    | Bob  -> 25 |
|  4    | NULL |
|  5    | NULL |
|  6    | NULL |
| 7    | Alice -> 31 |

This allows us to find a value very quickly.

In a well-designed hash table, insertion, deletion, and lookup are usually O(1) on average.

---

**Hash function**


A hash function takes a key and produces an integer called a hash value.

For example:
```C
unsigned int hash(const char *key) {
    unsigned int result = 0;

    while (*key) {
        result = result * 31 + *key;
        key++;
    }

    return result;
}
```

We can then convert the hash value into an array index:

index = hash(key) % table_size;


For example,

 if:
hash("Alice") = 123456


table_size = 10


then:
123456 % 10 = 6


So "Alice" will be stored at index 6.

---

**Collision**


Two different keys can produce the same index.

This is called a collision.

For example:

hash("Alice") % 10 -> 6
hash("Bob")   % 10 -> 6


Both keys want to use the same position.

A hash table therefore needs a way to handle collisions.

There are two common approaches:

---

**Separate chaining**


Open addressing
Separate chaining
With separate chaining, each position in the array contains a linked list of entries.

For example:

Index 0 -> NULL
Index 1 -> NULL
Index 2 -> [Bob, 25] -> [Alice, 31] -> NULL
Index 3 -> [John, 42] -> NULL
Index 4 -> NULL


If two keys have the same index, they are simply added to the linked list at that position.

A possible implementation in C is:
```C
typedef struct HashNode {
    char *key;
    int value;
    struct HashNode *next;
} HashNode;

typedef struct {
    HashNode **buckets;
    int size;
} HashTable;
```


**HashNode**

buckets;
is a pointer to an array of pointers.

Each pointer represents the beginning of a linked list.

---

**Open addressing**
Another solution is open addressing.

Instead of storing a linked list at each position, all entries are stored directly inside the array.

If a position is already occupied, the hash table looks for another available position.

For example:

hash("Alice") -> 3
index 3 is occupied
        ↓
try index 4
        ↓
index 4 is free
        ↓
store Alice at index 4
There are several ways to choose the next position:

Linear probing
Quadratic probing
Double hashing
With linear probing, we simply try the next position:

index
  3 -> occupied
  4 -> occupied
  5 -> free
So the element is stored at index 5.

---

**Load factor**


A hash table should not become too full.

The load factor represents how full the table is:

load factor = number of elements / table size
For example:

10 elements
20 slots

load factor = 10 / 20 = 0.5
When the load factor becomes too high, collisions become more frequent and the hash table becomes slower.

The table can therefore be resized:

small table
     ↓
too many elements
     ↓
create a bigger table
     ↓
rehash all elements
     ↓
new table
This operation is called rehashing.

---

Complexity
A hash table is particularly useful because its average complexity is very good:

|Operation	|Average Worst case |
|:----------|:------------------|
|Search	O(1) | O(n) |
|Insert	O(1) | O(n) |
|Delete	O(1) | O(n) |
The O(n) worst case can happen when many keys collide and end up in the same bucket.

The quality of the hash function and the way collisions are handled have a major impact on performance.

---

**Example**


A simple hash table could be used to associate usernames with scores:

"Bob"   -> 1500
"Alice" -> 2300
"John"  -> 1800
Instead of searching through an array:

Bob
Alice
John
...
we calculate the hash of the username and directly find the corresponding bucket.

This makes hash tables particularly useful for:

- dictionaries
- caches
- symbol tables
- databases
- counting occurrences
- storing key/value pairs
- implementing sets
- For example, a set of usernames could use:

hash("Alice") -> bucket 4
hash("Bob")   -> bucket 7
hash("John")  -> bucket 2
The value itself does not necessarily need to be stored; the key is enough to determine whether an element exists.

Important idea
A hash table trades some memory for very fast access.

Compared with a sorted array or a binary search tree:

|Stuctures | Propriety |
|:---|:---
|Array | simple, compact, O(n) search |
| Sorted array    | O(log n) search, but insertion can be expensive |
| BST            | O(log n) if balanced |
| Hash table     | O(1) average lookup |

However, hash tables do not naturally maintain their elements in sorted order.

If you need to iterate through elements in sorted order, a tree-based structure may be more appropriate.