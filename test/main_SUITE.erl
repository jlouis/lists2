%%% @author  <Jesper Louis Andersen>
%%% @copyright (C) 2013, 
%%% @doc Test lists2
%%% @end
%%% Created :  2 Aug 2013 by  <>
%%%-------------------------------------------------------------------
-module(main_SUITE).

-export([suite/0, init_per_suite/1, end_per_suite/1,
         init_per_group/2, end_per_group/2, init_per_testcase/2, end_per_testcase/2,
         groups/0, all/0]).

-export([basic_unit/0, basic_unit/1,
         properties/0, properties/1]).

-include_lib("common_test/include/ct.hrl").

suite() ->
    [{timetrap,{seconds,30}}].

init_per_suite(Config) ->
    Config.

end_per_suite(_Config) ->
    ok.

init_per_group(_GroupName, Config) ->
    Config.

end_per_group(_GroupName, _Config) ->
    ok.

init_per_testcase(_TestCase, Config) ->
    Config.

end_per_testcase(_TestCase, _Config) ->
    ok.

groups() ->
    [].

all() -> 
    [basic_unit, properties].

basic_unit() ->
    [].

basic_unit(_Config) ->
    [{1}, {3}] = lists2:ordkeysublist(1, [{1}, {2}, {3}], [{2}]),
    [{1}, {2}, {3}] = lists2:ordkeysublist(1, [{1}, {2}, {3}], [{0}, {4}]),
    [{2}] = lists2:ordkeysublist(1, [{1}, {2}, {3}], [{0}, {1}, {3}, {4}]),
    [{1}, {3}] = lists2:ordkeysublist(1, [{1}, {2}, {3}], 1, [{2}]),
    [{1}, {2}, {3}] = lists2:ordkeysublist(1, [{1}, {2}, {3}], 1, [{0}, {4}]),
    [{2}] = lists2:ordkeysublist(1, [{1}, {2}, {3}], 1, [{0}, {1}, {3}, {4}]),
    [{1}, {2}] = lists2:ordkeysublist(1, [{1}, {1}, {2}, {3}], 1, [{0}, {1}, {3}, {4}]),

    [{0, [2, 4]}, {1, [1, 5, 3]}] =
        lists2:group_with(fun(X) -> X rem 2 end, [1,2,4,5,3]),

    [{0, ["2", "4"]}, {1, ["1", "5", "3"]}] =
        lists2:map_group_with(fun(X) -> {X rem 2, integer_to_list(X)} end, 
                              [1,2,4,5,3]),

    ["a1", "b2", "c3"] =
        lists2:cmap(fun(X, N) -> atom_to_list(X) ++ integer_to_list(N) end, 
                    [a,b,c]),

    F = fun lists2:ordkeymerge_with/4,
    L1 = [{1,a}, {2,b}],
    L2 = [{1,c}, {2,a}],
    L3 = [{2,c}, {3,a}],
    
    [{1,c}, {2,b}] = F(1, fun zipper1/2, L1, L2),
    [{1,a}, {2,c}, {3,a}] = F(1, fun zipper1/2, L1, L3),
    [{1,a}, {2,c}, {3,a}] = F(1, fun zipper1/2, L3, L1),
    
    G = fun lists2:rotate/1,
    {[1,2,3], [a,b,c]} = G([{1,a}, {2,b}, {3,c}]),
    [] = lists2:group_pairs([]),
    ok.

properties() ->
    [].

properties(_Config) ->
    [] = proper:module(lists2_proper_tests),
    ok.

%% Internals
%% --------------------------------------------------

%% Return a record with a highest value in the second field.
zipper1(undefined, Y) -> Y;
zipper1(X, undefined) -> X;
zipper1(X, Y) when element(2, X) > element(2, Y) -> X;
zipper1(_, Y) -> Y.


