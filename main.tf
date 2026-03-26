# Netskope Resources

# Create Publisher in Netskope
resource "netskope_npa_publisher" "Publisher" {
  publisher_name = var.publisher_name
}

# Forces the token to be recreated each apply
# Avoids spinning up new publisher instances with invalid tokens
resource "time_rotating" "Publisher_token" {
  rotation_minutes = 1
}

resource "time_static" "rotate" {
  rfc3339 = time_rotating.Publisher_token.rfc3339
}

resource "netskope_npa_publisher_token" "Publisher" {
  depends_on   = [time_rotating.Publisher_token]
  publisher_id = netskope_npa_publisher.Publisher.publisher_id
  lifecycle {
    replace_triggered_by = [
      time_static.rotate
    ]
  }
}

# AWS Data

# Filter Netskope Publishers AMIs for the latest version
data "aws_ami" "npa-publisher" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["Netskope Private Access Publisher*"]
  }
}

# Create EC2 Instance for the Publisher
resource "aws_instance" "NPAPublisher" {
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.npa-publisher.id
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile != null ? var.iam_instance_profile : (var.use_ssm ? aws_iam_instance_profile.ssm[0].name : null)
  instance_type               = var.aws_instance_type
  key_name                    = var.aws_key_name
  subnet_id                   = var.aws_subnet
  vpc_security_group_ids      = [var.aws_security_group]
  user_data_base64            = var.use_ssm == true ? null : netskope_npa_publisher_token.Publisher.token
  monitoring                  = var.aws_monitoring
  ebs_optimized               = var.ebs_optimized
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }
  tags = {
    "Name" = var.publisher_name
  }

  metadata_options {
    http_endpoint = var.http_endpoint
    http_tokens   = var.http_tokens
  }
}

# Create SSM Document for Publisher with versioning
resource "aws_ssm_document" "PublisherRegistration" {
  count         = var.use_ssm == true ? 1 : 0
  name          = "SSM-Register-${var.publisher_name}"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Register a Netskope Publisher via SSM"
    parameters    = {}
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "registerPublisher"
        inputs = {
          runCommand = ["sudo /home/ubuntu/npa_publisher_wizard -token \"${netskope_npa_publisher_token.Publisher.token}\""]
        }
      }
    ]
  })

  document_format = "JSON"
}

# Associate Publisher with SSM
resource "aws_ssm_association" "register_publishers" {
  count            = var.use_ssm == true ? 1 : 0
  name             = aws_ssm_document.PublisherRegistration[0].name
  association_name = "Register-${var.publisher_name}"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.NPAPublisher.id]
  }
}
