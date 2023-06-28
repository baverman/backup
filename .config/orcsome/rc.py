import sys
import datetime
from orcsome import get_wm

sys.modules.pop('rsi', None)
import rsi

TERMINAL = 'urxvtc -title terminal'

wm = get_wm()
wm.track_kbd_layout = True

wm.on_key('Shift+Mod+r').restart()
wm.on_key('Shift+Mod+c').close_window()
wm.on_key('Shift+Mod+e').spawn('external-monitor')
wm.on_key('Ctrl+Alt+x').spawn(TERMINAL)
wm.on_key('Mod+e').spawn('menu.sh')
wm.on_key('Mod+[').spawn('mpc volume -2')
wm.on_key('Mod+]').spawn('mpc volume +2')
wm.on_key('Mod+.').spawn('mpc next')
wm.on_key('Mod+,').spawn('mpc prev')
wm.on_key('Mod+/').spawn('mpc-forward')
wm.on_key('Mod+`').spawn('mpc-trash')
wm.on_key("Mod+'").spawn('mpc-add-tag -D trash listen -A blade')
wm.on_key('Mod+;').spawn('mpc-add-tag -D trash blade -A listen')
wm.on_key('Mod+p').spawn('mpc toggle')
wm.on_key('Mod+x').spawn('lock.sh')
# wm.on_key('XF86_PowerOff').spawn('sudo pm-suspend')
# wm.on_key('Mod+i').spawn_or_raise('urxvtc -name weechat -e weechat-curses', name='weechat')
wm.on_key('Mod+l').spawn_or_raise('urxvtc -g 100x30 -name ranger -e ranger', name='ranger')

wm.on_key('XF86_MonBrightnessUp').spawn('sudo xbacklight -inc 10')
wm.on_key('XF86_MonBrightnessDown').spawn('sudo xbacklight -dec 10')

show_volume = 'notify-send -t 1000 -h string:x-canonical-private-synchronous:volume "$(pactl get-sink-volume @DEFAULT_SINK@ | head -1)"'
wm.on_key('XF86_AudioLowerVolume').spawn('pactl set-sink-volume @DEFAULT_SINK@ -7%; {}'.format(show_volume))
wm.on_key('XF86_AudioRaiseVolume').spawn('pactl set-sink-volume @DEFAULT_SINK@ +7%; {}'.format(show_volume))
wm.on_key('XF86_AudioMute').spawn('pactl set-sink-mute @DEFAULT_SINK@ toggle; {}'.format(show_volume))

show_timew = 'notify-send -t {} "$({})"'
wm.on_key('Mod+w').spawn(show_timew.format(1000, 'timew start work'))
wm.on_key('Mod+Shift+w').spawn(show_timew.format(5000, 'timew stop; timew summary | tail -2 | xargs'))

wm.on_key('Mod+j f').spawn_or_raise('firefox', cls='Firefox')


################################
# Handle quick apps window close
restore_focus = {'on_create': lambda desktop, window:
    wm.on_destroy(wm.event_window).activate_desktop(desktop)}

wm.on_key('Ctrl+Alt+p').spawn_or_raise(
    'urxvtc -name ncmpcpp -e ncmpcpp', name='ncmpcpp', **restore_focus)

wm.on_key('Mod+n').spawn_or_raise(
    'urxvtc -title mutt -name mutt -e startmutt.sh', name='mutt', **restore_focus)

wm.on_key('Ctrl+Alt+m').spawn_or_raise(
    'urxvtc -name alsamixer -e alsamixer', name='alsamixer', **restore_focus)

wm.on_key('Mod+k').spawn_or_raise(
    'urxvtc -name rtorrent -e tremc', name='rtorrent', **restore_focus)


@wm.on_key('Ctrl+Mod+space')
def maximize_window():
    w = wm.current_window
    if w.maximized_vert and w.maximized_horz:
        wm.set_window_state(w, vmax=False, hmax=False, decorate=True, otaskbar=False)
    else:
        wm.set_window_state(w, vmax=True, hmax=True, decorate=False, otaskbar=True)


@wm.on_key('Alt+Mod+space')
def fill_area():
    wm.moveresize_window2(wm.current_window, 0, 0, 0, 0)


def ratio_resize(w, l, m, is_right=False):
    wm.set_window_state(w, vmax=False, hmax=False,
        decorate=False, otaskbar=True)
    _, _, dw, _ = tuple(wm.get_workarea(w.desktop))
    new_w = dw * l / m
    if is_right:
        wm.moveresize_window2(w, dw-new_w, 0, 0, 0)
    else:
        wm.moveresize_window2(w, 0, 0, dw-new_w, 0)


def w_ratio_resize(l, m, is_right):
    def inner():
        ratio_resize(wm.current_window, l, m, is_right)
    return inner


def two_ratio_resize(f):
    def inner():
        clients = wm.find_clients(wm.get_stacked_clients(),
                        desktop=wm.current_desktop)
        c1 = clients[-1]
        c2 = clients[-2]
        ratio_resize(c1, 1, f, False)
        ratio_resize(c2, f-1, f, True)
    return inner


wm.on_key('Mod+1')(w_ratio_resize(1, 1, False))
wm.on_key('Mod+2')(two_ratio_resize(2))
wm.on_key('Mod+3')(two_ratio_resize(3))
wm.on_key('Mod+4')(two_ratio_resize(4))
wm.on_key('Mod+5')(two_ratio_resize(5))



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
            wm.spawn(TERMINAL)


@wm.on_manage(cls='URxvt')
def bind_urxvt_keys():
    wm.on_key(wm.event_window, 'Shift+Right').focus_next()
    wm.on_key(wm.event_window, 'Shift+Left').focus_prev()


def app_rules(w):
    desktop = 0
    decorate = None
    maximize = None
    otaskbar = None
    fill = None

    if w.matches(name='vial'):
        maximize = True
        decorate = False
    elif w.matches(name='ranger'):
        otaskbar = False
    elif w.matches(name='Navigator', cls='Firefox'):
        decorate = False
    elif w.matches(name='Opera', cls='Opera'):
        decorate = False
        maximize = True
    elif w.matches(cls='URxvt'):
        desktop = 1
        decorate = False
        maximize = True
    elif w.matches(name='pinentry-qt'):
        desktop = -1
    elif w.matches(name='pinentry-gtk-2'):
        desktop = -1
    elif w.matches(cls='bmpanel'):
        return

    wm.change_window_desktop(w, desktop)

    if decorate is not None or maximize is not None or otaskbar is not None:
        wm.set_window_state(w, vmax=maximize, hmax=maximize,
            decorate=decorate, otaskbar=otaskbar)

    cd = wm.current_desktop
    if desktop >=0 and desktop != cd:
        wm.focus_and_raise(w)
        wm.activate_desktop(desktop)

    if fill:
        wm.moveresize_window2(w, 0, 0, 0, 0)


#########################
# Apply application rules
@wm.on_create
def on_create():
    w = wm.event_window
    if w.desktop is None:
        @wm.on_property_change(w, '_NET_WM_DESKTOP')
        def property_was_set():
            property_was_set.remove()
            app_rules(wm.event_window)
    else:
        app_rules(w)


# @wm.on_timer(120)
# def reset_dpms_for_fullscreen_windows():
#     w = wm.current_window
#     if w and w.fullscreen:
#         print(datetime.datetime.now(), 'RESET DPMS')
#         wm.reset_dpms()


##########################
# Start RSI prevent module
@wm.on_init
def init():
    r = rsi.init(wm)
    wm.on_key('Mod+Alt+b').do(r.start_rest)
