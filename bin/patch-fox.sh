#!/bin/bash
set -e
omni=${1:-/usr/lib/firefox/browser/omni.ja}
workdir=/tmp/patch-fox.tmp

[ -f "$omni" ] || { echo "$omni not found"; exit 1; }

[ -d $workdir ] && rm -rf $workdir
mkdir $workdir

cd $workdir
unzip -q "$omni" || true

cat <<EOF | patch -p1
diff -aur orig/chrome/browser/content/browser/devtools/netmonitor-view.js new/chrome/browser/content/browser/devtools/netmonitor-view.js
--- orig/chrome/browser/content/browser/devtools/netmonitor-view.js     2010-01-01 00:00:00.000000000 +0300
+++ new/chrome/browser/content/browser/devtools/netmonitor-view.js      2014-09-18 21:23:38.047201746 +0400
@@ -1654,7 +1654,7 @@
     if (!(aUrl instanceof Ci.nsIURL)) {
       aUrl = nsIURL(aUrl);
     }
-    let name = NetworkHelper.convertToUnicode(unescape(aUrl.fileName)) || "/";
+    let name = NetworkHelper.convertToUnicode(unescape(aUrl.filePath)) || "/";
     let query = NetworkHelper.convertToUnicode(unescape(aUrl.query));
     return name + (query ? "?" + query : "");
   },
EOF

zip -qr9XD omni.ja *
echo "Going to replace $omni ..."
sudo cp omni.ja "$omni"
echo "Done"
firefox --purgecaches
