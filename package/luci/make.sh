#/bin/sh

CURR_DIR=$(cd $(dirname $0);pwd)

VER="`date +"1.%Y.%m.%d-%H%M"`"
SMARTDNS_DIR=$CURR_DIR/../../

showhelp()
{
	echo "Usage: make [OPTION]"
	echo "Options:"
	echo " -o               output directory."
	echo " --arch           archtecture."
    echo " --ver            version."
	echo " -h               show this message."
}

build()
{
    ROOT=/tmp/luci-app-smartdns
    rm -fr $ROOT

    mkdir -p $ROOT
    cp $CURR_DIR/* $ROOT/ -af
    cd $ROOT/
    mkdir $ROOT/root/usr/lib/lua/ -p
    cp $ROOT/files/luci $ROOT/root/usr/lib/lua/ -af
    cp $ROOT/files/etc $ROOT/root/ -af
    
    sed -i "s/^Architecture.*/Architecture: $ARCH/g" $ROOT/control/control
    sed -i "s/Version:.*/Version: $VER/" $ROOT/control/control

    cd $ROOT/control
    chmod +x *
    tar zcf ../control.tar.gz ./
    cd $ROOT

    tar zcf $ROOT/data.tar.gz -C root .
    tar zcf $OUTPUTDIR/luci-app-smartdns.$VER.$ARCH.ipk control.tar.gz data.tar.gz debian-binary
    rm -fr $ROOT/
}

main()
{
	OPTS=`getopt -o o:h --long arch:,ver: \
		-n  "" -- "$@"`

	if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

	# Note the quotes around `$TEMP': they are essential!
	eval set -- "$OPTS"

	while true; do
		case "$1" in
		--arch)
			ARCH="$2"
			shift 2;;
        --ver)
            VER="$2"
            shift 2;;
		-o )
			OUTPUTDIR="$2"
			shift 2;;
        -h | --help )
			showhelp
			return 0
			shift ;;
		-- ) shift; break ;;
		* ) break ;;
  		esac
	done

    if [ -z "$ARCH" ]; then
        echo "please input arch."
        return 1;
    fi

    if [ -z "$OUTPUTDIR" ]; then
        OUTPUTDIR=$CURR_DIR;
    fi

    build
}

main $@
exit $?

