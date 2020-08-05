# Muokata Terrafrom EKS

## Setup


### Install and configure awscli

```
pip install awscli
```

If you dont have an aws config yet run
```
aws configure
```


### Install aws-iam-authenticator

https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

#### MacOS
```
brew install aws-iam-authenticator
```

#### Linux
```
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator && chmod +x aws-iam-authenticator
```

Make sure `aws-iam-authenticator` is in your `$PATH`

### Install kubectl

#### MacOS
```
brew install kubernetes-cli
```

#### Linux
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl
```

### Terraform

Get terrafrom 0.12.x https://www.terraform.io/downloads.html

Create a `terraform.tfvars` file with variables

```
aws_key_name  = <key_name> # ie. k8s
key_file_path = <key_path> # ie. /home/k8s/SSHKEYS/k8s.pem
```

Initialize and create terraform eks infrastrucutre

```
terraform init
```

```
terraform plan
```

```
terraform apply
```

Uncomment the line in `remote.tf`. This is for locking but we have to create the dynamodb table first.

```
dynamodb_table = "terraform-muokata-prod-lock" # rename this if it is a different env
```

This has to be run again as the `remote` config changed
```
terraform init
```

## kubectl config

After the cluster is built you can get the kubectl config via

```
terraform output
```

Put this config in `$HOME/.kube/config`

ie.

```
clusters:
- cluster:
    server: https://C2EB9242643B3270D720030B778E48DA.gr7.us-east-1.eks.amazonaws.com
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJd01EVXhNVEU1TXpFek5Wb1hEVE13TURVd09URTVNekV6TlZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT25DClhvWWR5QVNaYmtBUHJhSFFMa1NBVTA5bDdZS29JZW8vVWJWTTM4Ky9kZW9jbVVJY2xjUmFBbTdzYU54cEMveksKaW4yRG9pbm95SnVDQzJ5RXZNMGtGamhpdDZ3N0pqU2tlVkJ1VDJITDBPQkl5dXRDNW5iNGdINk5YU2IvMlF6TwpnSUZXSDlHcDhmQnUxRGVrajF0VEdpNjR6OWc4MFV0TzRiRVRXeUFQbWVsYXI2QU9KTklOTUg4amN2QlIwNDRHCmdULzNiRElEcUFWWWl0ZU9qVC9PWHRjbm40ZDYwTmpsZkpzREZhL0hzTDA0SWRweEF5YlhOTGtDRVRPTENCL1gKSXZJa3RhQkJaWUpjODlGVzJUQXVlVDhaanVwMW5YRGxrNGQxTWtVYXAweXczREQrNGQvQ2ZoeGtkdGhpREVSVApJT0hVTUZ1ZWRZaW9lWXY5L1hFQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFIMlpnWW82amplaWdYTEQ1WGZwWStHYzJoQ1YKUnh3c1dBNFVDUFFwc0JOWDhTcDhHQ1FVUDBZTmphRG1kOTJ5TUZ3UHk0L3BiekRHTzlQZTc5QnhRL1l5M0dscQpndEg4ZTRxeTE3RWYrR1RvSWE4bkt1UU5wOXRJTDBUV1I5U0NVekM3aXA1MzhiY2dLcS9McWk0YlcvSkRSSUxSClkzZm9Dckd5bVdMRW95RmJTbkwydUhLOWw0ckttQk1rY1Ard3ZaQzJqQmNnbk8yYkxOckR5T0xNeUd0djhuWFkKYWIzZHNyWWJnTy83eWNKQnMvL2RwanhHelFiTXJpVXlGNUhRZ0Q1aUsvSnUrNGZSNWsyeUZZdk1POHlYdnA0dgpyZkgramszcnYrOVR6ZFRLQk9tc25TN0N3UkVPNElvQTZZZHR6MDNkQjNrOE5GTlJlQys4S0NEWmNlVT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  name: eks_muokata-eks-prod

contexts:
- context:
    cluster: eks_muokata-eks-prod
    user: eks_muokata-eks-prod
  name: eks_muokata-eks-prod

current-context: eks_muokata-eks-prod

users:
- name: eks_muokata-eks-prod
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "muokata-eks-prod"
```

## Log into worker nodes

If you have to log into one of the worker nodes you have to do this though a `bastion` host. To do this use the ssh config in the dir `sshconfigs`.

You first have to configure the file in `sshconfigs/` that you are going to use ie. `sshconfigs/eks-workers-prod`. Replace `<ssh_file_file_path>` with the path to the ssh keyfile.

Get worker nodes

```
kubectl get nodes
```

```
NAME                         STATUS   ROLES    AGE    VERSION
ip-10-0-1-172.ec2.internal   Ready    <none>   147m   v1.16.8-eks-e16311
ip-10-0-2-164.ec2.internal   Ready    <none>   147m   v1.16.8-eks-e16311
ip-10-0-3-49.ec2.internal    Ready    <none>   147m   v1.16.8-eks-e16311
```

SSH into a worker node

```
ssh -F sshconfigs/eks-workers-prod ip-10-0-2-164.ec2.internal
```
