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
- If the logo name you wish to use already exists, add a unique identifier like `-trechuhipe`, this is a pronounceable random 10 character string generated using [this](http://www.generate-password.com) password generator. Grouping togheter logos using the same unique identifier is possible.
- Filetype `svg` is the way to go, otherwise `png`.
- The resolution doesn't matter for `svg`, for `png` try to get it > 800px.
- When submitting `svg` files, make sure to convert `text` to `paths`.
- It's not allowed for `svg` files to contain base64 encoded images.
- If it's possible to easily trace your png with Inkscape, only the `svg` is allowed. In most cases this is possible.
- Quality should be as high as possible with transparancy.
- A `default` version of a logo should get the identifier `.default` at the end of the filename, a `light` version should get the identifier `.light`, a `default` version must always exist, a `light` version is optional. Additional types are possible, by using for example `dark`, `black`, `white`. At the moment only `default` and `light` types are being included in this project.

Explanation of logo types:
```
default=standard logo as used by the tv station, looks good on background intended by tv station
light=modified default logo that makes darker parts lighter, looks good on darker backgrounds
dark=modified default logo that makes lighter parts darker, looks good on lighter backgrounds
white=fully white logo, no colors allowed (indexed 1-bit, black/white), looks good on dark backgrounds
black=fully black logo, no colors allowed (indexed 1-bit, black/white), looks good on light backgrounds
```

# SAMPLES

### SRP-INDEX

New additions can go at the top. No need to cleanup old entries, but if you want to, go right ahead.

```
1005_29_46_E080000=eurosporthd
1006_29_46_E080000=discoveryhdshowcase
1007_43_46_E080000=tvnorgehd
1008_29_46_E080000=bbchd
100E_3_1_E083163=viasat6
1015_1D4C_FBFF_820000=discoveryhd
1018_1D4C_FBFF_820000=cielohd
1018_3_1_E083163=novacinema
10_1_85_C00000=fox
10_1_85_FFFF0000=fox
1019_7DC_2_11A0000=skymoviesboxoffice-trechuhipe
1019_7EF_2_11A0000=skymoviesboxoffice-trechuhipe
101B_7DC_2_11A0000=skymoviesboxoffice-trechuhipe
101B_7EF_2_11A0000=skymoviesboxoffice-trechuhipe
101_E_85_C00000=skybundesligahd-racratridr
```

### SNP-INDEX

New additions can go at the top. No need to cleanup old entries, but if you want to, go right ahead.

```
2843_7FE_2_11A0000=bbcparliament
100procentnl=100procentnl
cplusalademande=canalplusalademande-thukalafri
cpluscomedia=canalpluscomedia-radubrekac
cpluscomediahd=canalpluscomediahd-radubrekac
cplusdcine=canalplusdcine-radubrekac
cplusdcinehd=canalplusdcinehd-radubrekac
cplusdep2hd=canalplusdeportes2hd-radubrekac
cplusdeport2=canalplusdeportes2-radubrekac
cplusdeportes=canalplusdeportes-radubrekac
cplusdeporthd=canalplusdeporteshd-radubrekac
cplusestrenos=canalplusestrenos-radubrekac
cplusestrenoshd=canalplusestrenoshd-radubrekac
```
