#!/bin/bash
# Author: Michael Henry Pantaleon
cat << EOF


#############################################
#                                           #
#   Profile 's encryptor                    #
#                                           #
#   This bash file should be store          #
#   in the root directory of the            #
#   repository."                            #
#                                           #
#                                           #
#############################################


EOF

read -p "Enter the app identifier: " app_identifier
read -p "Enter the name of the .mobileprovision file: (Eg. Name_of_the_file.mobileprovision)" inputed_mobileprovision
read -p "Enter your desired passkey: " passkey
read -p "Enter the profile type (development/adhoc/appstore) : " profile_type

profile_prefix=""

case "$profile_type" in

    "development")
        profile_prefix="Development"
        ;;
    "adhoc")
        profile_prefix="Adhoc"
        ;;
    "appstore")
        profile_prefix="AppStore"
        ;;
    *)
        echo "Invalid selection. Choices are (development/adhoc/appstore)."
        exit 1
        ;;
esac

profile_folder=profiles/$profile_type
mkdir -p $profile_folder
output_mobileprovision=$profile_folder/${profile_prefix}_$app_identifier.mobileprovision

{
    openssl aes-256-cbc -k $passkey -in $inputed_mobileprovision -out $output_mobileprovision -a
} || {
    echo "An error occured. Please try again."
    exit 1
}

echo "Profile encrypted successful."
read -p "Do you want to delete the source files? (y/n): " delete_source_file

case "$delete_source_file" in
    "y")
        rm $inputed_mobileprovision
        echo "$inputed_mobileprovision was deleted."
        echo "Thank you!"
        ;;
    "n")
        echo "Thank you!"
        ;;
    *)
        echo "Invalid selection. Choices are (y/n)."
        exit 1
        ;;
    esac

echo "\n\nGenerated file:"
echo " - $output_mobileprovision"
