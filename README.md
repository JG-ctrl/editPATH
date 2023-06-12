# editPATH
A shell script function that allows you to edit the environment variable PATH (i.e. apprend, prepend, or delete pathnames in PATH)
Example calls:
$ . ./def-editpath.sh
$ PATH=/bin:/usr/bin:/usr/local/bin
$ editpath -a '/xxx   yyy' /opt/bin .
$ /usr/bin/printenv PATH
/bin:/usr/bin:/usr/local/bin:/xxx   yyy:/opt/bin:.
$ editpath -p 'Job$' '/M$Office' x
$ /usr/bin/printenv PATH
x:/M$Office:Job$:/bin:/usr/bin:/usr/local/bin:/xxx   yyy:/opt/bin:.
$ editpath -d . 'Job$' usr
$ /usr/bin/printenv PATH
x:/M$Office:/bin:/usr/bin:/usr/local/bin:/xxx   yyy:/opt/bin
