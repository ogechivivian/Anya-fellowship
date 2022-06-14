resource "aws_vpc" "polkadot-vpc"{
    cidr_block = "172.26.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        name = "polkadot-vpc"

    }
}
resource "aws_subnet" polkadot-node-subnet {
    cidr_block = "${cidrsubnet(aws_vpc.polkadot-vpc.cidr_block, 3, 1)}"
    vpc_id = "${aws_vpc.polkadot-vpc.id}"
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "polkadot-gw" {
    vpc_id = "${aws_vpc.polkadot-vpc.id}"

    tags = {
      "name" = "polkadot-gw"
    }
  
}


resource "aws_route_table" "polkadot-route-tbl" {

    vpc_id = "${aws_vpc.polkadot-vpc.id}"

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.polkadot-gw.id}"
    }

    tags = {
     "name" = "polkadot-route-tb"
    }
  
}

resource "aws_route_table_association" "polkadot-route-tbl-associaion" {
    subnet_id = "${aws_subnet.polkadot-node-subnet.id}"
    route_table_id = "${aws_route_table.polkadot-route-tbl.id}"
  
}

resource "aws_security_group" "polkadot-sg" {
    name = "externalssh" 
    vpc_id = "${aws_vpc.polkadot-vpc.id}"
}
resource "aws_security_group_rule" "externalssh-polkadot-sg-rule" { 
    type = "ingress" 
    from_port = 22 
    to_port = 22 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.polkadot-sg.id}"
}

resource "aws_security_group_rule" "p2p-polkadot-sg-rule" {
    type = "ingress"
    from_port = 30333
    to_port = 30333
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.polkadot-sg.id}"
}
resource "aws_security_group_rule" "p2p-proxy-polkadot-sg-rule" { 
    type = "ingress" 
    from_port = 80 
    to_port = 80 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.polkadot-sg.id}"
}
resource "aws_security_group_rule" "vpn-polkadot-sg-rule" { 
    type = "ingress" 
    from_port = 51820 
    to_port = 51820 
    protocol = "udp" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.polkadot-sg.id}"
}
resource "aws_security_group_rule" "node-exporter-polkadot-sg-rule" {
    type = "ingress" 
    from_port = 9100 
    to_port = 9100 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.polkadot-sg.id}"
}
resource "aws_security_group_rule" "node-metrics-polkadot-sg-rule" { 
    type = "ingress" 
    from_port = 9616 
    to_port = 9616 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.polkadot-sg.id}"
}
resource "aws_security_group_rule" "allow_all-polkadot-sg-rule" { 
    type = "egress" 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.polkadot-sg.id}"
}


