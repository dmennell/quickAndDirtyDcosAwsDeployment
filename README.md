# Quick & Dirty DC/OS Deployment on AWS
This is meant to be a quick and dirty set of instructions to deploy DC/OS on AWS using the Terraform Installer.  It includes many common variables in the main.tf file.

## PREREQUISITES & DOWNLOAD
these instructions assume that you are using a mac as your desktop.  If you are using Windows, Linux, or Solaris, please adjust accordingly

### Install Dependencies

Install HomeBrew first
- `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

Install Required Packages
- `brew install git terraform awscli`

### Create & Add SSH keys
If you already have an ssh key you would like to use, that is fine, but you will need to make sure to execute the ssh-add step, and modify line 20 of the main.tf file accordingly.  This SSH key will be used to SSH into the Linux nodes if necessary.
-  `ssh-keygen -t rsa`
-  `ssh-add ~/.ssh/id_rsa`

### Authenticate with AWS
depending on your method to authenticate with AWS, this step may be different.  At Mesosphere, we use a utility that genertates temp credentials that expire.  Your organization may have its own mechanism.  Here is a link that covers setting up the AWScli:
https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

## INSTALL ENTERPRISE DC/OS ON AWS 

### Prepare Files for Deployment:
- Create a new directory somewhere
- Place the supplied "main.tf" and "license.txt" files in this directory
- Navigate Terminal session to the newly created directory that includes the make.tf and license.txt file
    - Modify the make.tf file as desired:
        - Line 19: Give your cluster a name.  this name will be used to create the AWS nodes as well as DC/OS Cluster (lower case characters and dashes only please)
        - Line 23: Select number of masters (must be odd number eg 1, 3, 5)
        - Line 24: Select number of Private Agents (this is the primary worker node)
        - Line 25: Select number of Public Agents (provide ingress to DC/OS cluster)
        - Lines 27-30: Select Instance types for each node type (included recommendations work well)

### Set AWS Region
execute one of the following commands to set the AWS region for deployment
- `export AWS_DEFAULT_REGION="<desired-aws-region>"`
    
    Examples:
    - `export AWS_DEFAULT_REGION="us-east-1"`
    - `export AWS_DEFAULT_REGION="us-west-2"`

### Initialize Terraform Deployment
-  `terraform init -upgrade=true`

### Create Deployment Plan
This step creates and validates the deployment plan
-  `terraform plan -out plan.out`

### Apply Deployment Plan
this step will take some time, but if successful, the process will end by giving you the IP addresses of the master nodes and appropriate Load Balancers.
-  `terraform apply plan.out`

Make sure to keep a copy of the directory you created as it will be needed for tearing down your DC/OS cluster and all related resources

## Cluster Tear-Down
Once you are done with your cluster, you will need to tear it, along with all the other created resources, down.  Make sure your terminal is navigated to the directory that you created at the beginning of this step.

### refresh credentials if necessary
-  However you authenticated with AWS before, your credentials may have expired

### Reset AWS Region
Execute one of the following commands to set the AWS region for deployment in case you set another one as default since deploying this cluster.
- `export AWS_DEFAULT_REGION="<desired-aws-region>"`
    
    Examples
    - `export AWS_DEFAULT_REGION="us-east-1"`
    - `export AWS_DEFAULT_REGION="us-west-2"`

### Destroy
This step executes the cluster teardown process.  when prompted, answer "yes" to confirm that you want to destroy everything.
-  `terraform destroy`

Once you have confirmed that the cluster and all associated resources have been destroyed via the AWS console, it safe to delete the created dirtectory if so desired.
