This is a (`POSIX` compliant) shell script for `UNIX` based operating systems, such as `Linux`, `MacOS` and `FreeBSD`, that creates

- for each dotfile `.filename` (that is, a file whose name starts with a `.`, such as `~/.bashrc`) inside the dotfiles directory `$XDG_CONFIG_HOME` (usually `~/.config`)
- a symbolic link `~/.filename` in the home folder `~/` that points to `$XDG_CONFIG_HOME/.filename`.

to put your dotfiles in `~/` [most easily](https://konfekt.github.io/blog/2018/11/10/simple-dotfiles-setup) under (`git`) version control, as follows:

1. Move your dotfiles in `~/` into `$XDG_CONFIG_HOME`, and
1. Copy `symlink-dotfiles.sh` into a convenient folder, for example, `~/bin`

    ```sh
    mkdir -p ~/bin && cd ~/bin
    curl -fsSLO https://raw.githubusercontent.com/Konfekt/symlink-dotfiles.sh/master/symlink-dotfiles.sh &&
        chmod a+x ./symlink-dotfiles.sh
    ````

1. Run `symlink-dotfiles.sh`.

