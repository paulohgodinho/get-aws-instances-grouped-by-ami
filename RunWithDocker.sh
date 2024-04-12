image_name_tag="powershell-7.4-alpine-with-awscli"

docker image inspect ${image_name_tag} > /dev/null
if [ $? != 0 ]; then
    echo "Image not found, Building with tag '${image_name_tag}'"
    docker build . -t ${image_name_tag}
fi

docker run -v "$(pwd)":/testfolder $image_name_tag