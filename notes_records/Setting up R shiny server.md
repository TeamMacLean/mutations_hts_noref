## Setting up R shiny server

* Linux distribtuion is a CentOS 7+

```
cat /etc/*-release
```

```
CentOS Linux release 7.2.1511 (Core)
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CENTOS_MANTISBT_PROJECT="CentOS-7"
CENTOS_MANTISBT_PROJECT_VERSION="7"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="7"

CentOS Linux release 7.2.1511 (Core)
CentOS Linux release 7.2.1511 (Core)
```

* install R

```
sudo yum install R
```

* install shiny and rmakrdown R packages

```
sudo su - -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""
```

* install shiny-server package

download latest server package
```
wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.1.759-rh5-x86_64.rpm
sudo yum install --nogpgcheck shiny-server-1.4.1.759-rh5-x86_64.rpm
```

* once installed server can be managed with systemd

```
sudo systemctl status shiny-server

sudo systemctl restart shiny-server
```
for a detailed configuration please refer to the [administrative guide] (http://rstudio.github.io/shiny-server/latest/)


* further configuration of server for application management

install libxml, lubcurl and openssl to install R devtools pakcages

```
sudo yum install libxml2-devel libcurl-devel openssl-devel

sudo su - -c "R -e \"install.packages('devtools', repos='https://cran.rstudio.com/')\""

sudo su - -c "R -e \"devtools::install_github('rstudio/shinyapps')\""
```

* check out more information about shiny apps, tutorial and artilces at [shiny website](http://shiny.rstudio.com/)


Some basic info about [port configuration and iptables] (https://help.ubuntu.com/community/IptablesHowTo)

