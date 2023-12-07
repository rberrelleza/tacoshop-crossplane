# create the CompositeResourceDefinition
kubectl apply -f compositeresourcedefinition.yaml

kubectl get xrd

kubectl api-resources | grep oktaco.shop

# Create the composition
kubectl apply -f composition.yaml
kubectl get composition


#  test composition
#name=$(echo "oktaco-infra-"$(head -n 4096 /dev/urandom | openssl sha1 | tail -c 10))
name=oktaco-infra-arsh
kubectl apply -f cloud-infra

kubectl get infra
kubectl delete infra $name

