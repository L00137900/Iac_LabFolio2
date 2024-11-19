from constructs import Construct
from cdktf import App, TerraformStack
from imports.aws.instance import Instance
from imports.aws.provider import AwsProvider

#Configuration for stack settings
class MyMultipleStacksConfig:
    environment: str
    region: str = None
    def __init__(self, environment: str, region: str = None):
        self.environment = environment
        self.region = region

##Initalise terraform stack using the above configuration
class MyMultipleStacks(TerraformStack):
    def __init__(self, scope: Construct, id: str, config: MyMultipleStacksConfig):
        super().__init__(scope, id)

#Selecting the region in AWS
        region = "eu-west-1" if config.region == None else config.region

        AwsProvider(self, "aws",
            region = region
        )

#Creating an EC2 instance
        Instance(self, "Hello",
            ami = "ami-0fcc0bef51bad3cb2",
            instance_type = "t2.micro",
            tags = {
                "environment": config.environment,
            }
        )

#Setup for stack
multi_stack_app = App()
MyMultipleStacks(multi_stack_app, "multiple-stacks-dev", MyMultipleStacksConfig(environment = "dev"))
MyMultipleStacks(multi_stack_app, "multiple-stacks-staging", MyMultipleStacksConfig(environment = "staging"))
MyMultipleStacks(multi_stack_app, "multiple-stacks-production-us", MyMultipleStacksConfig(environment = "staging", region = "eu-central-1"))

multi_stack_app.synth
