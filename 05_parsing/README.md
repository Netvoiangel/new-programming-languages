## Парсинг данных (Rust, Elixir, Erlang)

Одна и та же задача во всех трёх: **разобрать query string** вида:

`name=Alice&city=New%20York&age=30`

Результат: пары ключ→значение (процент-декодирование, `+` как пробел).

### Rust
- Файл: `rust/main.rs`
- Запуск (пример): `rustc main.rs -O && ./main "name=Alice&city=New%20York"`

### Elixir
- Файл: `elixir/main.exs`
- Запуск (пример): `elixir main.exs "name=Alice&city=New%20York"`

### Erlang
- Файл: `erlang/main.erl`
- Запуск (пример):
  - `erlc main.erl`
  - `erl -noshell -s main main "name=Alice&city=New%20York" -s init stop`


