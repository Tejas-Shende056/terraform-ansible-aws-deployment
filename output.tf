output "web_server_ip" {
    description = "public ip of ansible instannce"
    value = aws_instance.web_server.public_ip
  
}
output "db_server_ip" {
    description = "Public ip of db server"
    value = aws_instance.db_server.public_ip
  
}
