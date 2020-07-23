> # Kaggle Courses

- Author: kaggle (each chapter has other instructor)
- Lectures: [kagglee Courses](https://www.kaggle.com/learn/overview)

---

## Python

- Instructor: Colin Morris
- [Sub-link](https://www.kaggle.com/learn/python)
- [python for non-programmers](https://wiki.python.org/moin/BeginnersGuide/NonProgrammers)

### Boolean Operator

| Operator | Description                | Operator | Description                  |
| -------- | -------------------------- | -------- | ---------------------------- |
| a == b   | a equal to b               | a != b   | a not equal to b             |
| a < b    | a less than b              | a > b    | a greater than b             |
| a <= b   | a less than or equal to b  | a >= b   | a greater than or equal to b |
| and, &   | True and True is only True | or, \|   | False or False is only False |

- 0 is only numbers means False
- All strings means True, even "False" means True

### Basic (element) Operator

| Operator | Name           | Description                                    |
| -------- | -------------- | ---------------------------------------------- |
| a + b    | Addition       | Sum of a and b                                 |
| a - b    | Aubtraction    | Difference of a and b                          |
| a \* b   | Multiplication | Product of a and b                             |
| a / b    | True division  | Quotient of a and b                            |
| a // b   | Floor division | Quotient of a and b, removing fractional parts |
| a % b    | Modulus        | Integer remainder after division of a by b     |
| a \*\* b | Exponentiation | a raised to the power of b                     |
| -a       | Negation       | The negative of a                              |

- 1 + 1 not perfect equal 2 in Basic Computer

---

### addition for String

| What you type... | What you get | example                 | print(example)        |
| ---------------- | ------------ | ----------------------- | --------------------- |
| \'               | '            | 'What\'s up?'           | What's up?            |
| \"               | "            | "That's \"cool\""       | That's "cool"         |
| \ \              | \            | "Look, a mountain: /\\" | Look, a mountain: /\  |
| \n               |              | "1\n2 3"                | 1<br />2 3            |

```
"""string""" == <pre>string</pre>
```

- print(string\*number)
- print("Splitting", total_candies, "candy" if total_candies == 1 else "candies")

### String methods

| appearance           | parameter | description                                         |
| -------------------- | --------- | --------------------------------------------------- |
| String.upper()       |           | return string to uppercase                          |
| String.lower()       |           | return string to lowercase                          |
| String.index( )      | str       | return initial index of str in String               |
| String.startswith( ) | str       | return if str is same to starting String or not     |
| String.endswith( )   | str       | return if str is same to ending String or not       |
| String.split( )      | str (sep) | split (separete) for white space (especially blank) |
| String.rstrip( )     | str       | remove str on String                                |

- '/'.join([month, day, year]) == "month/day/year"
- indexing 가능

### Formatting

| type name        | usage                      | description               |
| ---------------- | -------------------------- | ------------------------- |
| %-operator       | "number is %d", %(num)     | %d, %n.mf, %o, %x, %c, %s |
| str-formatting   | "number is {}".format(num) |
| F-str.formatting | f"number is {num}"         |

```python
s = """Pluto's a {0}.
No, it's a {1}.
{0}!
{1}!""".format('planet', 'dwarf planet')
print(s)
```

```
Pluto's a planet.
No, it's a dwarf planet.
planet!
dwarf planet!
```

---

### (python) Data Group Type

| Type         | define example                   | description                            |
| ------------ | -------------------------------- | -------------------------------------- |
| List         | [any type of data, var]          | of course, list can include other list |
| Tuples       | (only data sequence)             | list to impossible re-assigned         |
| Dictionaries | {"one": 1, "two": 2, "three": 3} |

| name     | description                                                               |
| -------- | ------------------------------------------------------------------------- |
| indexing | 0 to len(dataGroup) or -n(뒤에서 n번째)                                   |
| slicing  | n:m(n번째부터 m-1번째까지 인식), m이 없다면, len(dataGroup)으로 인식한다. |

```
def dataGroup[num1:num2]:
    mylist = []; i = num1
    while i < num2:
      mylist.append(dataGroup[i++])
    return mylist
```

---

### List methods

| appearance       | parameter       | description                          |
| ---------------- | --------------- | ------------------------------------ |
| List.index( )    | data            | show index of the data on List       |
| List.append( )   | data, var, list | append var on List                   |
| List.pop()       |                 | pop recent(final) data               |
| data in List     | no-func         | return bool var for data in List     |
| data not in List | no-func         | return bool var for data not in List |

---

### Dictionaries

- Dictionaries["key"] == value(data)
- Dictionaries["new"] = assign value
- data in Dictionaries 가능

---

### Loops

```
for i in range(num1, num2):
for exp in dataGroup:
for iterator, present_position_value in enumerate(List):
```

```
while true:
while if-exp:
```

### Define (custom) functions

```
def func_name(parameter, argument_name, ...):
    variables defin or calculate variables
    or loop (to new values) calculate or binding
    return specific values or variables
```

- pass: ':'에 대해 함수 없음을 의미하거나 def 내에서 continue와 같은 역할을 하는 것으로 보인다.

---

### import modules

- dir(module): show variable defined and functions implied

| module name | description                            |
| ----------- | -------------------------------------- |
| math        | whole algebra functions                |
| pandas      |
| numpy       | available simple expression for number |
| tensorflow  |
