#!/usr/bin/env bash
ELECTRON_REPO=https://github.com/electron/electron

# cd the root path
realpath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"; }
ROOT=$(dirname "$(realpath "$0")")
cd ${ROOT}

# clone the depot_tools repository
rm -rf ${ROOT}/depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# add depot_tools to the end of your PATH
export PATH=${PATH}:${ROOT}/depot_tools
export GIT_CACHE_PATH="${ROOT}/.git_cache"
mkdir -p "${GIT_CACHE_PATH}"

# sccache
export SCCACHE_BUCKET="electronjs-sccache"
export SCCACHE_TWO_TIER=true

mkdir electron-gn && cd electron-gn
gclient config --name "src/electron" --unmanaged ${ELECTRON_REPO}
gclient sync --with_branch_heads --with_tags

#cd src/electron
#git remote remove origin
#git remote add origin ${ELECTRON_REPO}
#git branch --set-upstream-to=origin/master
#
## configuare
#cd ${ROOT}/electron-gn/src
#PWD=`pwd`
#export CHROMIUM_BUILDTOOLS_PATH=${PWD}/buildtools
#export GN_EXTRA_ARGS="${GN_EXTRA_ARGS} cc_wrapper=\"${PWD}/electron/external_binaries/sccache\""
#gn gen out/Debug --args="import(\"//electron/build/args/debug.gn\") $GN_EXTRA_ARGS"
#
## build
#ninja -C out/Debug electron
