from time import time
import subprocess
import random

import orcsome
from orcsome.utils import Timer

keys = 'abcdefghijklmnopqrstuvwxyz'

class RsiPreventer(object):
    def __init__(self, wm, work=None, rest=None, postpone=None, activity=None):
        self.wm = wm

        self.work_time = work or 55
        self.rest_time = rest or 5
        self.postpone_time = postpone or 5
        self.activity_time = activity or 10

        self.working = True
        self.last_rest = time()
        self.last_work = time()
        self.last_check = time()
        self.last_idle = 0

    def idle(self):
        self.wm.emit('get_idle')

    def check(self):
        now = time()
        self.last_check, last_check = now, self.last_check

        if now - last_check > 60 or self.last_idle > self.activity_time * 60:
            self.last_rest = now
            return

        if self.working and now - self.last_rest > self.work_time*60:
            self.wm.emit('start_rest')

        if not self.working and now - self.last_work > self.rest_time*60:
            self.wm.emit('stop_rest')

    def create_banner(self):
        self.banner = subprocess.Popen(['/usr/bin/env', 'dzen2', '-p', str(self.rest_time*70),
            '-y', '20', '-x', '850', '-h', '24', '-bg', '#222222', '-fg', '#aaaaaa'],
            stdin=subprocess.PIPE)

        self.banner.stdin.write('Take break %s\n' % self.password)
        self.banner.stdin.close()

    def destroy_banner(self):
        if self.banner:
            if not self.banner.poll():
                try:
                    self.banner.terminate()
                    self.banner.wait()
                except OSError:
                    pass

            self.banner = None

    def key_handler(self, is_press, state, code):
        if is_press:
            if self.password_idx >= len(self.password):
                if self.wm.keycode('Return') == code:
                    self.stop_rest(True)
                else:
                    self.password_idx = 0
            elif self.wm.keycode(self.password[self.password_idx]) == code:
                self.password_idx += 1
            else:
                self.password_idx = 0

    def start_rest(self):
        if self.wm.grab_pointer(True) and self.wm.grab_keyboard(self.key_handler):
            self.password = ''.join(random.choice(keys) for _ in range(10))
            self.password_idx = 0

            self.create_banner()
            self.working = False
            self.last_work = time()
        else:
            self.wm.ungrab_keyboard()
            self.wm.ungrab_pointer()

    def stop_rest(self, postpone):
        self.working = True
        self.last_rest = time()
        if postpone:
            self.last_rest = self.last_rest - self.work_time*60 + self.postpone_time*60

        self.wm.ungrab_keyboard()
        self.wm.ungrab_pointer()

        self.destroy_banner()


def init(work=None, rest=None, postpone=None, activity=None):
    wm = orcsome.get_wm()
    rsi = RsiPreventer(wm, work, rest, postpone, activity)

    @wm.on_signal('start_rest')
    def start_rest():
        rsi.start_rest()

    @wm.on_signal('stop_rest')
    def stop_rest():
        rsi.stop_rest(False)

    @wm.on_signal('get_idle')
    def get_idle():
        rsi.last_idle = wm.root.get_screen_saver_info().idle / 1000.0

    t1 = Timer(10, rsi.check)
    t1.start()

    t2 = Timer(60, rsi.idle)
    t2.start()

    @wm.on_deinit
    def deinit():
        t1.cancel()
        t2.cancel()
        print 'rsi.close'

    return rsi
