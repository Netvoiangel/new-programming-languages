## Конвертация данных (Scala, Swift, Objective-C)

Одна и та же задача во всех трёх: **CSV → JSON**.

Вход: CSV (из файла или stdin, иначе берётся пример).  
Выход: JSON-массив объектов (первая строка CSV — заголовки).

### Scala
- Файл: `scala/Main.scala`
- Запуск (пример): `scala --server=false --jvm system Main.scala < data.csv`

### Swift
- Файл: `swift/main.swift`
- Запуск (пример): `swiftc main.swift -o main && ./main < data.csv`

### Objective-C
- Файл: `objective-c/main.m`
- Запуск (пример, macOS): `clang -fobjc-arc -framework Foundation main.m -o main && ./main < data.csv`


