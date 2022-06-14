resource "aws_ebs_volume" "polkadot_volume" {
    size = 100 
    availability_zone = "us-west-2a" 
    type = "standard"
}

resource "aws_volume_attachment" "attach_demo_volume" { 
    device_name = "/dev/xvdg" 
    volume_id = "${aws_ebs_volume.polkadot_volume.id}" 
    instance_id = "${aws_instance.polkadot-node[0].id}" 
    skip_destroy = true
}

resource "aws_instance" "polkadot-node" {
    ami = var.image 
    instance_type = var.machine_type 
    key_name = "test-key" 
    count = var.node_count 
    ebs_optimized = true
    subnet_id = "${aws_subnet.polkadot-node-subnet.id}" 
    vpc_security_group_ids = ["${aws_security_group.polkadot-sg.id}"]

 root_block_device { 
    volume_size = 50
    volume_type = "gp2" 
    encrypted = true 
    }
 
 tags = {
    Name = "${var.name}-${count.index}" 
    }
}
