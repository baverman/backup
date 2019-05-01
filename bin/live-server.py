#!/usr/bin/env python
import os.path
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--port', type=int, default=8080, help='serve port')
    parser.add_argument('--root', help='Web root')

    args = parser.parse_args()
    if args.root:
        os.chdir(args.root)

    os.execlp('uwsgi', 'uwsgi',
              '--wsgi-file', __file__,
              '--need-app',
              '--http', ':{}'.format(args.port),
              '--http-websockets',
              '--offload-threads', '1',
              '--enable-threads',
              '--async', '100',
              '--ugreen')


import uwsgi
import fcntl
import json
import threading


def jroot(*parts):
    return os.path.join(os.path.dirname(__file__), *parts)


class Event(object):
    def __init__(self):
        self.fdr, self.fdw = os.pipe()
        fl = fcntl.fcntl(self.fdr, fcntl.F_GETFL)
        fcntl.fcntl(self.fdr, fcntl.F_SETFL, fl | os.O_NONBLOCK)

    def fire(self, event):
        os.write(self.fdw, event)

    def wait(self):
        uwsgi.wait_fd_read(self.fdr, 10)

    def event(self):
        try:
            return os.read(self.fdr, 1024)
        except IOError:
            pass

    def close(self):
        os.close(self.fdr)
        os.close(self.fdw)


events = set()

def change_detector():
    fifo_name = '/tmp/live-server.fifo'
    if os.path.exists(fifo_name):
        os.unlink(fifo_name)

    os.mkfifo(fifo_name)
    while True:
        fd = os.open(fifo_name, os.O_RDONLY)
        os.read(fd, 1024)
        os.close(fd)
        for e in list(events):
            e.fire(b'1')

t = threading.Thread(target=change_detector)
t.daemon = True
t.start()


def ws(env):
    uwsgi.websocket_handshake(env['HTTP_SEC_WEBSOCKET_KEY'],
                              env.get('HTTP_ORIGIN', ''))
    e = Event()
    events.add(e)
    try:
        while True:
            try:
                uwsgi.websocket_recv_nb()
            except OSError:
                break
            yield e.wait()
            if e.event():
                assets = json.dumps(['boo', 'foo'])
                uwsgi.websocket_send(assets)
    finally:
        events.remove(e)
        e.close()


def response(start_response, status, body=b'',
             content_type='plain/text', headers=None):
    if isinstance(body, type(u'')):
        body = body.encode('utf-8')

    headers = headers or {}
    headers['Content-Type'] = content_type
    headers['Content-Length'] = str(len(body))
    start_response(status, list(headers.items()))
    return [body]


def application(env, start_response):
    if env['PATH_INFO'] == '/_ws':
        return ws(env)
    elif env['PATH_INFO'].startswith('/_/'):
        return response(start_response, '200 OK', FRAME, 'text/html')

    path = env['PATH_INFO'].lstrip('/')
    content_type = 'text/plain'
    if path.endswith('.js'):
        content_type = 'text/javascript'
    elif path.endswith('.html'):
        content_type = 'text/html'
    elif path.endswith('.css'):
        content_type = 'text/css'
    elif path.endswith('.svg'):
        content_type = 'image/svg+xml'

    try:
        content = open(path, 'rb').read()
    except IOError:
        return response(start_response, '404 NOT FOUND', 'Not found')

    return response(start_response, '200 OK', content,
                    content_type, {'Cache-Control': 'no-cache'})


FRAME = b'''
<html>
<head>
    <style>
        body {
            margin: 0;
        }

        .container {
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            overflow: hidden;
        }

        #cframe {
            width: 100%;
            height: 100%;
            border: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <iframe id="cframe" src=""></iframe>
    </div>

    <script>
        function listen() {
            var frame = document.getElementById('cframe');
            var url = window.location.pathname + window.location.search
            frame.contentWindow.location = url.slice(2) || '/';
            console.log(url.slice(2));

            var ws = new WebSocket('ws://' + window.location.host + '/_ws');
            ws.onopen = function() {
            }

            ws.onmessage = function(event) {
                frame.contentWindow.location.reload();
            }

            ws.onclose = function(event) {
                listen();
            }

            ws.onerror = function(event) {
                alert(event);
            }
        }
        listen();
    </script>
</body>
</html>
'''
