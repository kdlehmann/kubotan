#/bin/bash

TARBALL=kubotan-$(date +%s).tar.gz
TARGETHOST=46.38.249.61
TARGETUSER=sub11429_64

error_n_exit() {
    msg=$1
    rm -f id_rsa
    echo $msg
    exit 1
}

# decrypt ssh key
openssl aes-256-cbc -K $encrypted_671dc0cb2713_key -iv $encrypted_671dc0cb2713_iv -in id_rsa.enc -out id_rsa -d
chmod 400 id_rsa

# tar build
[ -d "$TRAVIS_BUILD_DIR/public" ] && tar cvzf $TARBALL -C $TRAVIS_BUILD_DIR/public .

# upload
scp -o StrictHostKeyChecking=no -i id_rsa $TARBALL $TARGETUSER@$TARGETHOST:
if [ $? -ne 0 ];then
    error_n_exit "failed to upload tarball to $TARGETHOST..."
fi

rm -f id_rsa



