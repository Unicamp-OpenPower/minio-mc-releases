#!/usr/bin/env bash
github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
ROOTPATH="~/rpmbuild/RPMS/ppc64le"
LOCALPATH="/home/travis/minio-mc/mc"
REPO1="/repository/debian/ppc64el/minio-mc"
REPO2="/repository/rpm/ppc64le/minio-mc"

if [ "$github_version" != "$ftp_version" ]
  then
    git clone https://$USERNAME:$TOKEN@github.com/Unicamp-OpenPower/repository-scrips.git
    cd repository-scrips/
    chmod +x empacotar-deb.sh
    chmod +x empacotar-rpm.sh
    sudo mv empacotar-deb.sh $LOCALPATH
    sudo mv empacotar-rpm.sh $LOCALPATH
    cd $LOCALPATH
    sudo ./empacotar-deb.sh mc mc-$github_version $github_version " "
    $str_version=$github_version
    tr '-' '.' <<<"$str_verion"
    echo "$str_version"
    sudo ./empacotar-rpm.sh mc mc-$github_version $str_version " " "MinIO Client (mc) provides a modern alternative to UNIX commands like ls, cat, cp, mirror, diff, find etc. It supports filesystems and Amazon S3 compatible cloud storage service (AWS Signature v2 and v4)."
fi

if [[ $github_version != $ftp_version ]]
   then
        sudo lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O $REPO1 $LOCALPATH/mc-$github_version-ppc64le.deb"
        sudo lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O $REPO2 $ROOTPATH/mc-"$str_version"-1.ppc64le.rpm"
fi
