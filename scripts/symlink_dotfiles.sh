#!/bin/bash

# In the format of "DESTINATION_FILEPATH:SOURCE_FILEPATH"
FILEPATHS=( "$HOME/.gitconfig:../.gitconfig" "$HOME/.bashrc:../.bashrc" "$HOME/.config/nvim:../.config/nvim" )

for filepath in "${FILEPATHS[@]}"
do
    source_filepath=$(echo "$filepath" | cut -d':' -f2)
    source_filepath=$(realpath "$source_filepath")

    destination_filepath=$(echo "$filepath" | cut -d':' -f1)

    read -p "Replace \"$destination_filepath\" with a symlink pointing to \"$source_filepath\"? [y/n]: " REPLY
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -rf "${destination_filepath}" && ln -s "${source_filepath}" "${destination_filepath}"
        echo "Done!"
    else
        echo "Skipping..."
    fi
done
