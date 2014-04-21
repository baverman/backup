from orcsome import get_wm
from orcsome.actions import *

import rsi

TERMINAL = 'urxvtc -title terminal'

wm = get_wm()

wm.on_key('Shift+Mod+r')(
    restart)

wm.on_key('Shift+Mod+e')(
    spawn('external-monitor'))

wm.on_key('Ctrl+Alt+x')(
    spawn(TERMINAL))

wm.on_key('Mod+bracketleft')(
    spawn('mpc volume -2'))

wm.on_key('Mod+bracketright')(
    spawn('mpc volume +2'))

wm.on_key('Mod+period')(
    spawn('mpc next'))

wm.on_key('Mod+comma')(
    spawn('mpc prev'))

wm.on_key('Mod+slash')(
    spawn('mpc-forward'))

wm.on_key('Mod+grave')(
    spawn('mpc-trash'))

wm.on_key('Mod+apostrophe')(
    spawn('mpc-add-tag -D trash listen -A blade'))

wm.on_key('Mod+semicolon')(
    spawn('mpc-add-tag -D trash blade -A listen'))

wm.on_key('Mod+p')(
    spawn('mpc toggle'))

wm.on_key('XF86_MonBrightnessUp')(
    spawn('xbacklight -inc 15'))

wm.on_key('XF86_MonBrightnessDown')(
    spawn('xbacklight -dec 1'))

wm.on_key('XF86_PowerOff')(
    spawn('sudo pm-suspend'))

wm.on_key('Mod+i')(
    spawn_or_raise('urxvtc -name weechat -e weechat-curses', name='weechat'))

#wm.on_key('Mod+l')(
#    spawn_or_raise('fmd', cls='Fmd'))

wm.on_key('Mod+l')(
    spawn_or_raise('urxvtc -g 100x30 -name ranger -e ranger', name='ranger'))

################################
# Handle quick apps window close
def bind_restore_focus(desktop, window):
    @wm.on_destroy(wm.event_window)
    def inner():
        wm.set_current_desktop(desktop)
restore_focus = {'on_create':bind_restore_focus}

wm.on_key('Ctrl+Alt+p')(
    spawn_or_raise('urxvtc -name ncmpcpp -e ncmpcpp', name='ncmpcpp', **restore_focus))

wm.on_key('Mod+n')(
    spawn_or_raise('urxvtc -title mutt -name mutt -e startmutt.sh', name='mutt', **restore_focus))

wm.on_key('Ctrl+Alt+m')(
    spawn_or_raise('urxvtc -name alsamixer -e alsamixer', name='alsamixer', **restore_focus))

wm.on_key('Mod+k')(
    spawn_or_raise('urxvtc -name rtorrent -e transmission-remote-cli', name='rtorrent', **restore_focus))


##########################
# Terminal desktop control
@wm.on_key('Ctrl+Alt+c')
def toggle_console():
    cd = wm.current_desktop
    if cd == 1:
        wm.set_current_desktop(0)
    else:
        clients = wm.find_clients(wm.get_clients(), cls="URxvt")
        if clients:
            wm.set_current_desktop(1)
        else:
            spawn(TERMINAL)()

@wm.on_create(cls='URxvt')
def bind_urxvt_keys():
    wm.on_key(wm.event_window, 'Shift+Right')(focus_next)
    wm.on_key(wm.event_window, 'Shift+Left')(focus_prev)


################################################
# Workaround to fix openbox dumb behaviour
@wm.on_create
def switch_to_desktop():
    if not wm.startup:
        if wm.activate_window_desktop(wm.event_window) is None:
            @wm.on_property_change(wm.event_window, '_NET_WM_DESKTOP')
            def property_was_set():
                property_was_set.remove()
                wm.activate_window_desktop(wm.event_window)


###################################
# Handle window maximize/unmaximize
@wm.on_property_change('_NET_WM_STATE')
def window_maximized_state_change():
    state = wm.get_window_state(wm.event_window)

    if state.maximized_vert and state.maximized_horz and not state.undecorated:
        wm.set_window_state(wm.event_window, otaskbar=True, decorate=False)
    elif state.undecorated and (not state.maximized_vert or not state.maximized_horz):
        wm.set_window_state(wm.event_window, otaskbar=False, decorate=True)


#####################################
# Handle weechat urgent notifications
def create_urgent_banner():
    n = pynotify.Notification('IM message', '')
    n.set_timeout(0)
    n.show()
    return n

def destroy_urgent_banner(banner):
    banner.close()

urgent_state = {}
urgent_banner = [None]

@wm.on_create(name='weechat')
def weechat_demands_attention():
    @wm.on_property_change(wm.event_window, '_NET_WM_STATE')
    def state_changed():
        old_state = urgent_state.get(wm.event_window.id, None)
        state = wm.get_window_state(wm.event_window)
        if state.urgent != old_state:
            urgent_state[wm.event_window.id] = state.urgent
            if state.urgent:
                if not urgent_banner[0]:
                    urgent_banner[0] = create_urgent_banner()
            else:
                if urgent_banner[0]:
                    b = urgent_banner[0]
                    urgent_banner[0] = None
                    destroy_urgent_banner(b)

    @wm.on_destroy(wm.event_window)
    def destroy():
        try:
            del urgent_state[wm.event_window.id]
        except KeyError:
            pass


##########################
# Start RSI prevent module
@wm.on_init
def init():
    r = rsi.init()

    @wm.on_key('Mod+b')
    def do_rest():
        r.start_rest()
