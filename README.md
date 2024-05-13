```
┌─────────────────────────────────────────────────────────────────────────────┐
│ ANSIBLE                                                                     │
│     _                _                        ____            _        _    │
│    / \   _ __   __ _| | ___   __ _ _   _  ___|  _ \ ___   ___| | _____| |_  │
│   / _ \ | ._ \ / _` | |/ _ \ / _` | | | |/ _ \ |_) / _ \ / __| |/ / _ \ __| │
│  / ___ \| | | | (_| | | (_) | (_| | |_| |  __/  __/ (_) | (__|   <  __/ |_  │
│ /_/   \_\_| |_|\__,_|_|\___/ \__, |\__,_|\___|_|   \___/ \___|_|\_\___|\__| │
│                              |___/                                          │
└─────────────────────────────────────────────────────────────────────────────┘
    \   ^__^
     \  (oo)\_______
        (__)\       )\/\
            ||----w |
            ||     ||
```

> An [Ansible](https://www.ansible.com/) playbook to easily populate a **SD card** for the [Analogue Pocket](https://www.analogue.co/pocket) with selected/custom content.

## :bookmark_tabs: Table of Contents

* [Disclaimer](#raised_hand-disclaimer)
* [Concept / Structure](#open_file_folder-concept--structure)
* [Features](#gift-features)
* [Requirements](#toolbox-requirements)
* [Installation](#package-installation)
* [Usage](#rocket-usage)
* [Configuration](#screwdriver-configuration)
* [Credits](#star-credits)
* [License](#balance_scale-license)

## :raised_hand: Disclaimer

This project is (obviously) inspired by [Matt Pannella](https://github.com/mattpannella)'s excellent [Analogue Pocket Updater Utility](https://github.com/mattpannella/pocket-updater-utility).

It does not claim to be simpler, faster, or better in any way.

So, why even bother?  
And why Ansible??? 

* For a task like this I personally prefer a more "scripted" approach; meaning no (pre-)built/native binaries.
* More transparency about what is actually going on is also nice. (Ansible is very verbose/talkative per se.)
* I'm aware that the original purpose of Ansible is _software provisioning_, _configuration management_, and _application deployment_ (of remote machines). However, Ansible is also perfect for simple "file handling" and IT automation in general; so we can use it locally on a workstation as well.
* Ansible playbooks are easy to read/understand and have a relatively simple execution flow.
* The Ansible script code might be easier to fiddle with for someone who has no programming background.
* I just :heart: Ansible... and enjoy using it. :smile:

## :open_file_folder: Concept / Structure

Instead of directly working on a SD card and downloading/modifying content in place, I prefer to start with a "clean slate" every time I run the script/playbook; making sure there are no "leftovers" from previous downloads/installations.

So the playbook (which includes several modularized "roles") will clean the actual target directory (located on my PC's HDD/SDD) with every run and freshly compile all content from several sources.

```text
┌─────────────────────────────────────────┐
│       analogue-pocket-playbook          │
├─────────────────────────────────────────┤
│ Roles:                                  │
│   - latest_firmware                     │
│   - openfpga_cores                      │
│   - retrodriven_assets                  │
│   - megazxretro_platform_art            │
│   - spiritualized1997_library_image_set │
│   - ...                                 │
└────────────────────┬────────────────────┘
                     │
                  download
                     │
        .────────────▼──────────────.
        │ content/.cached_downloads │
        `────────────┬──────────────`
                     │
                    copy
                     │
        .─ ─ ─ ─ ─ ─ ▼ ─ ─ ─ ─ ─ ─ ─.   .────────────────.
        │ content/.staged_downloads │   │ content/custom │
        `─ ─ ─ ─ ─ ─ ┬ ─ ─ ─ ─ ─ ─ ─`   `────────┬───────`
                     │                           │
                     └─────────────┬─────────────┘
                                   │
                               merge/copy
                                   │
                           .─ ─ ─ ─▼─ ─ ─ ─ .
                           │ content/sdcard │
                           `─ ─ ─ ─ ─ ─ ─ ─ `
```

These are the general execution steps:

1. The playbook will ask (interactively) which roles should be included/executed.
1. The folders `.staged_downloads` and `sdcard` will be **DELETED**.
1. The up-to-date content downloaded by roles will be put into the `.cached_downloads` folder first, before being copied to the `.staged_downloads` folder; upon re-runs, existing cached content will be used instead of pulling it again from the net.
1. The `custom` folder (which will always remain **UNTOUCHED** by the script) will - together with the `.staged_downloads` folder - get merged into the `sdcard` folder.
1. (MANUAL TASK: use any synchronization method of your choice to synchronize the `sdcard` folder with your actual SD card.)

**NOTE**

The `custom` folder is the place where you will have to put your own games, roms, firmwares, etc.

The directory structure must match the Pocket's original SD card structure!

```text
.
├── .cached_downloads
├── .staged_downloads
├── custom
│   ├── Assets
│   │   ├── nes
│   │   │   └── common
│   │   │       ├── mario.nes
│   │   │       └── zelda.nes
│   │   ├── genesis
│   │   │   └── common
│   │   │       └── sonic.bin
│   .   .
├── sdcard
.
```

## :gift: Features

All main features are implemented in dedicated roles:

| Role                                                                             | Description                                                                                                                                             |
|:---------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
| [latest_firmware](roles/latest_firmware)                                         | download **firmware** files from the official [Analogue](https://www.analogue.co/support) support site                                                  |
| [openfpga_cores](roles/openfpga_cores)                                           | download **cores** from the official [openFPGA Cores](https://openfpga-cores-inventory.github.io/analogue-pocket/) inventory                            |
| [retrodriven_assets](roles/retrodriven_assets)                                   | download curated **assets** from [RetroDriven](https://github.com/RetroDriven)'s repository                                                             |
| [megazxretro_platform_art](roles/megazxretro_platform_art)                       | download custom **platform artwork** images from [MegaZXretro](https://github.com/MegaZXretro/Analogue-Pocket-Custom-Platform-Art)                      |
| [spiritualized1997_library_image_set](roles/spiritualized1997_library_image_set) | download custom **library image set** from [spiritualized1997](https://www.reddit.com/r/AnalogueInc/comments/wbcvpp/analogue_pocket_library_image_set/) |

## :toolbox: Requirements

You should have [Python 3](https://www.python.org/downloads/) installed.

This project probably runs best on _*nix_ based systems. (Windows not tested.)

## :package: Installation

Simply clone this repo:

```
git clone https://github.com/4ch1m/ansible-analogue-pocket.git
```

## :rocket: Usage

Execute [analogue-pocket-playbook.sh](analogue-pocket-playbook.sh):

```
./analogue-pocket-playbook.sh
```

This will automatically create a virtual environment (`venv`) via Python and install [Ansible](https://pypi.org/project/ansible/) via [pip](https://packaging.python.org/en/latest/tutorials/installing-packages/#use-pip-for-installing).  
After that the actual playbook will be executed.

Once the playbook finished successfully you should find the final compiled content in this directory:

```
./content/sdcard
```

I usually use [rsync](https://rsync.samba.org/) to synchronize this folder with my actual mounted SD card, as a final/manual step:

```shell
rsync \
  --verbose \
  --recursive \
  --times \
  --whole-file \
  --delete \
  --delete-before \
  --progress \
  --stats \
  --temp-dir=$(mktemp --directory --suffix "_aap") \
  --exclude '/GB*Studio' \
  --exclude '/Memories' \
  --exclude '/Saves' \
  --exclude '/Settings' \
  --exclude '/System/*_cache.bin' \
  --exclude '/Analogue_Pocket.json' \
  ./content/sdcard/ \
  <path-to-your-actual-sdcard>
```

(Note: Some directories and cache-files should be ignored. The `/Analogue_Pocket.json` file is also excluded from the sync.)

## :screwdriver: Configuration

The playbook/roles have certain settings which can be customized.  
This can be done by creating a file called `custom.yml` in the [vars](vars) directory.  
(This file is excluded from version control; see [.gitignore](.gitignore))

```yaml
# add 'identifier' of cores you want to exclude
# (check: https://openfpga-cores-inventory.github.io/analogue-pocket/api/v2/cores.json)
custom_openfpga_core_excludes:
  - core-identifier-1
  - core-identifier-2

# additional excludes when synchronizing from '.staged_downloads' to 'sdcard' directory
custom_rsync_excludes:
  - '--exclude=LICENSE'

# use US platform artwork, instead of PAL-EU
custom_megazxretro_platform_art_region_filename: USA.ZIP

# remove 'JTBETA' cores (default = 'false')
remove_jt_beta_cores: true

# automatically rename 'jt' cores; e.g. 'jtbubl' -> 'Bubble Bobble' (default = 'false')
rename_jt_cores: true
```

## :star: Credits

Thanks to ...

* all the authors of [OpenFPGA Cores](https://openfpga-cores-inventory.github.io/analogue-pocket/) who make all this possible!
* [RetroDriven](https://github.com/RetroDriven) for providing validated assets
* [MegaZXretro](https://github.com/MegaZXretro) for the [Custom Platform Art](https://github.com/MegaZXretro/Analogue-Pocket-Custom-Platform-Art)
* [spiritualized1997](https://github.com/spiritualized1997) for  the great [Library Image Set](https://www.reddit.com/r/AnalogueInc/comments/wbcvpp/analogue_pocket_library_image_set/)
* [dyreschlock](https://github.com/dyreschlock) for the [Pocket Platform Images](https://github.com/dyreschlock/pocket-platform-images) repo

## :balance_scale: License

see [LICENSE](LICENSE) file
