# Script to update file permissions

This is useful in situations where the id of one or more user or group is changed. Classic example is, deleting local user and creating the same through AD.

Note : user, group, uid, gid files here are for reference. Truncate these files and update its values as described below.
Do the following steps in all nodes.

### __Before /etc/passwd and /etc/group are updated__ -
## Safety measures

- Create a working directory
`mkdir /root/perm_change/`
- Take full filesystem permissions backup
`ls -Rl / |gzip > /root/perm_change/backup/all_file_perm.gz`
- Take /etc/passwd and /etc/group backup
`cp /etc/passwd /etc/group /root/perm_change/backup/`

## Prepare files

- Create a file "user" with the usernames of all the affected users line by line (Refer user file included). Then extract the username and its id from passwd file and create another file "uid" with the results.

``for i in `cat /root/perm_change/user`; do cat /etc/passwd | grep "$i:" | cut -d : -f 1,3;done > /root/perm_change/uid``

- Create a file "group" with the group names of all the affected groups line by line (Refer group file included). Then extract the group name and its id from passwd file and create another file "gid" with the results.

``for i in `cat /root/perm_change/group`; do cat /etc/group | grep "$i:" | cut -d : -f 1,3;done > /root/perm_change/gid``

- Find the parent directories on which you need to update the permissions and update swap_user.sh and swap_group.sh scripts.


### __After /etc/passwd and /etc/group are updated__ -
## Run the scripts

Run the script `/bin/sh swap_user.sh` to update user permisions.
Run the script `/bin/sh swap_group.sh` to update user permisions.
