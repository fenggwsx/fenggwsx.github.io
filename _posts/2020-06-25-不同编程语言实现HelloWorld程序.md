---
layout: post
title: 不同编程语言实现HelloWorld程序 
typora-root-url: ..
category: 编程
tags: [Hello World]
---

## C
```c
#include <stdio.h>

int main()
{
      printf("Hello World!");
      return 0;
}
```

## C\#
```c#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HelloWorld
{
      class Program
      {
            static void Main(string[] args)
            {
                  Console.WriteLine("Hello World!");
            }
      }
}
```

## C++
```cpp
#include <iostream>

int main()
{
      std::cout << "Hello World!" << std::endl;
      return 0;
}
```

## HTML
```html
<!doctype html>
<html>
      <head>
            <meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
            <title>Hello World!</title>
      </head>
      <body>
            <h1>Hello World!</h1>
      </body>
</html>
```

## Java
```java
class HelloWorld{
    public static void main(String[] arr){
          System.out.println("Hello World!");
    }
}
```

## Python
```python
print "Hello World!"
```