#!/bin/bash

set -ex

keyspace=${KEYSPACE:-'test_keyspace'}
shard=${SHARD:-'0'}
targettab=${TARGETTAB:-"${CELL}-0000000101"}
sleeptime=${SLEEPTIME:-'10'}

export PATH=/vt/bin:$PATH

VTCTLD_SERVER=${VTCTLD_SERVER:-'vtctld:15999'}

# To avoid the timing error like
# `remote error: rpc error: code = Unknown desc = node doesn't exist: vitess/global/keyspaces/test_keyspace/shards/-80/`
sleep $sleeptime

vtctlclient -server $VTCTLD_SERVER PlannedReparentShard --keyspace_shard="$keyspace/$shard" --new_primary=$targettab
