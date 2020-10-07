# bobobox
answer to the bobobox assignment

  1. Vpc and EC2 instances 


# How To run this program
  - first thing first configure the aws secret credentials 
    $ aws configure
    AWS Access Key ID [None]: YOUR_AWS_ACCESS_KEY_ID
    AWS Secret Access Key [None]: YOUR_AWS_SECRET_ACCESS_KEY
    Default region name [None]: YOUR_AWS_REGION
    Default output format [None]: json

  2. Provision and Deploy kubernetes EKS Cluster

  - after successfully install kubernetes cluster, adjust the preference of `~/.kube/config` so it pointing to the new created cluster
  take all the output shown by `terraform apply` and adjust the `~/.kube/config` when the install succed it will generate new `kube-config`
  use it to connect to our new cluster

  - configure `kubectl`
     aws eks --region ap-southeast-1 update-kubeconfig --name bobobox-exam-kqkWBTjb

  - deploy kubernetes Metrics Server

  - after metrics server is done, continue to deploy kubernetes dashboard
  authenticate the dashboard,
