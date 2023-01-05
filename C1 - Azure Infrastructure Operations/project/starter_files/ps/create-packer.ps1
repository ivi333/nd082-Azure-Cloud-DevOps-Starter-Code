#resource group must be created first using azure portal o terraform (out of scope in this script)
packer build  \
    -var "image_name=myPackerImage" \
    -var "resource_group_name=udacity" \
    -var "created_by=IvanG" \
    server.json