%%%-------------------------------------------------------------------
%%% @author crackcell <tanmenglong@gmail.com>
%%% @copyright (c) 2013, crackcell
%%% @doc
%%% file desc
%%% @end
%%% Created : Sat Aug  3 23:43:45 2013
%%%-------------------------------------------------------------------

-module(is_store).
-author('tanmenglong@gmail.com').
-behaviour(gen_server).

%% API
-export([start_link/0, set/2, get/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
		 terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {tableid=undefined}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

set(Host, IP) ->
	gen_server:call(?SERVER, {Host, IP}).

get(Host) ->
	gen_server:call(?SERVER, {Host}).


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @private
init([]) ->
	error_logger:info_msg("init store~n", []),
	TableID = ets:new(is, [set]),
	{ok, #state{tableid=TableID}}.

%% @private
handle_call({Host, IP}, _From, #state{tableid=TableID} = State) ->
	error_logger:info_msg("Storing ~p` IP ~p to ~p~n", [Host, IP, TableID]),
    Reply = ets:insert(TableID, {Host, IP}),
    {reply, Reply, State};

%% @private
handle_call({Host}, _From, #state{tableid=TableID} = State) ->
	error_logger:info_msg("Seeking ~p's IP from ~p~n", [Host, TableID]),
	Reply = ets:lookup(TableID, Host),
	{reply, Reply, State}.

%% @private
handle_cast(_Msg, State) ->
	{noreply, State}.

%% @private
handle_info(_Info, State) ->
	{noreply, State}.

%% @private
terminate(_Reason, _State) ->
	ok.

%% @private
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================


%%%===================================================================
%%% Unit tests
%%%===================================================================
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.
