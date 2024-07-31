#!/bin/bash

# Define ANSI escape sequences for color
e="\x1b["; c=$e"39;49;00m"; y=$e"93;01m"; r=$e"1;91m"; g=$e"92;01m"; cy1=$e"96;01m"; m1=$e"95;01m";

# Function to display the poster
poster() {
echo -e "
"=========================================================================================="
|                              SIMPLE XIAOMI FLASHER                                      |
|                                 by technoparrot01                                       |
"=========================================================================================="
";
}

# Function to select the flash option
flash_option() {
echo -e "
"=========================================================================================="
  1 - flash_all
  2 - flash_all_except_storage
  3 - flash_all_except_data_and_storage
"=========================================================================================="
";
printf %s "Enter your choice: ";
read flash_choice;
case $flash_choice in
 1) flash_command="flash_all.sh";;
 2) flash_command="flash_all_except_storage.sh";;
 3) flash_command="flash_all_except_data_and_storage.sh";;
 *) echo -e $r"Invalid choice, defaulting to flash_all"$c; flash_command="flash_all.sh";;
esac
}

# Function to perform the flashing
flash_firmware() {
local tgz_file=$1
local workdir=$(pwd)
local firmware_dir="$workdir/firmware_temp"

# Create a temporary directory for firmware extraction
mkdir -p $firmware_dir

# Extract the firmware with progress display
echo "Extracting firmware, please wait..."
echo -n "[="
while :; do echo -n =; sleep 1; done &
trap "kill $!" EXIT
tar xzpf $tgz_file -C $firmware_dir
kill $! && trap " " EXIT
echo "] 100% Extraction complete"
echo " "

# Display flash options
flash_option

# Change to the firmware directory and execute the selected flash command
cd $firmware_dir/*  # Assuming only one directory is created after extraction
chmod +x $flash_command

echo "Flashing firmware, please wait..."
./$flash_command

# Cleanup
cd $workdir
rm -rf $firmware_dir

echo -e $g"Flashing completed!"$c
}

# Main script execution
if [ $# -ne 1 ]; then
    echo -e $r"Usage: $0 rom.tgz"$c
    exit 1
fi

poster
flash_firmware $1
