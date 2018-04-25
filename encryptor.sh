#!/bin/bash
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

read -p "Enter the name of the .p12 file: " cert_p12_name
read -p "Enter the name of the .cer file: " cert_cer_name
read -p "Enter the name of the .mobileprovision file: " mobileprovision_name
read -p "Enter the app identifier: " app_identifier
read -p "Enter your desired passkey: " passkey
read -p "Enter the type of the profile (development/adhoc/enterprise/appstore) : " profile_type

#############################################
# As per the function profile_type_name in https://github.com/fastlane/fastlane/blob/master/match/lib/match/generator.rb
# As per function cert_type_sym https://github.com/fastlane/fastlane/blob/master/match/lib/match/module.rb
#############################################


case "$profile_type" in
    "development")
        profile_prefix="Development"
        certificate_type="development"
        ;;
    "adhoc")
        profile_prefix="Adhoc"
        certificate_type="distribution"
        ;;
    "enterprise")
        profile_prefix="InHouse"
        certificate_type="enterprise"
        ;;
    "appstore")
        profile_prefix="AppStore"
        certificate_type="distribution"
        ;;
    *)
        echo "Invalid selection. Choices are (development/adhoc/enterprise/appstore)."
        exit 1
        ;;
esac

cert_folder=certs/$certificate_type
mkdir -p $cert_folder
cert_p12_file=$cert_p12_name.p12
cert_cer_file=$cert_cer_name.cer
output_p12=$cert_folder/$cert_p12_file
output_cer=$cert_folder/$cert_cer_file

profile_folder=profiles/$profile_type
mkdir -p $profile_folder
mobileprovision_file=$mobileprovision_name.mobileprovision
output_mobileprovision=$profile_folder/${profile_prefix}_$app_identifier.mobileprovision
    
{
    openssl aes-256-cbc -k $passkey -in $cert_p12_file -out $output_p12 -a
    openssl aes-256-cbc -k $passkey -in $cert_cer_file -out $output_cer -a
    openssl aes-256-cbc -k $passkey -in $mobileprovision_file -out $output_mobileprovision -a
} || {
    echo "An error occured. Please try again."
    exit 1
}
   
echo "Certificate and profile encrypted successful."
read -p "Do you want to delete the source files? (y/n): " delete_source_file

case "$delete_source_file" in
    "y")
        rm $cert_p12_file $cert_cer_file $mobileprovision_file
        echo "$cert_p12_file $cert_cer_file $mobileprovision_file were deleted."
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

echo "\n\nGenerated files:"
echo " - $output_p12"
echo " - $output_cer"
echo " - $output_mobileprovision"

