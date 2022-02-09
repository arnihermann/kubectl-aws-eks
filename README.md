# Docker and Github Action for Kubernetes CLI

This action provides `kubectl` for Github Actions.

Fork of https://github.com/kodermax/kubectl-aws-eks and https://github.com/actions-hub/kubectl.

## Usage

```yaml
on: push
name: deploy
jobs:
  deploy:
    name: deploy to cluster
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ap-northeast-1

    - name: Login to Amazon ECR
      id: login-ecr
      uses: aws-actions/amazon-ecr-login@v1

    - name: Deploy to cluster
      uses: arnihermann/kubectl-aws-eks@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA_STAGING }}
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
        ECR_REPOSITORY: my-app
        IMAGE_TAG: ${{ github.sha }}
      with:
        args: set image deployment/$ECR_REPOSITORY $ECR_REPOSITORY=$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

    - name: Verify deployment
      uses: arnihermann/kubectl-aws-eks@master
      env:
        KUBE_CONFIG: ${{ secrets.KUBE_CONFIG }}
      with:
        args: rollout status deployment/my-app
```

## Secrets

`KUBE_CONFIG` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```
