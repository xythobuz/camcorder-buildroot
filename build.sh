#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPTDIR=$(dirname $SCRIPT)

make O=$SCRIPTDIR/output BR2_EXTERNAL=$SCRIPTDIR -C $SCRIPTDIR/buildroot $*

