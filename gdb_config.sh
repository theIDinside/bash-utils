#!/bin/bash

usage() {
	echo "Usage: cfggdb <type parameter>"
	echo "Type 			| <type parameter>"
	echo "Debug 			| Debug, D"
	echo "Release			| Release, R"
	echo "Release with debug info	| RelWithDebInfo, RD"
  echo "Configures a GDB build in CWD with python functionality"
	exit
}

if [ "$GDB_SRC" = "" ]; then
  echo "\$GDB_SRC not set! Point it to the binutils-gdb directory and export it on \$PATH or pass it as (2nd) parameter to this script."
fi

type="${1^}"
src_dir="$2"

case $src_dir in
	"")
	echo "Using env GDB_SRC: $GDB_SRC"
	;;
	*)
	GDB_SRC=$src_dir
esac

if [ "$src_dir" == "" && "$GDB_SRC" == "" ]; then
  echo "No GDB Source directory was found."
  usage
  exit
fi

case $type in
	"D" | "DEGUG")
	$GDB_SRC/configure --with-python=/usr/bin/python3 CXXFLAGS='-g3 -O0' CFLAGS='-g3 -O0'
	;;
	"O" | "OPTIMIZED")
	$GDB_SRC/configure --with-python=/usr/bin/python3 CXXFLAGS='-O2' CFLAGS='-O2'
	;;
	"R" | "RELEASE")
	$GDB_SRC/configure --with-python=/usr/bin/python3 CXXFLAGS='-O3' CFLAGS='-O3'
	;;
	"RD" | "RELWITHDEBINFO")
	$GDB_SRC/configure --with-python=/usr/bin/python3 CXXFLAGS='-O3 -g3' CFLAGS='-O3 -g3'
	;;
	*)
	usage
	;;
esac
