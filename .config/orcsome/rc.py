from orcsome import get_wm
from orcsome.actions import *

import rsi

TERMINAL = 'urxvtc -title terminal'

wm = get_wm()

wm.on_key('Shift+Mod+r')(restart)
wm.on_key('Shift+Mod+c')(close)
wm.on_key('Shift+Mod+e')(spawn('external-monitor'))
wm.on_key('Ctrl+Alt+x')(spawn(TERMINAL))
wm.on_key('Mod+e')(spawn('menu.sh'))
wm.on_key('Mod+bracketleft')(spawn('mpc volume -2'))
wm.on_key('Mod+bracketright')(spawn('mpc volume +2'))
wm.on_key('Mod+period')(spawn('mpc next'))
wm.on_key('Mod+comma')(spawn('mpc prev'))
wm.on_key('Mod+slash')(spawn('mpc-forward'))
wm.on_key('Mod+grave')(spawn('mpc-trash'))
wm.on_key('Mod+apostrophe')(spawn('mpc-add-tag -D trash listen -A blade'))
wm.on_key('Mod+semicolon')(spawn('mpc-add-tag -D trash blade -A listen'))
wm.on_key('Mod+p')(spawn('mpc toggle'))
wm.on_key('XF86_MonBrightnessUp')(spawn('xbacklight -inc 15'))
wm.on_key('XF86_MonBrightnessDown')(spawn('xbacklight -dec 1'))
wm.on_key('XF86_PowerOff')(spawn('sudo pm-suspend'))
wm.on_key('Mod+i')(spawn_or_raise('urxvtc -name weechat -e weechat-curses', name='weechat'))
wm.on_key('Mod+l')(spawn_or_raise('urxvtc -g 100x30 -name ranger -e ranger', name='ranger'))


################################
# Handle quick apps window close
def bind_restore_focus(desktop, window):
    @wm.on_destroy(wm.event_window)
    def inner():
        wm.activate_desktop(desktop)
restore_focus = {'on_create':bind_restore_focus}

wm.on_key('Ctrl+Alt+p')(spawn_or_raise(
    'urxvtc -name ncmpcpp -e ncmpcpp', name='ncmpcpp', **restore_focus))

wm.on_key('Mod+n')(spawn_or_raise(
    'urxvtc -title mutt -name mutt -e startmutt.sh', name='mutt', **restore_focus))

wm.on_key('Ctrl+Alt+m')(spawn_or_raise(
    'urxvtc -name alsamixer -e alsamixer', name='alsamixer', **restore_focus))

wm.on_key('Mod+k')(spawn_or_raise(
    'urxvtc -name rtorrent -e transmission-remote-cli', name='rtorrent', **restore_focus))


@wm.on_key('Ctrl+Mod+space')
def maximize_window():
    w = wm.current_window
    if w.maximized_vert and w.maximized_horz:
        wm.set_window_state(w, vmax=False, hmax=False, decorate=True, otaskbar=False)
    else:
        wm.set_window_state(w, vmax=True, hmax=True, decorate=False, otaskbar=True)


##########################
# Terminal desktop control
@wm.on_key('Ctrl+Alt+c')
def toggle_console():
    cd = wm.current_desktop
    if cd == 1:
        wm.activate_desktop(0)
    else:
        clients = wm.find_clients(wm.get_clients(), cls="URxvt")
        if clients:
            wm.activate_desktop(1)
        else:
            spawn(TERMINAL)()


@wm.on_create(cls='URxvt')
def bind_urxvt_keys():
    wm.on_key(wm.event_window, 'Shift+Right')(focus_next)
    wm.on_key(wm.event_window, 'Shift+Left')(focus_prev)


def app_rules(w):
    desktop = 0
    decorate = None
    maximize = None
    otaskbar = None

    if w.matches(name='vial'):
        maximize = True
        decorate = False
    elif w.matches(name='ranger'):
        otaskbar = False
    elif w.matches(name='Navigator', cls='Firefox'):
        decorate = False
    elif w.matches(cls='URxvt'):
        desktop = 1
        decorate = False
        maximize = True
    elif w.matches(name='pinentry', cls='Pinentry'):
        desktop = -1
    elif w.matches(cls='bmpanel'):
        return

    wm.change_window_desktop(w, desktop)

    if decorate is not None or maximize is not None or otaskbar is not None:
        wm.set_window_state(w, vmax=maximize, hmax=maximize,
            decorate=decorate, otaskbar=otaskbar)

    cd = wm.current_desktop
    if desktop >=0 and desktop != cd:
        wm.activate_desktop(desktop)


#########################
# Apply application rules
@wm.on_create
def on_create():
    if wm.startup:
        return

    w = wm.event_window
    if w.desktop is None:
        @wm.on_property_change(w, '_NET_WM_DESKTOP')
        def property_was_set():
            property_was_set.remove()
            app_rules(w)
    else:
        app_rules(w)


##########################
# Start RSI prevent module
@wm.on_init
def init():
    r = rsi.init()

    @wm.on_key('Mod+b')
    def do_rest():
        r.start_rest()
