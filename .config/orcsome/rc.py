import time
from orcsome.actions import spawn_or_raise, spawn, focus_next, focus_prev
from Xlib.Xatom import ATOM

wm.on_key('Ctrl+Alt+x')(
    spawn('urxvtc'))

wm.on_key('Mod+bracketleft')(
    spawn('mpc volume -2'))

wm.on_key('Mod+bracketright')(
    spawn('mpc volume +2'))

wm.on_key('Mod+p')(
    spawn('mpc toggle'))

wm.on_key('XF86_MonBrightnessUp')(
    spawn('sudo backlight up'))

wm.on_key('XF86_MonBrightnessDown')(
    spawn('sudo backlight down'))


def bind_restore_focus(wm, window):
    @wm.on_destroy(wm.event.window)
    def inner(wm):
        wm.activate_window_desktop(window)
restore_focus = {'on_create':bind_restore_focus}

wm.on_key('Ctrl+Alt+p')(
    spawn_or_raise('urxvtc -name ncmpcpp -e ncmpcpp', name='ncmpcpp', **restore_focus))

wm.on_key('Mod+n')(
    spawn_or_raise('urxvtc -name mutt -e mutt', name='mutt', **restore_focus))

wm.on_key('Mod+i')(
    spawn_or_raise('urxvtc -name weechat -e weechat-curses', name='weechat', **restore_focus))

wm.on_key('Ctrl+Alt+m')(
    spawn_or_raise('urxvtc -name alsamixer -e alsamixer', name='alsamixer', **restore_focus))


@wm.on_key('Ctrl+Alt+c')
def toggle_console(wm):
    cd = wm.current_desktop
    if cd == 1:
        wm.set_current_desktop(0)
    else:
        clients = wm.find_client(wm.get_clients(), cls="URxvt")
        if clients:
            wm.set_current_desktop(1)
        else:
            spawn('urxvtc')(wm)

@wm.on_create
def bind_urxvt_keys(wm):
    if wm.is_match(wm.event_window, cls='URxvt'):
        wm.bind_key(wm.event_window, 'Shift+Right')(focus_next)
        wm.bind_key(wm.event_window, 'Shift+Left')(focus_prev)


def toggle_gimp_toolbars(wm, state=[True]):
    st = state[0] =  not state[0]

    clients = wm.get_clients()
    if st:
        image_window = wm.find_client(clients, cls='Gimp', role='gimp-image-window')
        if image_window:
            wm.focus_and_raise(image_window[0])
    else:
        for c in wm.find_client(clients, cls='Gimp', role='gimp-dock'):
            wm.place_window_above(c)

        for c in wm.find_client(clients, cls='Gimp', role='gimp-toolbox'):
            wm.place_window_above(c)

@wm.on_create
def bind_gimp_keys(wm):
    c = wm.event_window
    if wm.is_match(c, cls='Gimp', role='gimp-image-window') or \
            wm.is_match(c, cls='Gimp', role='gimp-dock') or \
            wm.is_match(c, cls='Gimp', role='gimp-toolbox'):

        wm.bind_key(c, 'Tab')(
            toggle_gimp_toolbars)


# Dirty workaround to fix openbox dumb behaviour

created_windows_without_desktop = []

@wm.on_create
def switch_to_desktop(wm):
    if not wm.startup:
        if wm.activate_window_desktop(wm.event.window) is None:
            created_windows_without_desktop.append((time.time(), wm.event.window))

@wm.on_property_change('_NET_WM_DESKTOP')
def desktop_change_for_created_window(wm):
    t = time.time()
    created_windows_without_desktop[:] = [
        r for r in created_windows_without_desktop if t - r[0] < 1]

    for t, w in created_windows_without_desktop:
        if w.id == wm.event.window.id:
            wm.activate_window_desktop(w)

@wm.on_property_change('_NET_WM_STATE')
def window_maximized_state_change(wm):
    state = wm.event_window.get_full_property(wm.event.atom, ATOM)
    undecorated_atom = wm.get_atom("_OB_WM_STATE_UNDECORATED")

    is_mv = state and wm.get_atom('_NET_WM_STATE_MAXIMIZED_VERT') in state.value
    is_mh = state and wm.get_atom('_NET_WM_STATE_MAXIMIZED_HORZ') in state.value
    is_undecorated = state and undecorated_atom in state.value

    if is_mv and is_mh and not is_undecorated:
        wm._send_event(wm.event_window, wm.event.atom, [1, undecorated_atom])
        wm.dpy.flush()
    elif is_undecorated and (not is_mv or not is_mh):
        wm._send_event(wm.event_window, wm.event.atom, [0, undecorated_atom])
        wm.dpy.flush()
