# install crossplane
helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace

# check installation
kubectl get pods -n crossplane-system
kubectl api-resources | grep crossplane

# install s3 provider 
cat <<EOF | kubectl apply -f -
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-s3
spec:
  package: xpkg.upbound.io/upbound/provider-aws-s3:v0.37.0
EOF

cat <<EOF | kubectl apply -f -
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-sqs
spec:
  package: xpkg.upbound.io/upbound/provider-aws-sqs:v0.37.0
EOF

# check providers
kubectl get providers
kubectl get crds

# create AWS secret
kubectl create secret generic aws-secret -n crossplane-system --from-file=creds=./aws-credentials.txt

kubectl describe secret aws-secret -n crossplane-system

# create provider configuration
cat <<EOF | kubectl apply -f -
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-secret
      key: creds
EOF

# test it by creating an s3 bucket

bucket=$(echo "crossplane-bucket-"$(head -n 4096 /dev/urandom | openssl sha1 | tail -c 10))
cat <<EOF | kubectl apply -f -
apiVersion: s3.aws.upbound.io/v1beta1
kind: Bucket
metadata:
  name: $bucket
spec:
  forProvider:
    region: us-east-2
  providerConfigRef:
    name: default
EOF

kubectl get buckets

kubectl delete bucket $bucket

