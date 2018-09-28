# docker-srrs-tooling
Tooling image with AWS, MySQL cli and few more tools
Also contains sample of Persistent Volume Claim and Drone pipeline

Docker image is available from:
quay.io/ukhomeofficedigital/srrs-tooling:latest


# How to use?
1) Create a srrs-tooling pod:
kubectl apply -f srrs-tooling.yaml

2) Connect to pod
then bash into it:
kubectl exec -it srrs-tooling bash


3) Export AWS credentials (from within pod):
export AWS_ACCESS_KEY_ID=[your access key id]
export AWS_SECRET_ACCESS_KEY=[your secret access key]

# How to mount PVC (Persistent Volume Claim)?
1) Uncomment lines between --- PVC BEGIN --- and --- PVC END --- (volumes and volumeMounts sections) in srrs-tooling.yaml

2) Create PVC (50 GB):
kubectl apply -f srrs-tooling-pvc.yaml

3) Create srrs-tooling pod:
kubectl apply -f srrs-tooling.yaml