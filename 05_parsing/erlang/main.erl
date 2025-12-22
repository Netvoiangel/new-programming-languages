-module(main).
-export([main/1]).

main([Query]) ->
    Q = case Query of
            A when is_atom(A) -> atom_to_list(A);
            B when is_binary(B) -> binary_to_list(B);
            L when is_list(L) -> L
        end,
    Pairs = uri_string:dissect_query(Q),
    io:format("parsed: ~p~n", [maps:from_list(Pairs)]);
main([]) ->
    main(["name=Alice&city=New%20York&age=30"]).


