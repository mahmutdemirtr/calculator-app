provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_instance" "flask_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              # Sistemi güncelle
              sudo yum update -y
              
              # Gerekli paketleri yükle
              sudo yum install -y python3 python3-pip yum-utils

              # Flask ve bağımlılıkları yükle
              pip3 install flask
              
              # requirements.txt varsa yükle
              if [ -f /home/ec2-user/requirements.txt ]; then
                pip3 install -r /home/ec2-user/requirements.txt
              fi

              # HashiCorp repository ekle ve Terraform yükle
              sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
              sudo yum install -y terraform

              # Flask uygulamasını başlat
              echo "from flask import Flask\napp = Flask(__name__)\n@app.route('/')\ndef home():\n    return 'Merhaba, Flask Server Çalışıyor!'\n\nif __name__ == '__main__':\n    app.run(host='0.0.0.0', port=5000)" > /home/ec2-user/app.py
              
              python3 /home/ec2-user/app.py &
              
              EOF

  tags = {
    Name = "FlaskTerraformInstance"
  }
}
