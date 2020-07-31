- from [DL for everyone](https://github.com/Myul23/summary/DL%20for%20everyone.md)
- b"String", 'b' indicated _Bytes literals_. <https://stackoverflow.com/questions/6269765/>

---

1. Build graph using TensorFlow operations
2. feed data and run graph (operation) / sess.run(op)
3. update variables in the graph (and return values)

- <https://www.mathwarehouse.com/>

---

| Ranks | D-num | Shape           |                                 |
| :---: | :---: | --------------- | ------------------------------- |
|   0   |  0-D  | []              | Schalar (magnitude only)        |
|   1   |  1-D  | [D0]            | Vector(magnitude and direction) |
|   2   |  2-D  | [D0, D1]        | Matrix (table of numbers)       |
|   3   |  3-D  | [D0, D1, D2]    | 3-Tensor (cube of numbers)      |
|   n   |  n-D  | [D0, D1 ~ Dn-1] | n-Tensor (you get the idea)     |

- D-num: Dimension number

| data type | python type | description            | data type | python type | description            |
| --------- | ----------- | ---------------------- | --------- | ----------- | ---------------------- |
| DT_FLOAT  | tf.float32  | 32 bits floating point | DT_DOUBLE | tf.float64  | 64 bits floating point |
| DT_INT8   | tf.int8     | 8 bits signed integer  | DT_INT16  | tf.int16    | 16bits signed integer  |
| DT_INT32  | tf.int32    | 32 bits signed integer | DT_INT64  | tf.int64    | 64 bits signed integer |

- 기본은 C와 같이 4byte 기준이므로 32bits 사용

---

```
import tensorflow as tf
tf.__version__
```

- 2.0.0으로 version-up 되면서 사라진 것들이 많다.
- Session과 run은 사라졌으나, import tensorflow.compat.v1을 통해 contrib를 제외한 모듈은 (대체로) 그대로 사용할 수 있다.
- 추가로 v2 기능을 제한하고 싶다면, tf.disable_v2_behavior()를 실행시키면 된다.

> hello = tf.constant("Hello, Tensorflow!")<br />print(hello)

| 1.15                                      | 2.3          |
| ----------------------------------------- | ------------ |
| hello = tf.constant("Hello, Tensorflow!") | =            |
| sess = tf.Session()                       |              |
| print(sess.run(hello))                    | print(hello) |

- 성능을 위해 나눴지만, 디버깅 불편 및 직관적인 프로그래밍 실패로 세션없이 실행하는 Eager Execution으로 바뀌었다.

```
node1 = tf.constant(3.0, tf.float32)
node2 = tf.constant(4.0)
node3 = tf.add(node1, node2)
print("node1:", node1, "node2:", node2)
print("node3:", node3)
```

- tf.constant( ), float32가 default이기도 하고 다형성을 가진다.

> print("sess.run(node1, node2):", node1, node2)<br />print("sess.run(node3):", node3)

| 1.15                                                       | 2.3                                            |
| ---------------------------------------------------------- | ---------------------------------------------- |
| sess = tf.Session()                                        |
| print("sess.run(node1, node2):", sess.run([node1, node2])) | print("sess.run(node1, node2):", node1, node2) |
| print("sess.run(node3):", sess.run(node3))                 | print("sess.run(node3):", node3)               |

---

| 1.15                                                              | 2.3                                                         |
| ----------------------------------------------------------------- | ----------------------------------------------------------- |
| a = tf.placeholder(tf.float32)                                    | a = tf.Variable([0.0, 0.0])                                 |
| b = tf.placeholder(tf.float32)                                    | b = tf.Variable([0.0, 0.0])                                 |
| adder_node = a + b<br />- '+' provides a shortcut for tf.add(a,b) | @tf.function<br />def adder_node(): return tf.add(a, b)     |
| print(tf.Session().run(adder_node, feed_dict = {a: 3, b: 4.5}))   | a[0].assign(3); b[0].assign(4.5)<br />print(adder_node())   |
|                                                                   | a.assign([1, 3]); b.assign([2, 4])<br />print(adder_node()) |

- placeholder v2에선 사라졌다.
- Variable의 매개변수가 초기값이 되고, 초기값에 따라 데이터 타입이 결정됨.
- 함수 형태로 본다면 adder_node를 함수화시켜 쓸 수 있다.

```
# 완전 c++이라 포인터로 인한 나중 늘림?이 안 되네요 허허.
# 당연히 매개변수 넣고 하는 것도 가능.
# 와 c++이 기본이라는 프로그램이 정수를 소수랑 더했다고 형태가 달라서 안 된다고 하는 상황을 보았다.
# 진짜 계산에 대한 자동 형변환은 버려진 거구나.
```
