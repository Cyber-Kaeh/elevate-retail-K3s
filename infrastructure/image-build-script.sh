#! /bin/bash

# Be sure to run from the root of the project
# Usage: ./infrastructure/image-build-script.sh


# Associative array to hold key-value pairs for service name and Dockerfile path
declare -A services=(
    ["auth-service"]="auth-service/Dockerfile"
    ["cart-service"]="cart-service/Dockerfile"
    ["frontend-service"]="frontend-service/Dockerfile"
    ["inventory-service"]="inventory-service/Dockerfile"
    ["orders-service"]="orders-service/Dockerfile"
    ["payment-service"]="payment-service/Dockerfile"
    ["products-service"]="products-service/Dockerfile"
    ["shipping-service"]="shipping-service/Dockerfile"
    ["users-service"]="users-service/Dockerfile"
)

for i in "${!services[@]}"
do
    echo "Service Name: $i, Path: '${services[$i]}', Image name: $i:latest"
    sudo docker build -t "$i":latest -f "${services[$i]}" "${services[$i]%/*}"
    if [ $? -ne 0 ]; then
        echo "Error building image for service: $i"
        exit 1
    fi
    echo "Image $i:latest built successfully."
    echo "Saving and importing image now..."
    sudo docker save "$i":latest | sudo k3s ctr images import -
    echo "--------------------------------------------------------"
done