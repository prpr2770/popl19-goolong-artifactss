# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

export GOROOT=/usr/lib/golang
export GOPATH=$HOME/projects
export PATH=$PATH:$GOROOT/bin

SCALA_VERSION="2.12"
export SCALA_HOME=/home/ec2-user/scala-${SCALA_VERSION}
export PATH=$PATH:/home/ec2-user/scala-${SCALA_VERSION}/bin

export JAVA_HOME=/usr/java/default
