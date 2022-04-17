type EventChannel* = enum
    WindowQuit, EngineQuit


type
    Event* = object
        # In case event has id
        id*: uint32
    # WindowEvent* = object of Event
    #     windowId*: uint32
    # WindowQuitEvent* =  object of WindowEvent

type Subscriber = object
    channel: EventChannel
    callback: proc(event: Event)

var subscriberList: seq[Subscriber]


proc broadcast*(channel: EventChannel, event: Event) =
    for sub in subscriberList:
        if sub.channel == channel:
            sub.callback(event)

proc subscribe*(channel: EventChannel, callback: proc(event: Event)) =
    var sub: Subscriber
    sub.channel = channel
    sub.callback = callback
    subscriberList.add sub
