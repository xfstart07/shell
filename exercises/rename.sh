#########################################################################
# Author: xufei
# Mail: xfstart07@gmail.com
# Date: 2020-08-13
#########################################################################

#!/usr/bin/env bash
set -ue

idx=1

for i in *.sh; do 
    if [ "$i" = "rename.sh" ]; then 
        continue
    fi
    
    newname=`echo ${idx}|awk '{printf("%02d.sh",$0)}'`
    echo "$newname"
    mv "$i" "$newname"

    idx=$[ $idx + 1 ]
done