import random
import logging

from subprocess import Popen, PIPE

logger = logging.getLogger('rsi')
KEYS = 'abcdefghijklmnopqrstuvwxyz'


def notify(title, body=None, timeout=-1):
    cmd = [
        'gdbus',
        'call',
        '--session',
        '--dest=org.freedesktop.Notifications',
        '--object-path=/org/freedesktop/Notifications',
        '--method=org.freedesktop.Notifications.Notify',
        'orcsome-rsi',
        '0',
        '',
        title,
        body,
        '[]',
        '{}',
        '{}'.format(int(timeout)),
    ]

    out, err = Popen(cmd, stdout=PIPE, stderr=PIPE).communicate()
    if err:
        raise Exception(err)

    return int(out.strip().split()[1].rstrip(',)'))


def close_notify(nid):
    cmd = [
        'gdbus',
        'call',
        '--session',
        '--dest=org.freedesktop.Notifications',
        '--object-path=/org/freedesktop/Notifications',
        '--method=org.freedesktop.Notifications.CloseNotification',
        '{}'.format(nid),
    ]

    out, err = Popen(cmd, stdout=PIPE, stderr=PIPE).communicate()
    if err:
        raise Exception(err)


def init(wm, work=None, rest=None, postpone=None, activity=None):
    work_time = (work or 55) * 60
    rest_time = (rest or 5) * 60
    postpone_time = (postpone or 5) * 60
    activity_time = (activity or 10) * 60

    class Rsi(object):
        def __init__(self):
            self.banner = 0

        def create_banner(self):
            self.banner = notify('Take break', self.password, rest_time * 1.1 * 1000)

        def destroy_banner(self):
            if self.banner:
                close_notify(self.banner)
                self.banner = 0

        def key_handler(self, is_press, state, code):
            if is_press:
                if self.password_idx >= len(self.password):
                    if wm.keycode('Return') == code:
                        self.stop_rest(True)
                    else:
                        self.password_idx = 0
                elif wm.keycode(self.password[self.password_idx]) == code:
                    self.password_idx += 1
                else:
                    self.password_idx = 0

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
        logger.info('Work timer')
        rsi.start_rest()

    @wm.on_timer(60)
    def idle_timer():
        if wm.get_screen_saver_info().idle / 1000.0 > activity_time:
            logger.info('Idle timer')
            work_timer.again()

    @wm.on_timer(rest_time)
    def rest_timer():
        logger.info('Rest timer')
        rsi.stop_rest()

    @wm.on_timer(postpone_time)
    def postpone_timer():
        logger.info('Postpone timer')
        rsi.start_rest()

    work_timer.start()
    idle_timer.start()
    return rsi
