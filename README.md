# ABOUT

All the full resolution channel logos and their link to the actual channel (=serviceref) are kept up2date in this repository. The end result are picons for Enigma2 tuners and Kodi mediacenter in combination with a compatible PVR backend.

# BUILDING THE PICONS

[Ubuntu](http://www.ubuntu.com/download) and [Cygwin on Windows](https://cygwin.com/install.html) are tested and supported platforms for building the picons.

Download the repository by using the following command:
```
git clone https://github.com/picons/picons-source.git /tmp/picons-source
```

Next, copy your `enigma2` folder, your `tvheadend` folder or your `channels.conf` file to `/tmp/picons-source/build-input`. See the following [README](https://github.com/picons/picons-source/blob/master/build-input/README.md) for more info.

We will start the creation of the servicelist with the following command:
```
/tmp/picons-source/1-build-servicelist.sh
```


If all goes well, you'll end up with a new file located in the folder `/tmp/picons-source/build-output`, similar to the files [servicelist-enigma2-snp](https://raw.githubusercontent.com/picons/picons-samples/master/servicelist-enigma2-snp) and [servicelist-enigma2-srp](https://raw.githubusercontent.com/picons/picons-samples/master/servicelist-enigma2-srp).

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
./2-build-picons.sh snp 100x60-86x46
./2-build-picons.sh snp 100x60-86x46 all
./2-build-picons.sh srp 100x60-86x46 dark.on.reflection
./2-build-picons.sh snp-full 100x60-86x46 dark.on.reflection
...
```

# CONTRIBUTING

So you would like to contribute? Have a look [here](https://github.com/picons/picons-source/blob/master/CONTRIBUTING.md), just so you'll know the rules.

# SNP - SERVICE NAME PICONS

The idea behind SNP is that a simplified name derived from the channel name is used to lookup a channel logo. The idea and code was first implemented by OpenVIX for the Enigma2 tuners. Any developer currently using the serviceref method as a way to lookup a logo and would like to implement this alternative, can find the code used to generate the simplified name at the OpenVIX github [repository](https://github.com/OpenViX/enigma2/blob/master/lib/python/Components/Renderer/Picon.py#L88-L89).
