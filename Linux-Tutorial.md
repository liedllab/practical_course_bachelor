## Linux-Tutorial

Die folgende Seite dient erklärt einige der grundlegenden Befehle zum arbeiten in der Linux Kommandozeile. Die folgende Tabelle ist hierzu eine Zusammenfassung der wichtigsten Befehle.


| Command | Description | Example |
|---------|-------------|---------|
| `ls` | List directory contents. | `ls` |
| `cd` | Change directory. | `cd /path/to/directory` |
| `pwd` | Show current directory. | `pwd` |
| `mkdir` | Create a new directory. | `mkdir new_directory` |
| `rmdir` | Remove an empty directory. | `rmdir empty_directory` |
| `rm` | Delete files or directories. | `rm file.txt` |
| `touch` | Create an empty file. | `touch new_file.txt` |
| `cp` | Copy files or directories. | `cp file.txt /path/to/destination` |
| `mv` | Move or rename files. | `mv file.txt /path/to/new_location` |
| `cat` | Display file contents. | `cat file.txt` |
| `nano` / `vim` | Edit files in terminal. | `nano file.txt` |
| `find` | Search for files in a directory hierarchy. | `find . -name "file.txt"` |
| `grep` | Search text using patterns. | `grep "pattern" file.txt` |
| `tar` | Archive and compress files. | `tar -cvf archive.tar file1.txt file2.txt` |
| `df` | Show disk usage of file systems. | `df` |
| `du` | Show directory/file size. | `du -sh /path/to/directory` |
| `chmod` | Change file permissions. | `chmod 755 file.txt` |
| `chown` | Change file owner. | `chown user:group file.txt` |
| `mount` | Mount a filesystem. | `mount /dev/sdb1 /mnt` |
| `umount` | Unmount a filesystem. | `umount /mnt` |


#### Übersicht Text-Editoren in Linux

Linux bietet eine Vielzahl von Texteditoren, die in der Kommandozeile verwendet werden können. Hier sind einige der beliebtesten:

**Nano Editor**

Dieser Editor ist benutzerfreundlich und einfach zu bedienen und hat außerdem ein einfaches Interface. Hier eine Liste der wichtigsten Befehle:

+ __Undo__ in nano: `Alt + U` 
+ __Move to end of line__: `Ctrl + E`
+ __Save and Exit Nano__    : `Ctrl + X`, dann `Y` und `Enter`
+ __Search in Nano__: `Ctrl + W`, dann Suchbegriff eingeben und `Enter`

**Kate Editor**

Kate ist ein grafischer Texteditor der in vielen Linux-Distributionen vorinstalliert ist. Dieser ist am ähnlichsten zu Notepad und Word damit sehr einfach zu bedienen.

**Vim Editor**

Vim ist ein leistungsstarker und vielseitiger Texteditor, der in der Kommandozeile verwendet wird. Er hat eine steilere Lernkurve als Nano, bietet aber viele erweiterte Funktionen für erfahrene Benutzer. Hier eine Liste der wichtigsten Befehle:

+ __Enter Insert Mode__: `i` (um Text einzufügen)
+ __Exit Insert Mode__: `Esc` (um in den Befehlsmodus zurückzukehren)
+ __Save Changes__: `:w` (im Befehlsmodus, dann `Enter`)
+ __Save and Exit__: `:wq` (im Befehlsmodus, dann `Enter`)
+ __Exit without Saving__: `:q!` (im Befehlsmodus, dann `Enter`)
+ __Search__: `/suchbegriff` (im Befehlsmodus, dann `Enter`)
+ __Undo__: `u` (im Befehlsmodus)
+ __Redo__: `Ctrl + r` (im Befehlsmodus)
+ __Delete Line__: `dd` (im Befehlsmodus)
+ __Copy Line__: `yy` (im Befehlsmodus)
+ __Paste Line__: `p` (im Befehlsmodus)

