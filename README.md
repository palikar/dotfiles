- [Abstract](#org7603755)
  - [Warning](#orge8ebfc4)
- [Installation](#org1b6653d)
- [Emacs](#org29b37cc)
- [Vim](#orge9c2c7e)
- [Bash Configuration](#org28fbbd6)
- [Package sources](#orgc6a4eb0)
- [Wallpapers](#org05f163d)
- [References](#orgf254eae)



<a id="org7603755"></a>

# Abstract

Everyone loves setting up their system from scratch as easy as possible. org layerThat&rsquo;s why much smarter people than me has come up with the idea of *dotfiles*. A collection of scripts, configuration-files and system settings that can make your whole *system installation* as seamless as possible. My final goal with this &rsquo;project&rsquo; of sorts is to be able to install fresh Debian, run one *master .sh file* and then just wait couple of hours unitl everything is getting ready by itself&#x2026;time in which I can, I don&rsquo;t know, drink tea and watch movies or something.


<a id="orge8ebfc4"></a>

## Warning

**Please!** Do not run any of my scripts without understanding what they do. Look at the config files and choose the settings that you like and discard those you don&rsquo;t. Creating your dotfiles is pretty much an art.


<a id="org1b6653d"></a>

# Installation

Clone as normal and just execute the scripts for the diffetent things. The `.sh` files are located at the root of the repository and their names are self-explenatory.

    git clone https://github.com/palikar/dotfiles
    cd dotfiles
    sudo bash setup_all.sh

*Note:* In my system I keep all of my development files(including my dotfiles) in folder called `code` and located at my home directory. Some of my setup sctipts asume that this is infact the case so if you are going to use the, please make the neccessery changes. // For not I&rsquo;ve setup things for:

-   `.emacs` - [Emacs](https://www.gnu.org/software/emacs/) is my editor of choice and this is the file that gets evaluated on each launch of it
-   `.vimrc` - [Vim](https://www.vim.org/) is my other editor of choice&#x2026;
-   `.bash_aliases` - some useful abbriviations for certain commands in the terminal
-   `.bash_prompt`
-   `.bashr` - this file will beevaluated every time you lauch your *bash* terminal
-   `.env` - setting up some basic environment variables
-   `.inputrc` - some minor fixes for better typing in the terminal
-   `.gitconfig` - making `git` more pleasent to work with. Mainly diffetent abbriviations for git-commands

// `package_list.txt` is a file the countains all `apt` packages that I can imagine myself using. `package_all.txt` containts list of all packages that I currently have on my system. With:

    sudo bash install_packages.sh

you can install everything in `package_list.txt`. With a little bit of modification you can also install everything in `package_all.txt`.


<a id="org29b37cc"></a>

# Emacs

I&rsquo;ve been using EMACS for a while now (5-6 months). Before my config was just a random snippets of code that I&rsquo;ve found online. Now, it&rsquo;s beautifully sorted random snippets of code that I&rsquo;ve found online, all put together nicely on a formated `.org` file. The `.emacs` file is there just to load `./emacs.d/myinit.org`. There, in litareate programming style, is my actual *init* file. There are even some explanations around some of the the snippets and everything is categorized. If you use EMACS you can open the file and experience it in all it&rsquo;s beuty. For setting up the emacs config just use:

    . setup_-_emacs.sh

It&rsquo;s as bash script file that will just copy the `.emacs` file and some little things of the `.emacs.d` directory in the appropriate places&#x2026;.kinda, it actually creates soft links to the relevent configs but some things are still getting copied.


<a id="orge9c2c7e"></a>

# Vim

The setup is pretty analogous to the emacs-one. Just run the script like:

    . ./setup_vim.sh

It will create the soft link to ./vimrc/ in your home directory. To note is that will delete the current *.vim* directory in your home (*~*). My vim config is quite vanialla and all I got in my *.vim* is a single theme. For that it makes sense to do the whole deleting thing.


<a id="org28fbbd6"></a>

# Bash Configuration

All the &rsquo;system&rsquo; dotfiles are in `./system-config`. Those must be placed in the home directory. <span class="underline">Be careful while running:</span>

    . ./setup_system.sh

This will first **delete** all file with the same names in the home directory. This means that your original *.bashrc* will be gone so **archive** it first. After the deletion the script will create the necessary soft links.


<a id="orgc6a4eb0"></a>

# Package sources

For my Debian system I use diffetent sources for the apt-packages from those with which the system ships. My `sources.list` files are in the *package-sources* directory of the repository. With

    sudo bash setup_package_sources.sh

you can set those up on your system.(With that you can also install Spotify on your system ;) )


<a id="org05f163d"></a>

# Wallpapers

Because no system is complete without some pimp-ass wallpapers. My choices - yes, those are kinda old classics which inherantly makes them &rsquo;boring&rsquo; but hey&#x2026;.the are still nice.


<a id="orgf254eae"></a>

# References

For my dotfiles I&rsquo;ve extensively taken inspiration from:

-   [Mathias Bynens](https://mathiasbynens.be/) and his [dotfile](https://github.com/mathiasbynens/dotfiles)
-   [This](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789) very good post on starting up with dotfiles
-   Recently I&rsquo;ve changed my Bash Prompt and made it pretty much like this [guy&rsquo;s(KeizerDev)](https://github.com/KeizerDev/.bashrc) one.
