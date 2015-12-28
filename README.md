# ABOUT

All the full resolution channel logos and their link to the actual channel (=serviceref) are kept up2date in this repository. The end result are picons for Enigma2 tuners and Kodi mediacenter in combination with a compatible PVR backend.

# BUILDING THE PICONS

[Ubuntu](http://www.ubuntu.com/download), [Cygwin on Windows](https://cygwin.com/install.html) and [Docker](https://www.docker.com/toolbox) are tested and supported platforms for building the picons.

Download the repository by using the following command:
```
git clone https://github.com/picons/picons-source.git /tmp/picons-source
```

Next, copy your `enigma2` folder, your `tvheadend` folder or your `channels.conf` file to `/tmp/picons-source/build-input`.

We will start the creation of the servicelist with the following command:
```
/tmp/picons-source/1-build-servicelist.sh
```


If all goes well, you'll end up with a new file located in the folder `/tmp/picons-source/build-output`, similar to the files [servicelist-enigma2-snp](https://gist.githubusercontent.com/picons/64f50aec02244e7af1e2/raw/df223a0d3a83f1bf867c49bf566b4a0c4285304b/servicelist-enigma2-snp) and [servicelist-enigma2-srp](https://gist.githubusercontent.com/picons/f7a16dcc8886367954ef/raw/c2d68acec3713c6df18a3eab88c10a69f1acd7c4/servicelist-enigma2-srp).

To start the actual building process of the picons, use the following command:
```
/tmp/picons-source/2-build-picons.sh
```

Take a look at the folder `/tmp/picons-source/build-output` for the binaries.

TIP: To automate the building process, you can also use some of the following commands:

```
./1-build-servicelist.sh srp
./1-build-servicelist.sh snp
./2-build-picons.sh srp-full
./2-build-picons.sh srp-full all
./2-build-picons.sh snp-full
./2-build-picons.sh snp-full all
./2-build-picons.sh snp
./2-build-picons.sh srp
./2-build-picons.sh snp all
./2-build-picons.sh snp 100x60
./2-build-picons.sh snp 100x60 all
./2-build-picons.sh srp 100x60 reflection-black
./2-build-picons.sh snp-full 100x60 reflection-black
...
```

# DOCKER

If you would like to use Docker on Windows, which is recommended, because it's considerably faster than Cygwin. Use the following commands:

```
mkdir -p ~/Desktop/picons-source/build-input
mkdir -p ~/Desktop/picons-source/build-output
docker pull picons/picons
docker run -t -i -v //c/Users/<USER_NAME>/Desktop/picons-source/build-input:/tmp/picons-source/build-input -v //c/Users/<USER_NAME>/Desktop/picons-source/build-output:/tmp/picons-source/build-output picons/picons
git pull
./1-build-servicelist.sh
./2-build-picons.sh
exit
```

# CONTRIBUTING

So you would like to contribute? Have a look [here](https://github.com/picons/picons/blob/master/CONTRIBUTING.md), just so you'll know the rules.

# SNP - SERVICE NAME PICONS

The idea behind SNP is that a simplified name derived from the channel name is used to lookup a channel logo. The idea and code was first implemented by OpenVIX for the Enigma2 tuners. Any developer currently using the serviceref method as a way to lookup a logo and would like to implement this alternative, can find the code used to generate the simplified name at the OpenVIX github [repository](https://github.com/OpenViX/enigma2/blob/master/lib/python/Components/Renderer/Picon.py#L88-L89).
