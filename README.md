resemblance
===========

### Motivation
Resemblance is personal project I've created in order to help me mantain my Ubuntu's configurations/customizations versioned. It was brought into existence so that I could keep multiple machines (with the same distro) in partial sync, and so that I could also easily reinstall my OS up from scratch.

### Be aware
I also did this for fun: Be aware that - although there is plenty of room for improvements - for now on the project will not be very active, as it already satisfies my personal needs and goals. Nonetheless, if someone else comes to show some interest, I may put more time on it. Also, if you want to get involved, just contact me.

### How it works
#### setup.sh
The setup script makes sure everything is in order. In its first use, it opens vi (or the editor specifyed by EDITOR environment variable) with a configuration file you can use to customize directories and some other preferences. After the editor is closed, it clones the resemblance repository, creates the necessary directory structure and calls the update script.
#### update.sh
The update script basically assures there are symbolic links for each of the files contained under your profile in your target directory (your home is the default set in the configuration file).

### Installing
You should clone this repo, exclude it's *git* related files (.gitignore, .gitmodules, ... and .get itself), run the setup script and put the *profiles* directory under a private repository.
>    git clone git://github.com/rhlobo/resemblance.git && cd resemblance && rm -R .git*

Alternativelly, you could use the instruction bellow instead of clonning this repository:
>    wget --no-check-certificate https://github.com/rhlobo/resemblance/raw/master/scripts/setup.sh -O - | sh
