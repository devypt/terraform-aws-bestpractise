resource "aws_instance" "data-server-a" {
  depends_on = ["aws_instance.bastion-eu-west1a"]

  connection {
    user     = "ec2-user"
    key_file = "${aws_key_pair.terraform.key_file}"
  }

  availability_zone = "${lookup(var.availability_zone,"primary")}"
  ami               = "${lookup(var.amazon_amis,"${var.region}")}"
  instance_type     = "t2.micro"
  key_name          = "${aws_key_pair.terraform.id}"

  security_groups = ["${aws_security_group.allow_bastion.id}"]

  subnet_id = "${aws_subnet.private-One.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
}

resource "aws_instance" "data-server-b" {
  depends_on = ["aws_instance.bastion-eu-west1b"]

  connection {
    user     = "ec2-user"
    key_file = "${aws_key_pair.terraform.key_file}"
  }

  availability_zone = "${lookup(var.availability_zone,"secondary")}"
  ami               = "${lookup(var.amazon_amis,"${var.region}")}"
  instance_type     = "t2.micro"
  key_name          = "${aws_key_pair.terraform.id}"

  security_groups = ["${aws_security_group.allow_bastion.id}"]

  subnet_id = "${aws_subnet.private-Two.id}"
}
