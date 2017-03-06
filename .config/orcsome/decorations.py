from orcsome import get_wm

wm = get_wm()


# Shortcut to test maximizing, you can do it with openbox config
@wm.on_key('Ctrl+Mod+space')
def maximize_window():
    w = wm.current_window
    if w.maximized_vert and w.maximized_horz:
        wm.set_window_state(w, vmax=False, hmax=False)
    else:
        wm.set_window_state(w, vmax=True, hmax=True)


@wm.on_manage
def on_manage():
    @wm.on_property_change(wm.event_window, '_NET_WM_STATE')
    def property_was_set():
        w = wm.event_window
        if w.maximized_vert and w.maximized_horz:
            if w.decorated:
                wm.set_window_state(w, decorate=False)
        else:
            if not w.decorated:
                wm.set_window_state(w, decorate=True)
