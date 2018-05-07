- [Abstract](#org5510da6)
  - [Warning](#org393dac9)
- [Installation](#org5be8ab2)
- [Emacs](#org427ff16)
- [Package sources](#orga023c70)
- [Wallpapers](#org13100e0)
- [References](#org4183b14)



<a id="org5510da6"></a>

# Abstract

Everyone loves setting up their system from scratch as easy as possible. org layerThat's why much smarter people than me has come up with the idea of *dotfiles*. A collection of scripts, configuration-files and system settings that can make your whole *system installation* as seamless as possible. My final goal with this 'project' of sorts is to be able to install fresh Debian, run one *master .sh file* and then just wait couple of hours unitl everything is getting ready by itself&#x2026;time in which I can, I don't know, drink tea and watch movies or something.


<a id="org393dac9"></a>

## Warning

**Please!** Do not run any of my scripts without understanding what they do. Look at the config files and choose the settings that you like and discard those you don't. Creating your dotfiles is pretty much an art.


<a id="org5be8ab2"></a>

# Installation

Clone as normal and just execute the scripts for the diffetent things. The `.sh` files are located at the root of the repository and their names are self-explenatory.

    git clone https://github.com/palikar/dotfiles
    cd dotfiles
    sudo bash setup-all.sh

*Note:* In my system I keep all of my development files(including my dotfiles) in folder called `code` and located at my home directory. Some of my setup sctipts asume that this is infact the case so if you are going to use the, please make the neccessery changes. // For not I've setup things for:

-   `.emacs` - my editor of choice
-   `.alias` - some useful abbriviations for certain commands in the terminal
-   `.env` - setting up some basic environment variables
-   `.inputrc` - some minor fixes for better typing in the terminal
-   `.gitconfig` - making `git` more pleasent to work with. Mainly diffetent abbriviations for git-commands

// `package_list.txt` is a file the countains all `apt` packages that I can imagine myself using. `package_all.txt` containts list of all packages that I currently have on my system. With:

    sudo bash install-packages.sh

you can install everything in `package_list.txt`. With a little bit of modification you can also install everything in `package_all.txt`.


<a id="org427ff16"></a>

# Emacs

I've been using EMACS for a while now (5-6 months). Before my config was just a random snippets of code that I've found online. Now, it's beautifully sorted random snippets of code that I've found online, all put together nicely on a formated `.org` file. The `.emacs` file is there just to load `./emacs.d/myinit.org`. There, in litareate programming style, is my actual *init* file. There are even some explanations around some of the the snippets and everything is categorized. If you use EMACS you can open the file and experience it in all it's beuty. For setting up the emacs config just use:

    . setup-emacs.sh

It's as bash script file that will just copy the `.emacs` file and some little things of the `.emacs.d` directory in the appropriate places.


<a id="orga023c70"></a>

# Package sources

For my Debian system I use diffetent sources for the apt-packages from those with which the system ships. My `sources.list` files are in the *package-sources* directory of the repository. With

    sudo bash setup-package-sources.sh

you can set those up on your system.(With that you can also install Spotify on your system ;) )


<a id="org13100e0"></a>

# Wallpapers

Because no system is complete without some pimp-ass wallpapers. My choices - yes, those are kinda old classics which inherantly makes them 'boring' but hey&#x2026;.the are still nice.


<a id="org4183b14"></a>

# References

For my dotfiles I've extensively taken inspiration from:

-   [Mathias Bynens](https://mathiasbynens.be/) and his [dotfile](https://github.com/mathiasbynens/dotfiles)
-   [This](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789) very good post on starting up with dotfiles
