# Overview

Python is one of the most popular programming languages today.
Used for object-oriented programming (OOP), scientific computing, or web apps, Python is a wonderful language, thanks to its huge community and its readable, almost English-like syntax.

Python was first released in 1991 and is still maintained by the community.
It is used everywhere: data science, AI, quantum computing, biology, astrophysics, and so on.

Thanks to this popularity, the community has created some of the most useful libraries, like NumPy, SciPy or pandas.

My notes:

    Beginner friendly: [##########]
    Usage:             [##########]
    Ecosystem:         [##########]

### Variables

In Python, a variable has a dynamic type (the type belongs to the value, not to the variable), unlike in C or Rust.

**Example**
~~~python
a = 10
print(f"a={a}")
a = "hello world"
print(f"a={a}")
~~~
Output:
~~~text
a=10
a=hello world
~~~

If you want static typing, Python offers *type hints*:
~~~python
a: float = 10.0
a = "hi!"
~~~
The interpreter ignores type hints at runtime, so this code runs without any error.
The warning comes from a static type checker (mypy, Pyright) or from your IDE.

### If / else statements, comparisons & comments

To run code depending on a condition, use if/elif/else:

- `if` → executes a block if the condition is true.
- `elif` → checks another condition if the previous `if`/`elif` conditions were false.
- `else` → executes if none of the previous conditions were true.

The logical OR is written `or`, the logical AND is written `and`, and the negation is `not`.

**Example**
~~~python
age = 20
if age <= 12:
    print("You're a kid")
elif 12 < age < 18:
    print("You're a teenager")
else:
    print("You're an adult")
~~~

Indentation is mandatory: Python uses it to know which block a line belongs to.
Note that comparisons can be chained, like `12 < age < 18`.

**Special cases**

Some values make comparisons tricky:

- `None`: the equivalent of `NULL` in C. It is falsy (`if None` is false), but `None == False` is `False`. To test it, use `x is None`.
- `NaN` (not a number): `float("nan") != float("nan")`. Use `math.isnan()` or `numpy.isnan()` instead of `==`.

To write a comment, use:

- `# ...` for a single-line comment
- `""" ... """` for a multi-line string. It is technically not a comment but a string literal. It is mostly used for docstrings (documentation of functions and classes).

~~~python
# This is a single-line comment

"""
This is a
multi-line string (often used as a docstring).
"""
~~~

### Lists

Python does not have arrays in the C sense, but it has lists: dynamic, resizable, and able to hold elements of different types.
(For real typed arrays, see the `array` module or NumPy.)

**Example**
~~~python
arr = [1, 2, 3, 4, 5]
print(arr[0])     # 1 (indexing starts at 0)
print(arr[-1])    # 5 (last element)
print(arr[1:3])   # [2, 3] (slicing)
print(len(arr))   # 5
~~~

Useful methods:

- `.append(x)`: add an element at the end
- `.insert(i, x)`: insert an element at index `i`
- `.pop()`: remove the last element and return it (`.pop(i)` for index `i`)
- `.remove(x)`: remove the first occurrence of `x`

### Functions

In Python, a function has no fixed return type, just like variables have no fixed type (but you can add type hints).
Use the keyword `def` to declare a function.

**Example**
~~~python
def maximum(a: float, b: float) -> float:
    if a > b:
        return a
    else:
        return b
~~~

Avoid naming your function `max`: it would shadow the built-in `max()`.
Parameters can have default values: `def greet(name="world"):`.

### Classes

A class is declared with `class`. The constructor is `__init__`, and `self` refers to the current instance (like `this` in C++).

**Example**
~~~python
class Dog:
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age

    def bark(self) -> str:
        return f"{self.name} says woof!"


rex = Dog("Rex", 3)
print(rex.bark())  # Rex says woof!
~~~

Inheritance is written between parentheses:
~~~python
class Puppy(Dog):
    def bark(self) -> str:
        return f"{self.name} says yip!"
~~~

### Sort

In Python you have two ways to sort a list:

- `.sort()`: sorts the list **in place** and returns `None`
- `sorted()`: returns a **new sorted list** and leaves the original unchanged

Both accept `reverse=True` and a `key` function.

~~~python
nums = [3, 1, 2]
print(sorted(nums))        # [1, 2, 3], nums is unchanged
nums.sort(reverse=True)    # nums is now [3, 2, 1]
words = ["banana", "fig", "apple"]
words.sort(key=len)        # ['fig', 'apple', 'banana']
~~~