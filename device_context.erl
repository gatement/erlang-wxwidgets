-module(device_context).
-author("Doug Edmunds - From http://wxerlang.dougedmunds.com/").
-export([start/0]).
-include_lib("wx/include/wx.hrl").
 
start() ->
    Wx = wx:new(),
    Frame = wxFrame:new(Wx, -1, "Device Context", [{size, {600, 380}}]),
    Panel = wxPanel:new(Frame),
 
    OnPaint = fun(_Evt, _Obj) ->
		%io:format("now: ~p~n event: ~p~n object: ~p~n",[now(),_Evt,_Obj]),
        PaintDC = wxPaintDC:new(Panel),

        Pen = wxPen:new(),                    
		wxPen:setWidth(Pen, 3),
		wxPen:setColour(Pen, ?wxRED),
        wxDC:setPen(PaintDC, Pen),

        wxDC:drawPoint(PaintDC, {100, 100}),
        wxDC:drawLine(PaintDC, {40, 70}, {230,70}),


        %wxFont:new(Size, Family, Style, Weight)
        Font = wxFont:new(20, ?wxFONTFAMILY_MODERN, ?wxFONTSTYLE_NORMAL, ?wxFONTWEIGHT_BOLD),
        wxDC:setFont(PaintDC,Font),
        wxDC:drawText(PaintDC, "Lev Nikolaevich Tolstoy", {40, 70}),

        Font2 = wxFont:new(15, ?wxFONTFAMILY_ROMAN, ?wxFONTSTYLE_ITALIC, ?wxFONTWEIGHT_BOLD),
        wxDC:setFont(PaintDC,Font2),
        wxDC:drawText(PaintDC, "Anna Karenina", {80, 120}),


        wxPen:destroy(Pen),
        wxFont:destroy(Font2),
        wxFont:destroy(Font),
        wxPaintDC:destroy(PaintDC)
    end,
 
    wxFrame:connect(Panel, paint, [{callback, OnPaint}]),    
    wxFrame:center(Frame),
    wxFrame:show(Frame).
