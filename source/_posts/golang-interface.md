---
title: 深入淺出 Golang Interface
date: 2020-04-26 20:31:38
tags:
- golang
- interface
categories:
- Golang 筆記
---

# 前言

本篇將簡單透過一些簡單的例子來理解 Golang 的 Interface。
這篇文章主要涉及內容包含：
- 簡介 Interface
- 為什麼要用 Interface
- 如何應用 Interface

<!--more-->

# Let's Start!

## 簡介 Interface

> So what is an interface? An interface is two things: it is a set of methods, but it is also a type.
Interface 既是方法的集合，也是一個型別，因此我們將會以這兩部分去介紹 Interface

### A Set of Methods

#### 說明

在 Golang 中，interface 是一組 method 的集合，是 duck-type programming 的一種體現：
- 不關心屬性（數據），只關心行為（方法）
- 如果一個類型實現了一個 interface 中所有方法，該類型實現了該 interface

因此在定義function 的時候，我們可以將參數定義成 interface，使得我們調用function 的時候可以做到非常的靈活。

#### 範例

下面我們透過 Go by example 來看看 Interface 的用法。首先我們先定義幾何的 interface ，其中包含 area & perim 兩個方法，最後再分別定義 rect & circle 兩個 struct 去實現 geometry 的方法，使得我們在呼叫 measure 時會依照不同算法去計算。

``` golang
package main

import (
    "fmt"
    "math"
)


type geometry interface {
    area() float64
    perim() float64
}

type rect struct {
    width, height float64
}
type circle struct {
    radius float64
}

func (r rect) area() float64 {
    return r.width * r.height
}
func (r rect) perim() float64 {
    return 2*r.width + 2*r.height
}

func (c circle) area() float64 {
    return math.Pi * c.radius * c.radius
}
func (c circle) perim() float64 {
    return 2 * math.Pi * c.radius
}

func measure(g geometry) {
    fmt.Println(g)
    fmt.Println(g.area())
    fmt.Println(g.perim())
}

func main() {
    r := rect{width: 3, height: 4}
    c := circle{radius: 5}

    measure(r)
    measure(c)
}
```

output:

```
$ go run interfaces.go
{3 4}
12
14
{5}
78.53981633974483
31.41592653589793
```

### A Type

#### 說明

interface{} 是一個空的interface 類型，根據前文的定義由於空的interface 沒有方法，所以可以認為所有的類型都實現了 interface{}。
因此假設一個 function 的參數是 interface{} ，則這個 function 應該可以接受任何類型作為它的參數。

``` golang
func doSomething(v interface{}){    
}
```

但是這並**不代表 v 是任何型別**，在 doSomething 中 v 僅僅是一個 interface 類型，之所以function 可以接受任何類型是因為 go 在 runtime 時，會將傳遞到 function 的任何類型都被自動轉換成 interface{}，因此 doSomething 便能接受所有型別的參數，但必須再次強調這並不代表 v 就是任何型別。

#### 進一步說明

至於為什麼可以做到這件事呢？首先我們可以看一下 a tour of go 對 interface value 的說明

> interface values can be thought of as a tuple of a value and a concrete type: 
> (value, type)

簡單的來說 interface 可以視作是一個 (value, type) 的 tuple ，一個 element 用於指向其基礎型別的方法集(type)，另一個 element 用於指向其所保存的實際數據(value)，因此當呼叫 interface 的方法時，會在其基礎類型上執行相同名稱的方法。
這是什麼意思呢？讓我們以 a tour of go 的例子解釋，我們可以看到 main function 中 i.M() 當 i = &T{"Hello"} ，實際上呼叫的是 t.M() 也就是會得到 Hello 的結果。

