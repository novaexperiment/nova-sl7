# add ssh key
eval $(ssh-agent)
ssh-add ~/.ssh/novakey

# set up test release
source /cvmfs/nova.opensciencegrid.org/novasoft/slf6/novasoft/setup/setup_nova.sh -b maxopt
cd /
newrel -t development nova
cd nova
srt_setup -a
git checkout feature/tthakore_Nus_FC2022

# clone packages
addpkg_git -h CAFAna
addpkg_git -h NuXAna
addpkg_git -h FeldmanCousins

# build packages
make -j16 CAFAna.all
make -j16 NuXAna.all
make -j16 FeldmanCousins.all

# shrinkwrap everything
mkdir /shrinkwrap
cd /shrinkwrap
$SRT_PRIVATE_CONTEXT/FeldmanCousins/docker2022/prepare.sh -b maxopt -r development \
 -t $SRT_PRIVATE_CONTEXT -e $SRT_PRIVATE_CONTEXT/bin/Linux3.1-GCC-maxopt/fc2022-nus

