resource "aws_key_pair" "ftps_test" {
  key_name   = "${var.pj-prefix}-ftps-test"
  public_key = file(var.public_key_path)
}

### Windowsインスタンスを指定
data "aws_ami" "windows_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-2020.09.09"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "ftps_server" {
  ami                         = data.aws_ami.windows_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ftps_test.id
  subnet_id                   = aws_subnet.public-a.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ad_profile.name

  vpc_security_group_ids = [
    aws_security_group.ssh_rdp.id
  ]

  tags = {
    Name = "${var.pj-prefix}-server"
  }
}

resource "aws_eip" "ftps_server" {
  instance = aws_instance.ftps_server.id
  vpc      = true
}

resource "aws_instance" "ftps_client" {
  ami                         = data.aws_ami.windows_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ftps_test.id
  subnet_id                   = aws_subnet.public-a.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ad_profile.name

  vpc_security_group_ids = [
    aws_security_group.ssh_rdp.id
  ]

  tags = {
    Name = "${var.pj-prefix}-client"
  }
}

resource "aws_eip" "ftps_client" {
  instance = aws_instance.ftps_client.id
  vpc      = true
}

# Output Param
output "ftps_server_public-dns" {
  value = aws_eip.ftps_server.public_dns
}
output "ftps_client_public-dns" {
  value = aws_eip.ftps_client.public_dns
}