from orcsome import get_wm
from orcsome.actions import *

import rsi

wm = get_wm()

wm.on_key('Shift+Mod+r')(
    restart)

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

wm.on_key('Mod+i')(
    spawn_or_raise('urxvtc -name weechat -e weechat-curses', name='weechat'))

wm.on_key('Mod+l')(
    spawn_or_raise('fmd', cls='Fmd'))


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
    spawn_or_raise('urxvtc -name mutt -e mutt', name='mutt', **restore_focus))

wm.on_key('Ctrl+Alt+m')(
    spawn_or_raise('urxvtc -name alsamixer -e alsamixer', name='alsamixer', **restore_focus))

wm.on_key('Mod+k')(
    spawn_or_raise('urxvtc -name rtorrent -e rtorrent-screen', name='rtorrent', **restore_focus))


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
            spawn('urxvtc')()

@wm.on_create(cls='URxvt')
def bind_urxvt_keys():
    wm.on_key(wm.event_window, 'Shift+Right')(focus_next)
    wm.on_key(wm.event_window, 'Shift+Left')(focus_prev)


###################################
# Gimp toolbar switching on Tab key
last_image_window = [None]

@wm.on_create(cls='Gimp', role='gimp-image-window|gimp-dock|gimp-toolbox$')
def bind_gimp_keys():
    @wm.on_key(wm.event_window, 'Tab')
    def toggle_gimp_toolbars():
        cw = wm.current_window
        clients = wm.get_stacked_clients()

        if wm.is_match(cw, role='gimp-image-window'):
            gimp_windows = wm.find_clients(clients,
                cls='Gimp', role='gimp-image-window|gimp-dock|gimp-toolbox')

            if cw.id == gimp_windows[-1].id:
                last_image_window[0] = cw

                for c in wm.find_clients(clients, cls='Gimp', role='gimp-dock|gimp-toolbox'):
                    wm.place_window_above(c)
            else:
                wm.place_window_above(cw)

        else:
            w = last_image_window[0] or wm.find_client(clients, cls='Gimp', role='gimp-image-window')
            if w:
                wm.focus_and_raise(w)


################################################
# Workaround to fix openbox dumb behaviour
@wm.on_create
def switch_to_desktop():
    if not wm.startup:
        if wm.activate_window_desktop(wm.event_window) is None:

            @wm.on_property_change(wm.event_window, '_NET_WM_DESKTOP')
            def property_was_set():
                wm.activate_window_desktop(wm.event_window)
                property_was_set.remove()


###################################
# Handle window maximaze/unmaximize
@wm.on_property_change('_NET_WM_STATE')
def window_maximized_state_change():
    state = wm.get_window_state(wm.event_window)

    if state.maximized_vert and state.maximized_horz and not state.undecorated:
        wm.decorate_window(wm.event_window, False)
    elif state.undecorated and (not state.maximized_vert or not state.maximized_horz):
        wm.decorate_window(wm.event_window)

@wm.on_init
def init():
    r = rsi.init()

    @wm.on_key('Mod+b')
    def do_rest():
        r.start_rest()