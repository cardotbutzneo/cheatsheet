## Overview ##
The C programming language was created in the 1970s, mainly to develop the UNIX operating system.

C is a compiled, relatively low-level programming language.

C is a wonderful programming language and is very useful when performance matters, even though manual memory management can be a major challenge for beginners.

Even though C has been complemented and, in some areas, superseded by C++, it remains one of the most widely used and widely learned programming languages.

My note:


    Bigginer friendly: [######----]


    Usage:             [########--]
    

    Ecosystem:         [######----]

C is a good first programming language because it teaches you important concepts such as memory management, pointers, and dynamic memory allocation. However, manual memory management and the lack of object-oriented programming features make me prefer C++ over C.

### Variables ###
Be carful a variable in C has a imutable type. You cannot change it after the declaration.

```C
int a = 10;
a = "c";
```
This does not cause a crash. It causes a compile-time error, because "c" is a string literal (an array of char), which is not compatible with an int.

The type of a variable determines how the compiler interprets the memory associated with that variable, as well as its size and alignment requirements. However, the size is not necessarily the same on every platform.

Typical sizes on many modern systems are:
| Type | Size of Variable |
|:----:|:----------------:|
|int   |4 octets (32 bits)|
|float |4 octets (32 bits)|
|char  | 1 octect         |
|pointeur| 8 octets       |

**Important**: these sizes are not guaranteed by the C standard. In particular, int is not necessarily 4 bytes, and pointers are not necessarily 8 bytes.

struct:
Use struct to declare your own type.


**Example**


```C
typedef struct {
    float re;
    float im;
} Complex;
```
> Create complex number base on the cartesian form

void:
Some functions do not return a value. Their return type can be void.

**Example**:


```C
void printfIntArray(int *arr, int size) {
    if (!arr) return; <-- note here the return void is implicit, no need to add 'void'
    printf("[");
    for (int i=0;i<size;i++) {
        printf("%d ", arr[i]);
    }
    printf("]");
} 
```
The return; statement simply returns from the function. You don't write return void;.

### If else statement, comparaison and comments ###
In C, if, else if, and else are used to control which block of code is executed. The ?: operator is another way to conditionally choose between two expressions.

- if → executes a block if the condition is true.
- else if → checks another condition if the previous if/else if conditions were false.
- else → executes if none of the previous conditions were true.
- condition ? a : b → evaluates to a if the condition is true, otherwise b.

Conditions do not technically require parentheses, but parentheses are part of the syntax of an if statement:


```C
if (condition) {
    // ...
}
```

Logical OR is written as ||


Logical AND is written as &&

**Example**:

```C
int age = 20;
if (age <= 12) {
    printf("You're a kid")
} else if (age > 12 && age < 18) {
    printf("you're a teenager")
} else {
    printf("you're an adult") // sorry, US friends
}
```
If you want to write a comment you can use the '//' for an inline comment or '/*...*/' for a block comment.
If you use Doxygen, special comment syntax such as /** ... */ can be used to document functions, types, and other declarations.

For example:

```C
// This is a single-line comment

/*
 * This is a
 * multi-line comment.
 */
```
### Functions ### 

A function in C is a instruction block you can call everywhere in your code.
It take a return type and arguments.

Example:
You can write a function that returns nothing:


```C
void printfIntArray(int *arr, int size) {
    if (!arr) return;
    printf("[");
    for (int i=0;i<size;i++) {
        printf("%d ", arr[i]);
    }
    printf("]");
} 
```
Or a function that returns a value


```C
float max(float a, float b) {
    return (a > b) ? a : b;
}
```
Here, the return type of the function is float.

### Array & pointer ###
As mentioned before, a function cannot return an array type directly.

However, a function can return a **pointer to an array** or, more commonly, a pointer to dynamically allocated memory.

An address stored in a pointer allows a function to access memory outside its local scope.

If you want to declare an array, you have several options.

    static array: int arr[10]; // an array of 10 ints


    dynamic array: int *arr = malloc(sizeof(int) * 10); // Allocate space for 10 ints


With dynamic memory allocation, you are responsible for releasing the memory when you are finished with it:

```C
free(arr);
```

C does not automatically manage this memory for you!

Example:


```C
int *arr = malloc(sizeof(int) * 10);
arr = DoSomething(arr);
free(arr); 
// Be careful: free() does not set the pointer to NULL.

// After:
free(arr); // CRASH (doble free)
// arr still contains the old address, but that memory is no longer valid to access. 
//Such a pointer is called a dangling pointer.

// A common pattern is:
free(arr);
arr = NULL;
```
### Stream ###

In C, files and other input/output sources can be accessed through streams provided by the standard I/O library `(stdio.h)`.

Some useful functions are:

fprinf: fprintf writes formatted output to a specified stream.


```C
int fprintf( FILE * restrict stream, const char * restrict format, ... );
```

`printf` is similar to fprintf, but writes to stdout by default.


Example: 

```C
printf(stdout, "%d %f %c %s %p", v_int, v_float, v_char, v_string, v_adress)
```
Common format specifiers:

```C

- %d: int
- %f: float
- %c: char
- %s: string
- %p: pointeur (hex)
```

fgets reads a line of text from a stream.


```C
char * fgets( char * restrict string, int maxLength, FILE * restrict stream ); 
```
Example:


```C
char buffer[100];

fgets(buffer, sizeof(buffer), stdin);
```

scanf reads formatted input from stdin.


For example:

```C
int age;
scanf("%d", &age);
```
### Sort  ### 

Fortunately, C provides a built-in sorting function called qsort.


```C
void qsort(void *base, size_t nitems, size_t size, int (*compar)(const void *, const void *));   
Unlike some sorting functions in other languages, qsort does not return the sorted array. It sorts the array in place.
```

For example:

```C
int arr[50] = { /* ... */ };

qsort(arr, 50, sizeof(int), compare_function);

printIntArray(arr);

//The comparison function receives pointers to two elements:

int compare(const void *a, const void *b) {
    const int *ia = a;
    const int *ib = b;

    if (*ia > *ib) return 1;
    if (*ia < *ib) return -1;
    return 0;
}
```
The comparison function is passed to qsort as a function pointer.

For example, to sort an array of Complex numbers by their magnitude:

```C
#include <math.h>

int compareComplex(const void *a, const void *b) {
    const Complex *ca = a;
    const Complex *cb = b;

    float norm_a = sqrtf(ca->re * ca->re + ca->im * ca->im);
    float norm_b = sqrtf(cb->re * cb->re + cb->im * cb->im);

    if (norm_a > norm_b) return 1;
    if (norm_a < norm_b) return -1;
    return 0;
}

//Then:

Complex arr[10] = {
    {0, 0},
    {1, 5},
    {8, 0},
    {-9, -4}
    // ...
};

qsort(arr, 10, sizeof(Complex), compareComplex);
```
The array is now sorted by the magnitude of each complex number.