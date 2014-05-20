import random
import logging

from orcsome import notify

logger = logging.getLogger('rsi')
KEYS = 'abcdefghijklmnopqrstuvwxyz'

def init(wm, work=None, rest=None, postpone=None, activity=None):
    work_time = (work or 55) * 60
    rest_time = (rest or 5) * 60
    postpone_time = (postpone or 5) * 60
    activity_time = (activity or 10) * 60

    class Rsi(object):
        def __init__(self):
            self.banner = None

        def create_banner(self):
            self.banner = notify.notify('Take break', self.password, rest_time * 1.1)

        def destroy_banner(self):
            if self.banner:
                self.banner.close()
                self.banner = None

        def key_handler(self, is_press, state, code):
            if is_press:
                if self.password_idx >= len(self.password):
                    if wm.keycode('Return') == code:
                        self.stop_rest(True)
                    else:
                        self.password_idx = 0
                elif wm.keycode(self.password[self.password_idx]) == code:
                    self.password_idx += 1
                    self.banner.update(body='{}\n{}'.format(self.password,
                        self.password[:self.password_idx]))
                else:
                    self.password_idx = 0
                    self.banner.update(body=self.password)

        def start_rest(self):
            if wm.grab_pointer(True) and wm.grab_keyboard(self.key_handler):
                self.password = ''.join(random.choice(KEYS) for _ in range(10))
                self.password_idx = 0

                self.create_banner()

                work_timer.stop()
                idle_timer.stop()
                postpone_timer.stop()
                rest_timer.again()
            else:
                wm.ungrab_keyboard()
                wm.ungrab_pointer()

        def stop_rest(self, postpone=False):
            rest_timer.stop()

            if postpone:
                postpone_timer.again()
            else:
                postpone_timer.stop()
                work_timer.again()
                idle_timer.again()

            wm.ungrab_keyboard()
            wm.ungrab_pointer()
            self.destroy_banner()

    rsi = Rsi()

    @wm.on_timer(work_time)
    def work_timer():
        rsi.start_rest()

    @wm.on_timer(60)
    def idle_timer():
        if wm.get_screen_saver_info().idle / 1000.0 > activity_time:
            work_timer.again()

    @wm.on_timer(rest_time)
    def rest_timer():
        rsi.stop_rest()

    @wm.on_timer(postpone_time)
    def postpone_timer():
        rsi.start_rest()

    work_timer.start()
    idle_timer.start()
    return rsi
