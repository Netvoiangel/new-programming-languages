## Установка зависимостей (macOS)

Ниже — как поставить тулчейны, которых не хватает для запуска всех 15 примеров.

### Базово: Homebrew

Если Homebrew не установлен, поставьте его по инструкции с сайта Homebrew:
`https://brew.sh`

Дальше:

```bash
brew update
```

### Языки / тулчейны

#### Haskell (для `ghc`)

Рекомендуемый способ — `ghcup`:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ghc --version
```

#### OCaml (для `ocamlc`)

Через `opam`:

```bash
brew install opam
opam init -y
opam switch create 5.2.0
eval $(opam env)
ocamlc -version
```

#### Common Lisp (SBCL)

```bash
brew install sbcl
sbcl --version
```

#### Julia

Самый простой вариант (через brew cask):

```bash
brew install --cask julia
julia --version
```

Если cask недоступен, поставьте с сайта Julia и проверьте `julia --version`.

#### Groovy

```bash
brew install groovy
groovy --version
```

#### Scala

```bash
brew install scala
scala -version
```

#### Rust (для `rustc`)

Рекомендуется `rustup`:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustc --version
```

#### Erlang + Elixir

```bash
brew install erlang elixir
erl -version
elixir --version
```

#### D (для `dub` и компилятора)

```bash
brew install dmd dub
dmd --version
dub --version
```

Альтернатива: `brew install ldc dub`.

#### LuaRocks + LuaSocket (нужно для `04_client_server/lua/*`)

```bash
brew install luarocks
luarocks install luasocket
```

Проверка:

```bash
lua -e 'require("socket"); print("ok")'
```

### Swift / Objective‑C (Xcode Command Line Tools)

Objective‑C уже собирается через `clang`.
Если **Swift не компилируется** с ошибкой вида `redefinition of module 'SwiftBridging'`,
обычно помогает переустановка/переключение Command Line Tools:

1) Удалить старые CLT (если есть):

```bash
sudo rm -rf /Library/Developer/CommandLineTools
```

2) Переустановить:

```bash
xcode-select --install
```

3) Убедиться, что выбран правильный toolchain:

```bash
xcode-select -p
```

Если установлен полный Xcode, можно переключиться на него:

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```


