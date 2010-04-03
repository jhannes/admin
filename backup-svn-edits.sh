#!/bin/bash

workspace=/c/work/svn.brodwall.com
repos="demo presentations training websites"
backup=/c/Documents\ and\ Settings/johannes/My\ Documents/backup/patches
failed=0


function backup {
    local workspace=$1
		local repo=$2
		local filename=${3:-${repo}}

    echo backing up $repo to ${backup}/${filename}.patch
    cd $workspace
    svn diff $repo > "${backup}/${filename}.patch"
    if [ $? -ne 0 ]
    then
				echo backup of $repo failed!
        failed=1
    fi
	
}


mkdir -p "$backup"

for repo in $repos;
do
    backup $workspace $repo
done

backup /c/work/zchat.no trunk zchat.no


if [ $failed -eq 0 ]
then
   echo "Backup successful"
else
   echo
   echo "ONE OR MORE OPERATIONS FAILED! PLEASE DON'T REINSTALL"
   echo
fi


# e.g.
# (cd /c/work/svn.brodwall.com; svn diff demo > /c/temp/backup/demo.patch)