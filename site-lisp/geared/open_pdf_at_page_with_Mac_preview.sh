#!/bin/bash
# Nigel Garvey http://macscripter.net/edit.php?id=153677
osascript <<END! - "$@"
on run {pathToPDF, pageNum}
set pdfFile to pathToPDF as POSIX file
tell application "Preview" to open pdfFile

tell application "System Events"
tell application process "Preview"
set frontmost to true
-- Execute an option-command-"g" keystroke to get the "Go to page…" dialog.
keystroke "g" using {option down, command down}
-- The dialog's a sheet in Preview 5.0.3. Wait for it to appear.
repeat until sheet 1 of window 1 exists
delay 0.2
end repeat
-- "Type in" the page number and press Return.
keystroke pageNum
keystroke return
end tell
end tell
end run
END!