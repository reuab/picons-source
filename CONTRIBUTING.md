# ISSUES

When submitting an issue, make sure you follow these rules:

- Entries to `srp-index` or `snp-index`, put them inside code blocks by using backticks ([help](https://guides.github.com/features/mastering-markdown)) or if they are really big, use a [gist](https://gist.github.com/).
- Logos should be inside an archive, correctly named (see below). Share the link.

# NAMING

__Serviceref:__

- UPPERCASE
- Only the part `296_5_85_C00000` is used, the parts `1_0_1_` and `_0_0_0` must be removed.

__Logo:__

- LOWERCASE
- NO spaces, fancy symbols or `.-+_*`, except for the exceptions below.
- Time sharing channels are seperated by `_`.
- Sometimes it's useful to add a country code, do it by putting `-gbr`, `-deu` or `-...` at the end of the name. Country codes can be found [here](https://gist.github.com/picons/0db7c14917397962a734).
- Filetype `svg` is the way to go, otherwise `png`.
- The resolution doesn't matter for `svg`, for `png` try to get it > 400px.
- When submitting `svg` files, make sure to convert `text` to `paths`.
- Quality should be as high as possible with transparancy.
- A `black` version or also a default logo should get the identifier `.black` at the end of the filename, a `white` version should get the identifier `.white`, a `black` version must always exist, a `white` version is optional.
- Don't forget to put `tv/` or `radio/` in front of the logo's name in `./build-source/snp-index` or `./build-source/srp-index`.

# SAMPLES

### SRP-INDEX

New additions can go at the top. No need to cleanup old entries, but if you want to, go right ahead.

```
1005_29_46_E080000=tv/eurosporthd
1006_29_46_E080000=tv/discoveryhdshowcase
1007_43_46_E080000=tv/tvnorgehd
1008_29_46_E080000=tv/bbchd
100E_3_1_E083163=tv/viasat6
1015_1D4C_FBFF_820000=tv/discoveryhd
1018_1D4C_FBFF_820000=tv/cielohd
1018_3_1_E083163=tv/novacinema
10_1_85_C00000=tv/fox
10_1_85_FFFF0000=tv/fox
1019_7DC_2_11A0000=tv/skymoviesboxoffice-gbr
1019_7EF_2_11A0000=tv/skymoviesboxoffice-gbr
101B_7DC_2_11A0000=tv/skymoviesboxoffice-gbr
101B_7EF_2_11A0000=tv/skymoviesboxoffice-gbr
101_E_85_C00000=tv/skybundesligahd-deu
```

### SNP-INDEX

New additions can go at the top. No need to cleanup old entries, but if you want to, go right ahead.

```
2843_7FE_2_11A0000=tv/bbcparliament
100procentnl=radio/100procentnl
cplusalademande=tv/canalplusalademande-fra
cpluscomedia=tv/canalpluscomedia-esp
cpluscomediahd=tv/canalpluscomediahd-esp
cplusdcine=tv/canalplusdcine-esp
cplusdcinehd=tv/canalplusdcinehd-esp
cplusdep2hd=tv/canalplusdeportes2hd-esp
cplusdeport2=tv/canalplusdeportes2-esp
cplusdeportes=tv/canalplusdeportes-esp
cplusdeporthd=tv/canalplusdeporteshd-esp
cplusestrenos=tv/canalplusestrenos-esp
cplusestrenoshd=tv/canalplusestrenoshd-esp
```
