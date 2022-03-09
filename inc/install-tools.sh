#! /bin/bash

for tool in $FILEDIR/local-bin/*
do
	cp $tool /usr/local/bin/
	chmod a+x /usr/local/bin/$(basename $tool)
done