``` golang
pckage main

import (
	"fmt"
	"math"
)

type I interface {
	M()
}

type T struct {
	S string
}

func (t *T) M() {
	fmt.Println(t.S)
}

type F float64

func (f F) M() {
	fmt.Println(f)
}

func main() {
	var i I
	
	i = &T{"Hello"}
	describe(i)
	i.M()

	i = F(math.Pi)
	describe(i)
	i.M()
}

func describe(i I) {
	fmt.Printf("(%v, %T)\n", i, i)
}
```

## 為什麼要用 Interface

基本上談到為何要用 interface 大多數都會提到兩個面向：
- writing generic algorithm
- hiding implementation detail

### writing generic algorithm

嚴格來說，在 Golang 不支持泛型編程，但是我們可以透過 interface 實現泛型編程。比如我們現在要寫一個泛型算法，參數定義採用 interface 就可以了，這邊我們以官方的 sort 為例。
``` golang
package sort

// A type, typically a collection, that satisfies sort.Interface can be
// sorted by the routines in this package.  The methods require that the
// elements of the collection be enumerated by an integer index.
type Interface interface {
    // Len is the number of elements in the collection.
    Len() int
    // Less reports whether the element with
    // index i should sort before the element with index j.
    Less(i, j int) bool
    // Swap swaps the elements with indexes i and j.
    Swap(i, j int)
}

...

// Sort sorts data.
// It makes one call to data.Len to determine n, and O(n*log(n)) calls to
// data.Less and data.Swap. The sort is not guaranteed to be stable.
func Sort(data Interface) {
    // Switch to heapsort if depth of 2*ceil(lg(n+1)) is reached.
    n := data.Len()
    maxDepth := 0
    for i := n; i > 0; i >>= 1 {
        maxDepth++
    }
    maxDepth *= 2
    quickSort(data, 0, n, maxDepth)
}
```

Sort function 的參數是一個 interface，包含了三個方法：Len()，Less(i,j int)，Swap(i, j int)。使用的時候不管數組的元素類型是什麼類型（int, float, string…），只要我們實現了這三個方法就可以使用 Sort function，這樣就實現了“泛型編程”。

### hiding implementation detail

隱藏具體實現。比如我設計一個 function 給你返回一個 interface，那麼你只能通過 interface 裡面的方法來做一些操作，但是內部的具體實現是完全不知道的。

``` golang
package main

import (
    "fmt"
)

type SalaryCalculator interface {
    CalculateSalary() int
}

type Supervisor struct {
    id     int
    salary int
    bonus  int
}

func (s Supervisor) CalculateSalary() int {
    return s.salary + s.bonus
}

type Employee struct {
    id          int
    salary      int
    overtimePay int
}

func (e Employee) CalculateSalary() int {
    return e.salary + e.overtimePay
}

func totalExpense(s []SalaryCalculator) {
    expense := 0
    for _, v := range s {
	// 會計人員不用知道每位員工的具體計薪方式，只需要知道每個員工的總額，並將其加總作帳即可
	expense = expense + v.CalculateSalary()
    }
    fmt.Printf("Total Expense Per Month $%d", expense)
}

func main() {
    sup1 := Supervisor{1, 5000, 2000}
    sup2 := Supervisor{2, 6000, 3000}
    emp1 := Employee{3, 3000, 200}
    employees := []SalaryCalculator{sup1, sup2, emp1}
    totalExpense(employees)
}

// Total Expense Per Month $19200

```

## 如何應用 Interface

### Type Assertion

Type assertion 可以用來取出 interface 底層的 value

``` golang
//Bad
func do(v interface{}) {
    n := v.(int)    // might panic
}

//Good
func do(v interface{}) {
    n, ok := v.(int)
    if !ok {
        // handling when assert failing
    }
}

```

### Type Switch

當有多個或不確定的底層 type 時，可以用 switch 去做個別處理

