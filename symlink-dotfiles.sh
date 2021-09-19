#!/bin/bash

# From https://github.com/nhanb/dotfiles/blob/c4e70da2c728ee5495052c7bb04cb2b1b3c363e6/bootstrap/install.sh

dotdir=${XDG_CONFIG_HOME:-${HOME}/.config}
# Create backup folder named different from any existing one:
# If the directory already exists, then append '.old'.
make_backup_dir() {
  if [ -d "$1" ]; then
    make_backup_dir "$1.old"
  else
    mkdir --parents "$1" &&
      echo "$1"
  fi
}
backupdir=$(make_backup_dir "${dotdir}")

dotdir=$(realpath "${dotdir}")
backupdir=$(realpath "${backupdir}")

# Ignore certain git files and folders
ignores=(
        .git
        .gitignore
        .gitmodules
)
is_ignore() {
  for ignore in ${ignores[*]}; do
    if [ "$ignore" = "$1" ]; then
      echo 1
      return
    fi
  done
}

(
cd "$dotdir" || exit 1
for file in .[!.]*; do
    echo "Found $file ..."

    file=$(realpath "${file}")
    name=$(basename "${file}")

    # Skip file if in ignore list
    if [ "$(is_ignore "$name")" = "1" ]; then
      echo "Ignored $name."
      continue
    fi

    # If dot file already exists in "$HOME", then move it to backup folder.
    if [ -e "${HOME}/${name}" ]; then
        mv --verbose "$HOME"/"${name}" "${backupdir}/$name"
        echo "Backed up $HOME/$name to ${backupdir}/$name."
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
  find "$@" -type f -print0 | xargs -0 chmod --silent 600
}

(
cd "$dotdir" &&
chmod-safe \
  ./.gnupg \
  ./.ssh \
  ./.ssl \
  ./.password-store \
)

