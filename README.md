# docker-srrs-tooling
Tooling image with AWS, MySQL cli and few more tools. Once created, pod will continue working till terminated. Also contains a sample of Persistent Volume Claim and Drone pipeline.

Docker image is available from:
quay.io/ukhomeofficedigital/srrs-tooling:latest

Please let me know if you want other tools and I will add them in:
leszek.sliwko@digital.homeoffice.gov.uk


# How to use?
1) Create a srrs-tooling pod:
```
kubectl apply -f srrs-tooling.yaml
```

2) Connect to pod (start bash):
```
kubectl exec -it srrs-tooling bash
```

3) Export AWS credentials (from within pod):
```
export AWS_ACCESS_KEY_ID=[your access key id]
export AWS_SECRET_ACCESS_KEY=[your secret access key]
```

# How to mount PVC (Persistent Volume Claim)?
1) Uncomment lines between --- PVC BEGIN --- and --- PVC END --- (volumes and volumeMounts sections) in srrs-tooling.yaml

2) Create Persistent Volume Claim (100 GB):
```
kubectl apply -f srrs-tooling-pvc.yaml
```

3) Create srrs-tooling pod:
```
kubectl apply -f srrs-tooling.yaml
```

Note: PVC mounts an Amazon Elastic Block Storage volume which can be costly. Please check costs here:
https://aws.amazon.com/ebs/pricing/


# Apps folder
Files in apps folder are unpacked and copied over to the resulting Docker image (into user's home folder).

Note: ADD command supports local-only tar extraction which uses tar tool for extraction. Tar command works with any supported compression method like tar, tar.xz, tar.gz, etc.
For further references see: https://docs.docker.com/engine/reference/builder/#add
