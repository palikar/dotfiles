
# Table of Contents

1.  [Abstract](#org2699a84)
2.  [Emacs](#org2d300be)



<a id="org2699a84"></a>

# Abstract

Everyone loves setting up their system from scratch as easy as possible. org layerThat's why much smarter people than me has come up with the idea of *dotfiles*. A collection of scripts, configuration-files and system settings that can make your whole *system installation* as seamless as possible. My final goal with this 'project' of sorts is to be able to install fresh Debian, run one *master .sh file* and then just wait couple of hours unitl everything is getting ready by itself&#x2026;time in which I can, I don't know, drink tea and watch movies or something.


<a id="org2d300be"></a>

# Emacs

I've been using EMACS for a while now (5-6 months). Before my config was just a random snippets of code that I've found online. Now, it's beautifully sorted random snippets of code that I've found online, all put together nicely on a formated `.org` file. The `.emacs` file is there just to load `./emacs.d/myinit.org`. There, in litareate programming style, is my actual *init* file. There are even some explanations around some of the the snippets and everything is categorized. If you use EMACS you can open the file and experience it in all it's beuty.
  
For setting up the emacs config just use:

    . setup-emacs.sh

It's as bash script file that will just copy the `.emacs` file and some little things of the `.emacs.d` directory in the appropriate places.

