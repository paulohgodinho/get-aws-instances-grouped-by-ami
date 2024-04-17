$image_name_tag = "powershell-7.4-alpine-with-awscli"

docker image inspect $image_name_tag | Out-Null

if($LASTEXITCODE -ne 0) {
    Write-Warning "Image not found, Building with tag '${image_name_tag}'"
    docker build . -t $image_name_tag
}

$filesVolumeMap = "${PWD}:/files"
$homeVolumeMap = "${HOME}/.aws:/root/.aws"
docker run -v $filesVolumeMap -v $homeVolumeMap $image_name_tag $args
