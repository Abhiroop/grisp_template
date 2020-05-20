-module(ioutils).
-export([ readintstream/0
        , writeintstream/1
        , readboolstream/0
        , writeboolstream/1
        , pulse/1

        %% GRiSP specific
        , writecolor/2
        , readcolor/1
        ]).

readintstream() ->
    {ok,[X]} = io:fread("","~s"),
    try list_to_integer(X) of
        Result -> Result
    catch
        _:_ -> {error, bad_integer}
    end.

writeintstream(X) when is_integer(X) ->
    io:write(X);
writeintstream(_) ->
    {error,bad_integer}.

readboolstream() ->
    {ok,[X]} = io:fread("","~s"),
    try list_to_atom(X) of
        Result ->
           case Result of
               true -> true;
               false -> false;
               _ -> {error, bad_bool}
           end
    catch
        _:_ -> {error, bad_bool}
    end.

writeboolstream(X) ->
    case X of
        true  -> io:write(X);
        false -> io:write(X);
        _ -> {error,bad_bool}
    end.

pulse(X) when is_integer(X) ->
    timer:sleep(X * 1000),
    true;
pulse(_) ->
    {error, bad_integer}.

%% Serialization - deserialization layer for GRiSP LEDs
writecolor(Pos, X) ->
    Y = case X of
            0 -> off;
            1 -> red;
            2 -> green;
            3 -> blue;
            4 -> yellow;
            5 -> aqua;
            6 -> magenta;
            7 -> white;
            8 -> black
        end,
    grisp_led:color(Pos, Y).

readcolor(Pos) ->
    X = grisp_led:readcolor(Pos),
    case X of
        off -> 0;
        red -> 1;
        green   -> 2;
        blue    -> 3;
        yellow  -> 4;
        aqua    -> 5;
        magenta -> 6;
        white -> 7;
        black -> 8
    end.
