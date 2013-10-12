-module(count_down).
-author("Doug Edmunds - From http://wxerlang.dougedmunds.com/").
-export([start/0]).
-include_lib("wx/include/wx.hrl").
 
start() ->
    State = make_window(),
    loop (State).
 
make_window() ->
    Server = wx:new(),
    Frame = wxFrame:new(Server, -1, "Countdown", [{size,{250, 250}}]),
    Panel  = wxPanel:new(Frame),
 
%% create widgets
%% the order entered here does not control appearance
    T1001 = wxTextCtrl:new(Panel, 1001,[{value, "10"}]), %set default value
    ST2001 = wxStaticText:new(Panel, 2001,"Output Area",[]),
    B101  = wxButton:new(Panel, 101, [{label, "&Countdown"}]),
    B102  = wxButton:new(Panel, ?wxID_EXIT, [{label, "E&xit"}]),
 
%%You can create sizers before or after the widgets that will go into them, but
%%the widgets have to exist before they are added to sizer.
    OuterSizer  = wxBoxSizer:new(?wxHORIZONTAL),
    MainSizer   = wxBoxSizer:new(?wxVERTICAL),
    InputSizer  = wxStaticBoxSizer:new(?wxHORIZONTAL, Panel, [{label, "Enter an integer"}]),
    ButtonSizer = wxBoxSizer:new(?wxHORIZONTAL),
 
%% Note that the widget is added using the VARIABLE, not the ID.
%% The order they are added here controls appearance.
 
    wxSizer:add(InputSizer, T1001, []),
    wxSizer:add(InputSizer, 40, 0, []),
 
    wxSizer:addSpacer(MainSizer, 10),  %spacer
    wxSizer:add(MainSizer, InputSizer,[]),
    wxSizer:addSpacer(MainSizer, 5),  %spacer
 
    wxSizer:add(MainSizer, ST2001, []),
    wxSizer:addSpacer(MainSizer, 10),  %spacer
 
    wxSizer:add(ButtonSizer, B101,  []),
    wxSizer:add(ButtonSizer, B102,  []),
    wxSizer:add(MainSizer, ButtonSizer, []),
 
    wxSizer:addSpacer(OuterSizer, 20), % spacer
    wxSizer:add(OuterSizer, MainSizer, []),
 
%% Now 'set' OuterSizer into the Panel
    wxPanel:setSizer(Panel, OuterSizer),
 
    wxFrame:show(Frame),
 
% create two listeners
    wxFrame:connect( Frame, close_window),
    wxPanel:connect(Panel, command_button_clicked),
 
%% the return value, which is stored in State
    {Frame, T1001, ST2001}.
 
loop(State) ->
    {Frame, T1001, ST2001}  = State,  % break State back down into its components
    io:format("--waiting in the loop--~n", []), % optional, feedback to the shell
    receive
 
        % a connection get the close_window signal
        % and sends this message to the server
        #wx{event=#wxClose{}} ->
            io:format("~p Closing window ~n",[self()]), %optional, goes to shell
            %now we use the reference to Frame
         wxWindow:destroy(Frame),  %closes the window
         ok;  % we exit the loop
 
    #wx{id = ?wxID_EXIT, event=#wxCommand{type = command_button_clicked} } ->
%%     {wx, ?wxID_EXIT, _,_,_} ->
            %this message is sent when the exit button (ID 102) is clicked
            %the other fields in the tuple are not important to us.
            io:format("~p Closing window ~n",[self()]), %optional, goes to shell
         wxWindow:destroy(Frame),
         ok;  % we exit the loop
 
    #wx{id = 101, event=#wxCommand{type = command_button_clicked}} ->
            %this message is sent when the Countdown button (ID 101) is clicked
            T1001_val = wxTextCtrl:getValue(T1001),
            case is_valid_list_to_integer(T1001_val) of
                true ->
                    T1001_int = list_to_integer(T1001_val),
                    cntdwn(T1001_int, ST2001);  %letting cntdwn/2 fill in the textbox
                _ ->
                    wxStaticText:setLabel(ST2001, "Only integers are allowed")
            end,
            loop(State);
 
     Msg ->
            %everything else ends up here
         io:format("loop default triggered: Got ~n ~p ~n", [Msg]),
         loop(State)
 
    end.
 
cntdwn(N,StaticText) when N > 0 ->
    % assumes N is an integer
    io:format("~w~n", [N]),
    OutputStr = integer_to_list(N),
    wxStaticText:setLabel(StaticText, OutputStr),
    receive
        after 1000 ->
               true
     end,
    cntdwn(N-1, StaticText);
cntdwn(_, StaticText) ->
    io:format("ZERO~n"),
    OutputStr = "ZERO",
    wxStaticText:setLabel(StaticText, OutputStr),
    ok.
 
is_valid_list_to_integer(Input) ->
    try list_to_integer(Input) of
        _An_integer -> true
    catch
        error: _Reason -> false  %Reason is badarg
    end.