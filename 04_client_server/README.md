## Клиент–серверное взаимодействие (ML/SML-NJ, D, Lua)

Одна и та же идея во всех трёх: **TCP echo**.

- Сервер слушает `127.0.0.1:4000`
- Клиент подключается, отправляет строку, получает обратно ту же строку

### ML (Standard ML / SML/NJ)
- Сервер: `ml/server.sml`
- Клиент: `ml/client.sml`
- Запуск (пример, SML/NJ):
  - `sml ml/server.sml`
  - в другом окне: `sml ml/client.sml` (по умолчанию отправляет `hello`)

### D
- Файл: `d/main.d`
- Запуск (пример):
  - сервер: `dub run --single d/main.d -- server`
  - клиент: `dub run --single d/main.d -- client "hello"`

### Lua (LuaSocket)
Требуется LuaSocket (обычно через luarocks).
- Сервер: `lua/server.lua`
- Клиент: `lua/client.lua "hello"`
- Установка (пример): `luarocks install luasocket`


