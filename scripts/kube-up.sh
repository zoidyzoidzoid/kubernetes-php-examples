#!/usr/bin/env bash
set -efu

SCRIPTS_DIR=$(dirname -- $0)
BASE_DIR=$(dirname -- "${SCRIPTS_DIR}")

. "${SCRIPTS_DIR}/_colours.sh"

echo_green "Starting minikube (using the xhyve driver)"

if ! which docker-machine-driver-xhyve &> /dev/null; then
  brew install docker-machine-driver-xhyve
  sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
  sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
fi

if ! grep -q /Users /etc/exports; then
  echo "/Users -network 192.168.64.0 -mask 255.255.255.0 -alldirs -maproot=root:wheel" | sudo tee -a /etc/exports
fi

sudo nfsd restart
minikube start --memory=4096 --cpus=2 --vm-driver=xhyve
minikube ssh -- sudo mkdir -p /Users
minikube ssh -- "if [ -z \"\$(mount | grep User | grep 192.168.64.1)\" ]; then sudo busybox mount -t nfs -oasync,noatime,nolock 192.168.64.1:/Users /Users; fi"

echo
echo "You'll need to run the following to interact with Docker:"
echo "    eval \$(minikube docker-env)"
echo
echo "minikube VM IP: $(minikube ip)"
