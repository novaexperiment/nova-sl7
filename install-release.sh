# add ssh key
eval $(ssh-agent)
ssh-add ~/.ssh/novakey

# set up test release
source /cvmfs/nova.opensciencegrid.org/novasoft/slf6/novasoft/setup/setup_nova.sh -b maxopt
newrel -t development nova
cd nova
srt_setup -a
git checkout feature/vhewes_nus22fc

# clone packages
addpkg_git -h G4Rwgt
addpkg_git -h CAFAna
addpkg_git -h NuXAna
addpkg_git -h FeldmanCousins

# build packages
make -j16 G4Rwgt.all
make -j16 CAFAna.all
make -j16 NuXAna.all
make -j16 FeldmanCousins.all