``` golang
//InterfaceToString convert interface to string
func InterfaceToString(i interface{}) string {
    switch v := i.(type) {
    case int:
	return strconv.Itoa(i.(int))
    case int32:
	return strconv.FormatInt(int64(i.(int32)), 10)
    case int64:
	return strconv.FormatInt(i.(int64), 10)
    case uint:
	return strconv.Itoa(int(i.(uint)))
    case uint32:
	return strconv.FormatInt(int64(i.(uint32)), 10)
    case uint64:
	return strconv.FormatInt(int64(i.(uint64)), 10)
    case float32:
	return strconv.FormatFloat(float64(i.(float32)), 'f', -1, 32)
    case float64:
	return strconv.FormatFloat(i.(float64), 'f', -1, 64)
    case time.Time:
	return i.(time.Time).String()
    case string:
	return i.(string)
    default:
	return "unknown"
    }
}

```

### Implementing interfaces using pointer receivers vs value receivers

結論：
- 使用 value receivers，pointer & value 都可以視作 interface 的實作
- 使用 pointer receivers，只有 pointer 被視作 interface 的實作

``` golang

package main

import "fmt"

type Hero interface {
	Describe()
}

type DC struct {
	name string
	age  int
}

func (b DC) Describe() { //implemented using value receiver
	fmt.Printf("%s is %d years old\n", b.name, b.age)
}

type Marvel struct {
	name string
	age  int
}

func (j *Marvel) Describe() { //implemented using pointer receiver
	fmt.Printf("%s is %d years old\n", j.name, j.age)
}

func main() {
	var d1 Hero // 聲明 d1 是 Hero(interface) 類型
	p1 := DC{"Batman", 35}
	d1 = p1 // 賦值 p1 到 d1
	d1.Describe()
	p2 := DC{"Joker", 42}
	d1 = &p2 // 賦值 &p2 到 d1
	d1.Describe()

	var d2 Hero // 聲明 d2 是 Describer(interface) 類型
	a := Marvel{"IronMan", 33}
	//d2 = a
	//d2.Describe()
	// 當 assign value 時，必須要 implements interface 的內容，否則會 error
	// 原因在於 a 並沒有實作 Describe()，實作 Describe() 的是 pointer receiver，因此不能說 a 實作 Describer interface
	/*
		cannot use a (type Marvel) as type Hero in assignment:
		Marvel does not implement Hero (Describe method has pointer receiver)
	*/

	d2 = &a // 賦值 &a 到 d2
	d2.Describe()
}

/*
Batman is 35 years old
Joker is 42 years old
IronMan is 33 years old
*/
```

### Embedding interfaces

在 golang 實現多個 interface 可以透過 embedding interfaces 來處理：
``` golang

type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

type ReadWriter interface {
    Reader
    Writer
}

//同時實現 Reader, Writer, ReadWriter 三種 interface
type MyIO struct {}

func (io *MyIO) Read(p []byte) (n int, err error) {...}
func (io *MyIO) Write(p []byte) (n int, err error) {...}
```


# 總結

> Is Go an object-oriented language?
> Yes and no. Although Go has types and methods and allows an object-oriented style of programming, there is no type hierarchy.

interface 是 Golang 的一種重要的特性，Golang 透過型別和方法讓使用者可以用 OOP 的思維來設計程式，但這不代表當中有型別繼承的現象，並且這也同樣會帶來效能的損失。拋開效能不談，interface 對於我們如何設計代碼給了更多變化和通用性。


# Ref
- [How to use interfaces in Go](https://jordanorelli.com/post/32665860244/how-to-use-interfaces-in-go)
- [The Go Programming Language Specification](https://golang.org/ref/spec#Interface_types)
- [Go by Example: Interfaces](https://gobyexample.com/interfaces)
- [理解 Go interface 的 5 个关键点](https://sanyuesha.com/2017/07/22/how-to-understand-go-interface/)
- [A Tour of Go](https://tour.golang.org/methods/11)
- [Frequently Asked Questions](https://golang.org/doc/faq#Is_Go_an_object-oriented_language)
