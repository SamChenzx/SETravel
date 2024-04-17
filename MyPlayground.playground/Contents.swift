import UIKit

var greeting = "Hello, playground"

let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("Add some raisins and make ants on a log.")
case "cucumber", "watercress":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}


struct MyStruct {
    var value: Int

    // 这是一个 mutating 方法，会改变结构体实例本身
    mutating func updateValue(newValue: Int) {
        value = newValue
    }
}

var instance1 = MyStruct(value: 10)
var instance2 = instance1 // 这里发生了结构体的复制，instance2 是 instance1 的副本

instance1.updateValue(newValue: 20) // 这会改变 instance1 实例的值
print(instance1.value) // 输出: 20
print(instance2.value) // 输出: 10，instance2 的值保持不变

// 对于属性包装器的示例：
@propertyWrapper
struct CustomWrapper<Value> {
    private var storedValue: Value

    var wrappedValue: Value {
        get { return storedValue }
        mutating set {
            // 这里设置属性值不会更改结构体实例本身
            storedValue = newValue
        }
    }

    init(wrappedValue initialValue: Value) {
        storedValue = initialValue
    }
}

struct MyStructWithWrapper {
    @CustomWrapper var value: Int
}

var instance3 = MyStructWithWrapper(value: 10)
var instance4 = instance3 // 这里发生了结构体的复制，instance4 是 instance3 的副本

instance3.value = 20 // 这不会改变 instance3 实例本身
print(instance3.value) // 输出: 20
print(instance4.value) // 输出: 10，instance4 的值保持不变
