#!/bin/bash
# Test6: Yang specifics: rpc and state info

# include err() and new() functions
. ./lib.sh

# For memcheck
# clixon_netconf="valgrind --leak-check=full --show-leak-kinds=all clixon_netconf"
clixon_netconf=clixon_netconf
clixon_cli=clixon_cli

# kill old backend (if any)
new "kill old backend"
sudo clixon_backend -zf $clixon_cf
if [ $? -ne 0 ]; then
    err
fi

new "start backend"
# start new backend
sudo clixon_backend -If $clixon_cf
if [ $? -ne 0 ]; then
    err
fi
new "netconf rpc"
expecteof "$clixon_netconf -qf $clixon_cf" "<rpc><fib-route><routing-instance-name>ipv4</routing-instance-name></fib-route></rpc>]]>]]>" "^<rpc-reply><ok/></rpc-reply>]]>]]>$"

new "Kill backend"
# Check if still alive
pid=`pgrep clixon_backend`
if [ -z "$pid" ]; then
    err "backend already dead"
fi
# kill backend
sudo clixon_backend -zf $clixon_cf
if [ $? -ne 0 ]; then
    err "kill backend"
fi