github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)

if [ "$github_version" != "$ftp_version" ]
then
    $version=$github_version
    cd /home/travis
    mkdir  minio-mc
    cd minio-mc
    wget https://github.com/minio/mc/archive/RELEASE.$github_version.zip
    unzip RELEASE.$github_version.zip
    mv mc-RELEASE.$github_version mc
    cd mc
    #sudo sh -c 'echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6'
    make
    mv mc mc-$github_version
    
    if [[ $github_version != $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/minio-mc/latest mc-$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/minio-mc/latest/mc-$ftp_version" 
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/minio-mc mc-$github_version"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/minio-mc/mc-$del_version" 
fi
