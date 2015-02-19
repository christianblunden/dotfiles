[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
export KAFKA_HOME=~/code/apache-kafka
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=~/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
export DEISCTL_TUNNEL=172.17.8.100
export ANDROID_HOME=/usr/local/opt/android-sdk

source ~/.bashrc
