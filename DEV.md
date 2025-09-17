### Настройка окружения

На данный момент нужен OCaml 4.14.2

    opam switch create comp25 --packages=ocaml-variants.4.14.2+options,ocaml-option-flambda

Зависимости для демо-проекта (для не-Ubuntu может понадобится что-то дополнительное):

    opam install ./demo ocaml-lsp-server --deps-only --with-test --yes

Выше название switch `comp25` не совсем с потолка, потому что оно прописано в .envrc.
Этот файлик сам будет настраивать пути в терминале, если запариться утилитой [direnv](https://ocaml.org/docs/opam-path#using-direnv).
