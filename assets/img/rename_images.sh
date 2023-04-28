#!/bin/bash

for i in `ls ./posts/*`
do 
	mv $i ./posts/$(md5sum $i | awk '{print $1}').${i##*.}
done
