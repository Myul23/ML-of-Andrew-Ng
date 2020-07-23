- There is a saying that "Data scientists spend 80% of their time cleaning data, and 20% of their time complaining about cleaning data."

---

## return bool

- python
- return number < 0
- return int(bool) + int(bool) + int(bool) == 1
- return (bool + bool + bool) == 1

## else

- python
- if len(L) < 2: return None; return L[1]

## loops

- python

| abbreviation                                                    | same exp                                                                                                                                               |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [ele > thresh for ele in L]                                     | res = []<br />for ele in L: res.append(ele > thresh)<br />return res                                                                                   |
| [n**2 for n in range(10)]                                       | squares = []<br />for n in range(10): squares.append(n\*\*2)                                                                                           |
| [planets for planet in planets if len(planget) < 6]             | short_planets = []<br />for planet in planets:<br />&nbsp; if len(planet) < 6: short_planets.append(planet)                                            |
| [planet.upper() + '!' for planet in planets if len(planet) < 6] | loud_short_planets = []<br />for planet in planets:<br />&nbsp; if len(planet) < 6:<br />&nbsp; &nbsp; loud_short_planets.append(planet.upper() + '!') |
| sum([num < 0 for num in nums])                                  | sum(nums < 0)                                                                                                                                          |
| any([num % 7 == 0 for num in nums])                             | for num in nums:<br />&nbsp; if num % 7 == 0: return True<br />return False                                                                            |
| {i: word_search(doc_list, i) for i in keywords}                 | 보시면 알겠지만, 딕셔너리라 끔찍해서 구연하고 싶지 않습니다.                                                                                           |
