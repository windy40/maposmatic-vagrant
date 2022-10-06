# simply generate all available locales

echo "generating all locales ... this may take a while"

cp /usr/share/i18n/SUPPORTED /etc/locale.gen 
locale-gen >/dev/null
