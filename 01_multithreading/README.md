## Многопоточность (Haskell, OCaml, Lisp)

Идея: запускаем несколько потоков/тредов, каждый печатает прогресс, и ждём завершения всех.

### Haskell
- Файл: `haskell/Main.hs`
- Запуск (пример): `ghc -O2 Main.hs && ./Main`

### OCaml
- Файл: `ocaml/main.ml`
- Запуск (пример): `ocamlc -thread unix.cma threads.cma main.ml -o main && ./main`

### Lisp (Common Lisp, SBCL)
- Файл: `lisp/main.lisp`
- Запуск (пример): `sbcl --script main.lisp`


