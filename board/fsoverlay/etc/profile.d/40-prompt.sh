#More info contained
#Usually [root@REGLINUX /current/dir]#
if test -n $PS1; then
    PS1='[\u@\h $PWD]\$ '
fi
