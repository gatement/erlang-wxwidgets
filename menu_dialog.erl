-module(menu_dialog).
-author("Johnson Lau").
-export([start/0, ev/0]).
-include_lib("wx/include/wx.hrl").

start() ->

	%%% start wx
	Wx = wx:new(), % start wx server
	F = wxFrame:new(Wx, -1, "Title1"), % new a window


	%%% Frame visibility
	wxFrame:show(F),
	%wxFrame:show(F, [{show, false}]), % hide
	%wxFrame:destroy(F),


	%%% StatusBar
	wxFrame:createStatusBar(F),
	wxFrame:setStatusText(F, "Quiet here."),
	SB = wxFrame:getStatusBar(F),
	wxStatusBar:pushStatusText(SB, "A LITTLE LOUDER NOW."),
	wxStatusBar:popStatusText(SB),


	%%% Menubar
	MenuBar = wxMenuBar:new(),
	wxFrame:setMenuBar(F, MenuBar),
	%wxFrame:getMenuBar(F),

	FileMn = wxMenu:new(),
	wxMenuBar:append (MenuBar, FileMn, "&File"),
	Quit = wxMenuItem:new ([{id, 400},{text, "&Quit"}]),
	wxMenu:append (FileMn, Quit),

	HelpMn = wxMenu:new(),
	wxMenuBar:append (MenuBar, HelpMn, "&Help"),
	About = wxMenuItem:new ([{id, 500},{text,"&About"}]),
	wxMenu:append (HelpMn, About),


	%%% Event handler
	%flush(), % flush command line process messages
	wxFrame:connect (F, close_window), %bind event handler
	wxFrame:connect (F, command_menu_selected),

	Ding = fun (_, _) -> 
		wx_misc:bell(), 
		wxFrame:destroy(F)
	end,
	wxFrame:connect (F, close_window, [{callback, Ding}]),


	%%% Dialog
	D = wxMessageDialog:new (F, "Let's talk."),
	wxMessageDialog:showModal (D).


ev() -> 
	receive E -> E 
	after 0 -> empty 
	end.
	