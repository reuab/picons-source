A file `backgrounds.conf` should be placed in this folder. If no file is found, the default file will be used.

Syntax:
```
<resolution>;<resolution-padding>;<logotype>;<background>
```

Example:
```
# My own awesome settings
100x60;86x46;dark;reflection
100x60;100x60;default;transparent
100x60;100x60;light;transparent

# My commented settings
#800x450;800x450;light;transparent
```

### Enigma2
Copy your `enigma2` folder, probably located in `/etc` on your box into this folder.

### TvHeadend
TvHeadend users, have two options:

1) Use the server generated configuration files by copying your `tvheadend` configuration folder, probably located in `/home/hts/.hts` on your server into this folder.

2) Use the servers API and directly ask the server about all channels by creating a file called `tvheadend.serverconf`.

The first option has the advantage to work even without a running server. The advantage of the second option is that you don't have to copy files around, automatically you'll have the most accurate channel list and it's about 20% faster.

The file `tvheadend.serverconf` can contain the following values:

```sh
# hostname or ip address of tvheadend server (default: "localhost")
TVH_HOST="localhost"

# port of tvheadend API (default: 9981)
TVH_PORT="9981"

# tvheadend user name
TVH_USER=""

# tvheadend password of above user
TVH_PASS=""
```

You need only those values in your file which are different from the default values. For most people this will be a file with a single host name or host IP address.

```sh
TVH_HOST="my.tvheadend.server"
```

If you're running TvHeadend on the same machine, even an empty file (defaulting to `localhost`) should be sufficient.

### VDR
If you're using VDR together with the Kodi addon xvdr, copy your `channels.conf` file to this folder.
