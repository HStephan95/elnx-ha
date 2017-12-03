# !/bin/bash
# basic function om te ssh-en in een host bij problemen

poort=$1
naam=$2

function sshing ()
{
  ssh -p $poort -i /c/Users/$naam/.vagrant.d/insecure_private_key vagrant@127.0.0.1
}

sshing $naam $poort