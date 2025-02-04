#!/bin/bash
set -e

wget -O /tmp/aws-gpu-boost-clock.sh 'https://github.com/aws-samples/aws-efa-nccl-baseami-pipeline/raw/master/nvidia-efa-ami_base/boost/aws-gpu-boost-clock.sh'
wget -O /tmp/aws-gpu-boost-clock.service 'https://github.com/aws-samples/aws-efa-nccl-baseami-pipeline/raw/master/nvidia-efa-ami_base/boost/aws-gpu-boost-clock.service'
sudo mv /tmp/aws-gpu-boost-clock.sh /opt/aws/ && sudo chmod +x /opt/aws/aws-gpu-boost-clock.sh
sudo mv /tmp/aws-gpu-boost-clock.service /lib/systemd/system
sudo systemctl enable aws-gpu-boost-clock.service && sudo systemctl start aws-gpu-boost-clock.service