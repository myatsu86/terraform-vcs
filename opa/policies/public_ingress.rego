package terraform.security

import rego.v1
import input.plan as plan

# Collect CIDRs from standalone ingress resources.
ingress_sources contains source if {
    resource := plan.resource_changes[_]
    resource.type == "aws_vpc_security_group_ingress_rule"

    source := {
        "address": resource.address,
        "cidr": resource.change.after.cidr_ipv4,
    }
}

# Collect CIDRs from inline security group ingress blocks.
ingress_sources contains source if {
    resource := plan.resource_changes[_]
    resource.type == "aws_security_group"

    some ingress in resource.change.after.ingress
    some cidr in ingress.cidr_blocks

    source := {
        "address": resource.address,
        "cidr": cidr,
    }
}

deny contains msg if {
    some source in ingress_sources
    source.cidr == "0.0.0.0/0"

    msg := sprintf(
        "%s cannot allow ingress from 0.0.0.0/0",
        [source.address],
    )
}

deny contains msg if {
    some source in ingress_sources
    is_string(source.cidr)

    not startswith(source.cidr, "10.")
    not endswith(source.cidr, "/32")

    msg := sprintf(
        "%s uses CIDR %s. Sources outside 10.* must use /32.",
        [source.address, source.cidr],
    )
}
