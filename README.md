Have a look at <https://konfekt.github.io/blog/2018/11/10/simple-dotfiles-setup> to know how dotfiles are most easily put under (`git`) version control.

# About

This is a (`POSIX` compliant) shell script for `UNIX` based operating systems, such as `Linux`, `Free BSD` and `MacOS`, that creates

- for each dotfile (= file whose filename starts with a `.`) `.filename`  inside the dotfiles directory `$XDG_CONFIG_HOME` (= usually `~/.config`)
- a symbolic link `~/.filename` in the home folder `~/` that points to `~/.config/.filename`.

For example, `filename` = `bashrc`.

Then to put your dotfiles in `~/` under version control:

1. Move your dotfiles in `~/` into `$XDG_CONFIG_HOME`, and
2. execute `symlink-dotfiles.sh`.

# Installation

1. Clone this repository, for example into `~/Downloads`
    ```sh
    cd ~/Downloads/
    git clone https://github.com/konfekt/symlink-dotfiles.sh
    ````
0. Copy `symlink-dotfiles.sh` into a convenient folder, for example, `~/bin`
    ```sh
    cp ~/Downloads/symlink-dotfiles.sh/symlink-dotfiles.sh ~/bin/
    ```
0. Run `~/bin/symlink-dotfiles.sh`.

