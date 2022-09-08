source /scratch/scripts/install-release.sh
mkdir /shrinkwrap
cd /shrinkwrap
$SRT_PRIVATE_CONTEXT/FeldmanCousins/docker2022/prepare.sh \
  -b maxopt -r development -t $SRT_PRIVATE_CONTEXT \
  -e $SRT_PRIVATE_CONTEXT/bin/Linux3.1-GCC-maxopt/fc2022-nus

