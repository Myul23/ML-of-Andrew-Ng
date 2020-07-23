# Data Checking Functions

- add element python grammar

### [learning python](https://docs.python.org/ko/3/contents.html)

> from learntools.core import binder; binder.bind(globals())<br />
> import learntools.python.ex1, ex2, ex3, ex4, ex5, ex6, ex7

- q1.hint()
- q1.check()
- q1.solution()

---

### Abbreviation Name

| expression | full expression    |  -  | expression | full expression                         |
| ---------- | ------------------ | :-: | ---------- | --------------------------------------- |
| var        | variable           |  -  | func       | function                                |
| num        | number data        |  -  | ch or char | character data                          |
| str        | string data        |  -  | Number     | number variable                         |
| String     | string variable    |  -  | List       | list variable                           |
| exp        | expression         |  -  | sep        | string or character for separate string |
| module     | name of any module |

- 파이썬에선 char이 없다. 하지만 C언어에 대한 기억 보존과 필자가 이해하기 편하자고 사용한다.

---

| nessesary funct | description                                                                |
| --------------- | -------------------------------------------------------------------------- |
| help(func)      | show parameters of the function and description                            |
| print( )        | print(value, ..., sep = ' ', end = "\n", file = sys.stdout, flush = False) |

- print("Splitting", total_candies, "candy" if total_candies == 1 else "candies")

---

## special datafield

| appearance  | description         |
| ----------- | ------------------- |
| Number.imag | show complex number |

## special member functions

| appearance                | description                     |
| ------------------------- | ------------------------------- |
| var.bit_length()          | show bits assigned              |
| Number.as_integer_ratio() | return integer number, 10\*\*-n |

---

## Define (custom) functions

```
def func_name(parameter, argument_name, ...):
    variables defin or calculate variables
    or loop (to new values) calculate or binding
    return specific values or variables
```

---

### need uni-variable Functions

| func name | prarameter          | description                                            |
| --------- | ------------------- | ------------------------------------------------------ |
| type( )   | anything            |
| dir( )    | anything            | what can I do with it?                                 |
| bool( )   | anything            |
| abs( )    | number              | return unsigned number                                 |
| int( )    | number              | return number of the integer type                      |
| float( )  | number              | return number of the float type                        |
| round( )  | number, digit       | digit만큼의 소숫점을 유지해 반환, ndigits 음수도 가능. |
| range( )  | number (and number) | from number1 (or 0) to number2                         |

### need list(variables) Functions

| func name | parameter        | description                 |
| --------- | ---------------- | --------------------------- |
| list()    | maybe dict       | change type to list         |
| dict()    | maybe list       | change type to dictionaries |
| len( )    | list             | the length of data group    |
| min( )    | numbers or list  |
| max( )    | numbers or list  |
| sorted( ) | list             |
| sum( )    | numberse or list |

---

## import modules

- module includes other (sub) modules
- import module as mn (abbreviation)
- from module import \*: be available all functions on the module and set present module is default
- dir(module): show variable defined and functions impled

| module name  | implied                  |
| ------------ | ------------------------ |
| math         | pi                       |
|              | log(num, low_num)        |
| numpy        |
| numpy.random | randint(low, high, size) |

```
basic python, not use, not available
    List > number
    List[num1, num2]

import numpy, use, available
    numpy.asarray( ) > number == [True, False, False, ...]
    numpy.asarray( )[num1, num2]
```
