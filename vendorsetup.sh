function aospremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm aosp 2> /dev/null
    local PROJECT=$(pwd -P | sed -e "s#$ANDROID_BUILD_TOP\/##; s#-caf.*##; s#\/default##")
    # Google moved the repo location in Oreo
    if [ $PROJECT = "build/make" ]
    then
        PROJECT="build"
    fi
    if (echo $PROJECT | grep -qv "^device")
    then
        local PFX="platform/"
    fi
    git remote add aosp https://android.googlesource.com/$PFX$PROJECT
    echo "Remote 'aosp' created"
}

function leaf_lunch()
{
    lunch "$@"
    export LEAF_BUILD=$(get_build_var TARGET_DEVICE)
    export LINEAGE_BUILD=$LEAF_BUILD
}
alias lunch=leaf_lunch

function fetch_device()
{
    if [ -z "$1" ]; then
        echo "Usage: fetch_device <codename>"
        return 1
    fi

    if [ ! -f "$(gettop)/leaf/devices/${1}.xml" ]; then
        echo "Device $1 not found!"
        return 1
    fi

    mkdir -p "$(gettop)/.repo/local_manifests"
    cp "$(gettop)/leaf/devices/${1}.xml" "$(gettop)/.repo/local_manifests"

    echo "Syncing device repos..."
    for REPO in $(cat "$(gettop)/leaf/devices/${1}.xml" | grep '<project path=' | cut -f2 -d '"'); do
        repo sync $REPO
    done
}
