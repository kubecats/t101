#!/usr/bin/env python
from constructs import Construct
from cdktf import App, NamedRemoteWorkspace, TerraformStack, TerraformOutput, RemoteBackend
from cdktf_cdktf_provider_aws import AwsProvider, ec2
from imports.vpc import Vpc


class MyStack(TerraformStack):
    def __init__(self, scope: Construct, ns: str):
        super().__init__(scope, ns)

        AwsProvider(self, "AWS", region="ap-northeast-2")

        instance = ec2.Instance(self, "compute",
                                ami="ami-09cf633fe86e51bf0",
                                instance_type="t2.micro",
                                )

        TerraformOutput(self, "public_ip",
                        value=instance.public_ip,
                        )


app = App()
stack = MyStack(app, "aws_instance")

app.synth()