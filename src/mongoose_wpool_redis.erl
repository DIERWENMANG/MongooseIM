-module(mongoose_wpool_redis).
-behaviour(mongoose_wpool).

-export([init/0]).
-export([start/4]).
-export([stop/2]).

init() ->
    ok.

start(Host, Tag, WpoolOptsIn, ConnOpts) ->
    Name = mongoose_wpool:make_pool_name(redis, Host, Tag),
    WpoolOpts = wpool_spec(WpoolOptsIn, ConnOpts),
    wpool:start_sup_pool(Name, WpoolOpts).

stop(_, _) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

wpool_spec(WpoolOptsIn, ConnOpts) ->
    Worker = {eredis_client, makeargs(ConnOpts)},
    [{worker, Worker} | WpoolOptsIn].


makeargs(RedisOpts) ->
    Host = proplists:get_value(host, RedisOpts, "localhost"),
    Port = proplists:get_value(port, RedisOpts, 6379),
    Database = proplists:get_value(database, RedisOpts, 0),
    Password = proplists:get_value(password, RedisOpts, ""),
    [Host, Port, Database, Password, 100, 5000].
