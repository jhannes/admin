#!/bin/bash


ssh=plink
login=jhannes@brodwall.com
backup="/c/work/backup/repos"

failed=0


# Prepare
mkdir -p "$backup"

function latest-revision {
    local repo=`basename $1`
    local repo_path="svn/$repo"
    result=`$ssh $login svnlook youngest $repo_path`
    
    echo $result
}

function backup-svn-repo {
    local repo=`basename $1`
    local lower=${2}
    local upper=${3}
    local login=${4:-jhannes@brodwall.com}
    local repo_dir=${5:-svn}


    if [ $lower ]
    then
      echo "Using given lower revision $lower"
    else
      echo "Finding file for $repo"
      if ls ${backup}/${repo}.*.gz > /dev/null;
			then
			   lower=`ls ${backup}/${repo}.*.gz | sed -e "s/^.*-\([0-9]*\)\.gz$/\1/" | head -1`
				 echo "Found lower $lower"
			else
			   lower=0
			   echo "Using default lower $lower"
			fi
    fi

    if [ $upper ]
    then
      echo "Using given upper revision $upper"
    else
      upper=`latest-revision $repo`
      echo "Using discovered upper revision $upper"
    fi

    local repo_path="$repo_dir/$repo"
    local backup_file="${backup}/${repo}.${lower}-${upper}.gz"

    echo "backing up $login:svn to ${backup_file}"
    echo -e "    repository $repo\n    from $lower\n    to $upper"
    echo "$ssh $login svnadmin dump --incremental -r ${lower}:${upper} $repo_path | gzip  > ${backup_file}"
    # $ssh $login svnadmin dump -q --incremental -r ${lower}:${upper} $repo_path | gzip  > ${backup_file}


    if [ $? -ne 0 ]
    then
        echo backup of $repo failed!
        failed=1
    fi
}


#		repository		from-rev	to-rev
#backup-svn-repo johannes@brodwall.com svn "mindlikewater" 0
#backup.svn-repo zchat@zchat.no /var/www/svn zchat 0
backup-svn-repo "mindlikewater" 0
backup-svn-repo "demo" 0
backup-svn-repo "workspace" 0
backup-svn-repo "presentations" 0
backup-svn-repo "training" 0
backup-svn-repo "websites" 0

