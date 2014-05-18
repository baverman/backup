from ranger.api.commands import Command
from pprint import pformat

def log(boo):
    with open('/tmp/boo.log', 'w') as f:
        f.write(boo)


class sync_names(Command):
    def execute(self):
        cwd = self.fm.thisdir
        items = cwd.marked_items

        if len(items) < 2:
            self.fm.notify('You must select two files at least', bad=True)
            return

        extensions = set(r.extension for r in items)
        if len(extensions) < len(items):
            self.fm.notify("Can't sync files with similar extensions", bad=True)
            return

        basefile = sorted(items, key=lambda r: r.size)[-1]
        name = basefile.basename
        if basefile.extension:
            name = name[:-len(basefile.extension) - 1]

        for r in items:
            if r is basefile:
                continue

            if r.extension:
                newname = name + '.' + r.extension
            else:
                newname = name

            if newname != name:
                self.fm.rename(r, newname)

        self.fm.thisdir.mark_all(False)
        self.fm.thisdir.move_to_obj(basefile)
        self.fm.ui.status.need_redraw = True
        self.fm.ui.need_redraw = True