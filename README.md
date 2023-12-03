### addman.sh
World of Warcraft addon "manager".
Automatically installs and updates your addons, does nothing more than that. It only pulls from CurseForge, so if you use something like ElvUI that is not hosted on CurseForge, you're still gonna have to update that manually.

This program is very likely extremely fragile, and is subject to break at any moment, but at least it's simple to use.


> #### Usage: 
> - Put your addon path in config.sh
> - Add addons by creating directories in ./addons with the name of the addon exactly as it's written in the CurseForge url.
> - Run, it should now just automatically download and extract the addons.

I've left my own path in config.sh, in case that somehow comes in handy.
Additionally, this is what my ./addons looks like:
```
└── addons
    ├── deadly-boss-mods
    ├── deadly-boss-mods-dbm-dungeons
    ├── details
    ├── mythic-dungeon-tools
    ├── omnicd
    ├── plater-nameplates
    ├── plumber
    ├── premade-groups-filter
    ├── simulationcraft
    └── weakauras-2
```

This will most likely only run on Linux, I hardcoded /usr/bin/chromedriver on line 8 of get-zip-url.py, which will *definitely* not work on Windows, but if this is fixed I suppose it should work just fine provided you've got bash, wget, and unzip.

> #### Requirements (Ubuntu):
> - python3
> - python3-selenium
> - chromium-chromedriver
> - unzip
> - wget