from constructs import Construct
from cdktf import App, TerraformStack
from imports.aws.ec2 import Instance
from imports.aws.provider import AwsProvider

#Default configurations
DEFAULT_AMI_ID = "ami-0fcc0bef51bad3cb2"   # AMI ID for EC2 instance
DEFAULT_INSTANCE_TYPE = "t2.micro"         # EC2 instance type
DEFAULT_REGION = "eu-west-1"               # Default Region

#Configuration for stack settings
class MyMultipleStacksConfig:
    environment: str
    region: str = None

    def __init__(self, environment: str, region: str = None):
        self.environment = environment
        self.region = region or DEFAULT_REGION

##Initalise terraform stack using the above configuration
class MyMultipleStacks(TerraformStack):
    def __init__(self, scope: Construct, id: str, config: MyMultipleStacksConfig):
        super().__init__(scope, id)

#Specifying the AWS Provider region
        region = DEFAULT_REGION or config.region

        AwsProvider(self, "aws",
            region = region
        )

#Creating an EC2 instance
        Instance(self, "Hello",
            ami = DEFAULT_AMI_ID,
            instance_type = DEFAULT_INSTANCE_TYPE,
            tags = {
                "environment": config.environment,      #Specifies environment across deployment stages
                "region": region,                       #Specify region
                "owner": "FridayHITT",                  #Specifying the team managing the EC2 instance
                "use case": "Web site server"              #Specifying the use case of the EC2 instance
            }
        )

#Setup for stack
multi_stack_app = App()
MyMultipleStacks(multi_stack_app, "multiple-stacks-dev", MyMultipleStacksConfig(environment = "dev"))
MyMultipleStacks(multi_stack_app, "multiple-stacks-staging", MyMultipleStacksConfig(environment = "staging"))
MyMultipleStacks(multi_stack_app, "multiple-stacks-production-us", MyMultipleStacksConfig(environment = "staging", region = "eu-west-1"))

multi_stack_app.synth
