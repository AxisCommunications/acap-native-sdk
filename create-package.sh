#!/bin/bash -e
##############################################################################
#
# FILE NAME  : create-package.sh
#
# DESCRIPTION: Application package creation script
#
# ----------------------------------------------------------------------------
# Copyright (C) 2014, Axis Communications AB, LUND, SWEDEN
##############################################################################

#
# Note here are all internal functions
#
whine() {
	\printf "\n%s" "$*" >&2
}

help() {
	local me
	me=${0##*/}
	whine "Use $me to create an Embedded Axis Package"
	whine "Usage:   $me"
	whine ""
}

#
################################################################################
# End of all functions, here starts our business
################################################################################
MANIFEST_FILE_OPT=
VALIDATE_PACKAGE_CONF_OPT=
RUN_MAKE=true
RUN_MESON=false
ARCH=

while :; do
    case $1 in
        -h)
            help
            exit 0
            ;;
        -m)
            MANIFEST_FILE_OPT="-m $2"
            shift
            ;;
        --no-validate)
            VALIDATE_PACKAGE_CONF_OPT=--no-validate
            ;;
        --no-make)
            RUN_MAKE=false
            ;;
        --meson)
            ARCH=$2
            RUN_MAKE=flase
            RUN_MESON=true
            shift
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac
    shift
done

if [ "$RUN_MAKE" = true ]; then
    \printf "make\n"
    \make || {
        whine "make failed. Please fix above errors, before you can create a package"
        exit 1
    }
fi

if [ "$RUN_MESON" = true ]; then
    \printf "Meson\n"
    \meson setup --cross-file /opt/axis/acapsdk/sysroots/profiles/meson-cross-file-${ARCH}.ini builddir || {
        whine "Meson - Failed to setup build environment"
        exit 1
    }
    \meson compile -C builddir || {
        whine "Meson - Build failed. Please fix above errors, before you can create a package"
        exit 1
    }
    \grep "executable('[^']*'" meson.build | sed "s/executable('\([^']*\)'.*/\1/" |  xargs -I{} cp ./builddir/{} . || {
        whine "Executable missing"
        exit 1
    }  
fi


\printf "\neap-create.sh"
\eap-create.sh $MANIFEST_FILE_OPT $VALIDATE_PACKAGE_CONF_OPT || {
    whine "eap-create.sh failed. Please fix above errors, before you can create a package"
    exit 1
}

if [ ! -e manifest.json ]; then
	echo "******************WARNING******************"
	echo "package.conf based ACAPs will be deprecated in future versions. Please use"
	echo "manifest based ACAPs instead."
	echo "*******************************************"
fi

exit 0
