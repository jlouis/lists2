-module(lists2_proper_tests).

-export([prop_group_count_with/0]).

%% ------------------------------------------------------------------
%% Tests
%% ------------------------------------------------------------------

-include_lib("proper/include/proper.hrl").

prop_group_count_with() ->
    ?FORALL(RandomList, list(),
        begin
        F = fun(X) -> X end, %% id
        equals(naive_group_count_with(F, RandomList), 
               lists2:group_count_with(F, RandomList))
        end).

naive_group_count_with(F, List) ->
    [{K, length(L)} || {K, L} <- lists2:group_with(F, List)].


%% -------------------------------------------------------------------
%% Property Testing
%% -------------------------------------------------------------------

