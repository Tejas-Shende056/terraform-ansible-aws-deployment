#VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "tf-ansible-vpc"
    }
  
}
#security group
resource "aws_security_group" "web_sg" {
    name = "tf-ansible-project-sg"
    description = "allow ssh and http traffic"
    vpc_id = aws_vpc.main.id  #interpolation

    #incoming
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    
    #outgoing
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}
#public subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "ap-south-1a"

    tags = {
        Name = "tf-ansible-public-subnet"
    }
}
#internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "tf-ansible-igw"
    }
  
}
# 4. Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "tf-ansible-public-rt"
  }
}

# 5. Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
#key pair
resource "aws_key_pair" "tf_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("C:/Users/ADMIN/OneDrive/Desktop/terraform-ansible-aws-deployment/tf-ansible-key.pub")
}

resource "aws_instance" "web_server" {
  ami                    = "ami-01a00762f46d584a1"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.tf_key.key_name

  root_block_device {
    volume_size = 8 # 8 GB SSD (Free Tier covers up to 30 GB)
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-webserver"
    Role = "webserver"
  }
}

resource "aws_instance" "db_server" {
  ami                    = "ami-01a00762f46d584a1"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.tf_key.key_name

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-dbserver"
    Role = "dbserver"
  }
}
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    web_ip = aws_instance.web_server.public_ip
    db_ip  = aws_instance.db_server.public_ip
  })
  filename = "${path.module}/ansible/inventory.ini"
}