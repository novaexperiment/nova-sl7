eval $(ssh-agent)
ssh-add ~/.ssh/novakey

source /cvmfs/nova.opensciencegrid.org/novasoft/slf6/novasoft/setup/setup_nova.sh -b maxopt
newrel -t development nova
cd nova
srt_setup -a
git checkout feature/tthakore_Nus_FC2022

addpkg_git -h CAFAna
addpkg_git -h NuXAna
addpkg_git -h FeldmanCousins

make -j16 CAFAna.all
make -j16 NuXAna.all
make -j16 FeldmanCousins.all

