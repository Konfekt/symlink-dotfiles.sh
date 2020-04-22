#!/bin/bash

# From https://github.com/nhanb/dotfiles/blob/c4e70da2c728ee5495052c7bb04cb2b1b3c363e6/bootstrap/install.sh

dotdir=${XDG_CONFIG_HOME:-${HOME}/.config}
# Create backup folder named different from any existing one:
# If the directory already exists, then append '.old'.
make_backup_dir() {
    if [ -d "$1" ]; then
        make_backup_dir "$1.old"
    else
        mkdir --parents --verbose "$1"
    fi
}
backupdir=$(make_backup_dir "${dotdir}")
dotdir=$(realpath --relative-to="${HOME}" "${dotdir}")
backupdir=$(realpath --relative-to="${HOME}" "${backupdir}")

# Ignore certain git files and folders
ignores=(
        .git
        .gitignore
        .gitmodules
)
is_ignore() {
  for ignore in ${ignores[*]}; do
    if [ "$ignore" = "$1" ]; then
      echo "Ignored $name."
      return 1
    fi
  done
  return 0
}

(
cd "$HOME" || exit 1
for file in "${dotdir}"/.[a-zA-Z0-9]*; do
    echo "Found $file ..."

    # keep file name only
    name=$(basename "${file}")

    # Skip file if in ignore list
    [ $(is_ignore "$name") = 1 ] && continue

    # If dot file already exists in "$HOME", then move it to backup folder.
    if [ -e "${HOME}/${name}" ]; then
        mv --verbose "$HOME"/"${name}" "${backupdir}/$name"
        echo "Backed up $HOME/$name to ${backupdir}/$name."

        # TODO: sometimes the existing dot file is actually a symlink that
        # points to another dot file. This script may have broken such
        # symlinks by moving the target dot file. If that's the case then
        # this IF will return false, and you'll have to manually
        # create your symlink again when you want to restore your settings.
    fi

    # create symlink
    ln --verbose --symbolic --relative "$file" "$HOME/$name"
    echo "Created symlink: $HOME/$name -> $file." 
done

# Remove backup dir if unused.
rmdir --ignore-fail-on-non-empty "${backupdir}"
)

# Set safe permissions on sensible configuration files.
chmod-safe() {
  find "$@" -type d -print0 | xargs -0 chmod --silent 700
  find "$@" -type f -print0 | xargs -0 chmod --silent "${1:=600}"
}

(
cd "$HOME/$dotdir" &&
exec chmod-safe \
  ./.gnupg \
  ./.ssh \
  ./.ssl \
  ./.password-store \
)

