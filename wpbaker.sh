#!/bin/bash -e
wpBakerVersion='0.0.1'
wpBakerWDir=$(pwd -P)

echo ''
echo '╔════════════════════════════════════════════════════════════════'
echo "║    Wp-Baker   v$wpBakerVersion"
echo '╚════════════════════════════════════════════════════════════════'
echo ''

## Do not allow run this cript on user home directory.
if [[ "$wpBakerWDir" == "$HOME" ]]
then
	echo 'Currently select directory is home directory. Proccess aborted.'
	echo 'Please select another directory'
	exit
fi

## Confirm that user wants to run this script in current directory.
echo "Do you want download and bake WordPress into '$wpBakerWDir'? (y/n)";
read -e userResponse001
if [ "$userResponse001" == 'n' ] ; then
	echo 'Proccess aborted.'
	exit
fi

## Check that there is no subdirectory cms
if [[ -d cms ]]
then
	echo 'Current directory already contains subdirectory "cms".'
	echo 'To remove directory use command: rm -R cms'
	ls -l "$wpBakerWDir"
	exit
fi

## Check that there is no subdirectory wordpress
if [[ -d wordpress ]]
then
	echo 'Current directory contains already subdirectory "wordpress".'
	echo 'To remove it use command: rm -R wordpress'
	ls -l "$wpBakerWDir"
	exit
fi

## Check that there is no file index.html
if [[ -f index.htm ]]
then
	echo 'Current directory contains alreadyfile "index.htm".'
	echo 'To remove it use command: rm index.htm'
	ls -l "$wpBakerWDir"
	exit
fi

## Check that there is no file index.php
if [[ -f index.php ]]
then
	echo 'Current directory contains already file "index.php".'
	echo 'To remove it use command: rm index.php'
	ls -l "$wpBakerWDir"
	exit
fi

## Check that there is no file index.html
if [[ -f index.html ]]
then
	echo 'Current directory contains already file "index.html".'
	echo 'To remove it use command: rm index.html'
	ls -l "$wpBakerWDir"
	exit
fi

## Download WordPress
echo 'Downloading the latest version of WordPress...'
curl https://wordpress.org/latest.zip --output wp.zip
echo 'Extracting WordPress from zip file ...'
unzip -o wp.zip | awk 'BEGIN {ORS="·"} {if(NR%100==0)print "·"}'
echo ''
wpVersonLine=$(grep '$wp_version\s*=' "$wpBakerWDir/wordpress/wp-includes/version.php")
wpVersonNumber=$(echo "$wpVersonLine" | awk 'match($0,/[0-9.]+/) {print substr($0,RSTART,RLENGTH)}')
echo "WordPress version: $wpVersonNumber";
echo 'Renaming directory "wordpress" to "cms"'
mv wordpress cms
rm wp.zip

## Make index page
echo 'Creating index.php'
cp cms/index.php index.php
perl -i -pe's/wp-blog-header.php/cms\/wp-blog-header.php/g' index.php

## Disable unwanted access to WordPress configuration file
echo 'Creating .htaccess file'
echo 'Options -Indexes' >> cms/.htaccess
echo '<files wp-config.php>' >> cms/.htaccess
echo 'order allow,deny' >> cms/.htaccess
echo 'deny from all' >> cms/.htaccess
echo '</files>' >> cms/.htaccess

## Make directory for uploads
echo 'Creating uploads directory'
mkdir cms/wp-content/uploads
chmod 775 cms/wp-content/uploads
cp cms/wp-content/plugins/index.php cms/wp-content/uploads/index.php
echo 'Options -Indexes' >> cms/wp-content/uploads/.htaccess

## Make directory for uploads
echo 'Creating mu-plugins directory'
mkdir cms/wp-content/mu-plugins
chmod 775 cms/wp-content/mu-plugins
cp cms/wp-content/plugins/index.php cms/wp-content/mu-plugins/index.php
echo 'Options -Indexes' >> cms/wp-content/mu-plugins/.htaccess

## Lets do some cleanup
echo 'Cleaing WordPress:'
echo '	- Removing plugin Akismet'
rm -R cms/wp-content/plugins/akismet
echo '	- Removing plugin Hello Dolly'
rm cms/wp-content/plugins/hello.php
echo '	- Removing theme Twenty Nineteen'
rm -R cms/wp-content/themes/twentynineteen
echo '	- Removing theme Twenty Twenty'
rm -R cms/wp-content/themes/twentytwenty

## Lets complete the baking
cd "$wpBakerWDir"
echo "WordPress $wpVersonNumber is downloaded and prepared for installation."
echo "Location: $wpBakerWDir"

## Promt to remove Wp-Baker
echo 'Do you want to remove Wp-Baker scriprt? (y/n)'
read -e userResponse002
if [ "$userResponse002" == 'y' ] ; then
	rm "$0"
fi
