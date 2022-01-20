# WP-Baker

Script 'WP-Baker' helps to reduce amount of manual work needed to prepare WordPress for installation.



## Features

- Downloads the latest version of WordPress.
- Places WordPress into subfolder *'cms'* to keep site root cleaner.
- Creates index.php file on site root.
- Makes some otherwise missing folders (uploads, mu-plugins).
- Does some cleanups, by removing redundant themes and plugins.



## Usage

Script is meant to use on terminal. 

- Navigate for first into directory of new site root where to you want install WordPress.
- Download script into site root
- Run the script
- Follow on-screen instructions



```shell
curl https://raw.githubusercontent.com/Backpackstudio/wp-baker/master/wpbaker.sh -o wpbaker.sh
sh wpbaker.sh
```

