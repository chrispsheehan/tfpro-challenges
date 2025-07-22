locals {
  csv = csvdecode(file("./ec2.csv"))

  type_lookup = {
    "micro": "2.micro",
    "nano": "3.nano"
  }

  ec2s = [
    for row in local.csv : {
      ami  = row.AMI_ID,
      type = lookup(local.type_lookup, row.instance_type, "default"),
      name = row.Team_Name
      region = row.Region
    }
    if row.Region == "us-east-1"
  ]
}

resource "aws_instance" "web" {
  
  count = length(local.ec2s)

  ami           = local.ec2s[count.index].ami
  instance_type = local.ec2s[count.index].type

  tags = {
    Name = local.ec2s[count.index].name
  }
}

output "name" {
  value = local.ec2s
}

output "running_ec2" {
  value =  [for idx in range(length(local.ec2s)) : { 
    firewall_id = toset([
      aws_instance.web[idx].security_groups,
    ])
    id = aws_instance.web[idx].id
    region = local.ec2s[idx].region
    subnet = aws_instance.web[idx].subnet_id
    team = local.ec2s[idx].name
    type = local.ec2s[idx].type
  }]
}
  
#   foreach( v in length(local.ec2s)) {
#     firewall_id = toset([
#       aws_instance.web[*].security_groups,
#     ])
#     "id" = "i-0167b045e08b6ffee"
#     "region" = "us-east-1"
#     subnet = aws_instance.web[*].subnet_id
#     "team" = "Security"
#     "type" = "micro"
#   }
