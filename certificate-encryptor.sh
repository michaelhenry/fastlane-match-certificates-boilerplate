#!/bin/bash
# Author: Michael Henry Pantaleon
cat << EOF


#############################################
#                                           #
#   Certificate 's encryptor                #
#                                           #
#   This bash file should be store          #
#   in the root directory of the            #
#   repository."                            #
#                                           #
#                                           #
#############################################


EOF

read -p "Enter the name of the .p12 file: " cert_p12_file
read -p "Enter the name of the .cer file: " cert_cer_file
read -p "Enter your team id: " team_id
read -p "Enter your desired passkey: " passkey
read -p "Enter the type of the certificate (development/distribution) : " certificate_type

if [ "$certificate_type" == "development" ] || [ "$certificate_type" == "distribution" ]; then
    
    cert_folder=certs/$certificate_type
    mkdir -p $cert_folder
    output_p12=$cert_folder/$team_id-$cert_p12_file.p12
    output_cer=$cert_folder/$team_id-$cert_cer_file.cer
   
    {
        key_pem_file=$(uuidgen).pem
        openssl pkcs12 -nocerts -nodes -out $key_pem_file -in $cert_p12_file
        openssl aes-256-cbc -k $passkey -in $key_pem_file -out $output_p12 -a
        openssl aes-256-cbc -k $passkey -in $cert_cer_file -out $output_cer  -a

        rm $key_pem_file
    } || {
        echo "An error occured. Please try again."
        exit 1
    }
   
    echo "Certificate encrypted successful."
    read -p "Do you want to delete the source files? (y/n): " delete_source_file

    case "$delete_source_file" in
    "y")
        rm $cert_p12_file $cert_cer_file
        echo "$cert_p12_file $cert_cer_file were deleted."
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
else
    echo "Invalid selection. Please choose (development/distribution)."
    exit 1
fi

echo "\n\nGenerated files:"
echo " - $output_p12"
echo " - $output_cer"

