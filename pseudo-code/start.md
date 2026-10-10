## Overview ##

Pseudocode is used to write algorithms in a way that is independent of any programming language and understandable by every field.
Here, no pointers, no linked lists, no trees: only plain words (and maths).
There is no official standard: conventions change between schools and countries, so what matters is to be clear and consistent.
In this section, I'll write the French version too, because the keywords are not the same.

So why learn pseudocode instead of just learning Python, C or Rust?
Because sometimes you need to describe a mathematical algorithm, and it must be written in a way that everyone can understand, whatever language they use.
It's like using English in a research paper: everybody in the world can read it.

Every algorithm is made of three parts:
1. The header (the name and the parameters of the function or program)
2. The variable block
3. The body, between `Début` and `Fin` (`Start` and `End` in English)

**French Example**
~~~text
algorithme MinMax
    fonction max(a: réel, b: réel): réel
        Variables:
            (aucune variable ici, donc on ne met rien)
        Début:
            Si a > b alors
                renvoyer a
            Sinon
                renvoyer b
            Fin Si
        Fin

    fonction min(a: réel, b: réel): réel
        Variables:
            (aucune)
        Début:
            Si a < b alors
                renvoyer a
            Sinon
                renvoyer b
            Fin Si
        Fin
~~~

**English Example**
~~~text
algorithm MinMax
    function max(a: real, b: real): real
        Variables:
            (none)
        Start:
            if a > b then
                return a
            else
                return b
            end if
        End

    function min(a: real, b: real): real
        Variables:
            (none)
        Start:
            if a < b then
                return a
            else
                return b
            end if
        End
~~~

Each block needs a visible end, and indentation is not mandatory but highly recommended.

**Example with a variable and a loop**

French:
~~~text
fonction somme(n: entier): entier
    Variables:
        i, s: entier
    Début:
        s := 0
        Pour i allant de 1 à n faire
            s := s + i
        Fin Pour
        renvoyer s
    Fin
~~~

English:
~~~text
function sum(n: integer): integer
    Variables:
        i, s: integer
    Start:
        s := 0
        for i from 1 to n do
            s := s + i
        end for
        return s
    End
~~~

Here are some useful standard notations:

**In French**
- `entier`, `réel`, `caractère`, `chaîne`, `tableau`, `booléen` for int, float, char, string, array (often a pointer in C) and bool
- `sin`, `cos`, `exp`, `a^n` (power), as in usual mathematical expressions
- `←` for assignment (`x ← 5` or `:=`), `=` for comparison, `≠` for "different"
- `et`, `ou`, `non` for the logical AND, OR and NOT
- `@` (sometimes `&`) for the address of a variable
- `écrire` (or `écrireln` for the `\n`) for print (or println, if you have already used Rust, it's the same idea)
- `lire` for scanf (C-like) or `input`
- Loops: `Pour ... faire ... Fin Pour`, `Tant que ... faire ... Fin Tant que`, `Répéter ... Jusqu'à ...`

**In English**
- `integer`, `real` (or `float`), `character`, `string`, `array`, `boolean`
- `sin`, `cos`, `exp`, `a^n` (power)
- `←` for assignment (some use `:=`), `=` for comparison, `≠` for "different"
- `and`, `or`, `not`
- `&` (or `address of`) for the address of a variable
- `print` / `write` (or `println` for the line break)
- `read` / `input`
- Loops: `for ... do ... end for`, `while ... do ... end while`, `repeat ... until ...`