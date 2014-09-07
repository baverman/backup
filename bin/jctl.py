#!/usr/bin/env python2
import sys
import readline
import cmd

from subprocess import Popen, PIPE

class Port(object):
    def __init__(self, name):
        self.name = name
        self.is_out = None
        self.connections = []

def format_ports(ports):
    for name in sorted(ports):
        port = ports[name]
        if port.connections:
            print port.name, '->' if port.is_out else '<-', ', '.join(port.connections)
        else:
            print port.name

def get_ports():
    out, _ = Popen(['jack_lsp', '-cp'], stdout=PIPE).communicate()
    result = {}

    port = None
    for line in out.splitlines():
        sline = line.strip()
        if sline == line.rstrip():
            port = Port(sline)
            result[port.name] = port
        elif sline.startswith('properties:'):
            if 'input' in sline:
                port.is_out = False
            elif 'output' in sline:
                port.is_out = True
        else:
            port.connections.append(sline)

    return result

def filter_ports(ports, prefix, is_out=None, connected=None):
    return [p.name for p in ports.itervalues()
        if (is_out is None or p.is_out == is_out)
            and (connected is None or p.connections)
            and p.name.startswith(prefix)]

def filter_mports(ports, *p):
    return map(lambda r: filter_ports(ports, r), p)

def connect(output, input):
    Popen(['jack_connect', output, input]).wait()

def disconnect(output, input):
    Popen(['jack_disconnect', output, input]).wait()

class JackCmd(cmd.Cmd):
    prompt = 'jctl: '

    def do_l(self, line):
        """Print existing jack ports"""
        format_ports(get_ports())

    def do_c(self, line):
        """Connect ports"""
        ports = get_ports()
        output, input = filter_mports(ports, *line.split())
        if len(output) == 1:
            output = output * len(input)

        for o, i in zip(output, input):
            connect(o, i)

    def do_r(self, line):
        """Replace port connections"""
        ports = get_ports()
        output, input = filter_mports(ports, *line.split())

        for p in output + input:
            for c in ports[p].connections:
                disconnect(p, c)

        if len(output) == 1:
            output = output * len(input)

        for o, i in zip(output, input):
            connect(o, i)

    def do_d(self, line):
        """Disconnect ports"""
        ports = get_ports()
        parts = filter_mports(ports, *line.split())
        if len(parts) == 1:
            p1, p2 = parts[0], []
        else:
            p1, p2 = parts

        for p in p1:
            for c in ports[p].connections:
                if not p2 or c in p2:
                    disconnect(p, c)

    def complete_c(self, text, line, start, stop):
        ports = get_ports()
        is_out = len(line.split()) <= 2 and line[-1] != ' '
        return filter_ports(ports, text, is_out)

    def complete_r(self, *args):
        return self.complete_c(*args)

    def complete_d(self, text, line, start, stop):
        ports = get_ports()
        parts = line.split()
        if len(parts) < 3 and line[-1] != ' ':
            return filter_ports(ports, text, connected=True)
        else:
            cports = filter_ports(ports, parts[1], connected=True)
            return list({r for p in cports for r in ports[p].connections if r.startswith(text)})

    def do_EOF(self, line):
        print
        sys.exit()

if __name__ == '__main__':
    cdelims = readline.get_completer_delims()
    readline.set_completer_delims(cdelims.replace(':', ''))
    JackCmd().cmdloop()
