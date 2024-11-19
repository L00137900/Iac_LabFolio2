from constructs import Construct
from cdktf import App, TerraformStack
from imports.aws.instance import Instance
from imports.aws.provider import AwsProvider

class MyMultipleStacksConfig:
    environment: str
    region: str = None
    def __init__(self, environment: str, region: str = None):
        self.environment = environment
        self.region = region


class MyMultipleStacks(TerraformStack):
    def __init__(self, scope: Construct, id: str, config: MyMultipleStacksConfig):
        super().__init__(scope, id)

        region = "eu-west-1" if config.region == None else config.region

        AwsProvider(self, "aws",
            region = region
        )

        Instance(self, "Hello",
            ami = "ami-0fcc0bef51bad3cb2",
            instance_type = "t2.micro",
            tags = {
                "environment": config.environment,
            }
        )

multi_stack_app = App()
MyMultipleStacks(multi_stack_app, "multiple-stacks-dev", MyMultipleStacksConfig(environment = "dev"))
MyMultipleStacks(multi_stack_app, "multiple-stacks-staging", MyMultipleStacksConfig(environment = "staging"))
MyMultipleStacks(multi_stack_app, "multiple-stacks-production-us", MyMultipleStacksConfig(environment = "staging", region = "eu-central-1"))

multi_stack_app.synth
