# Build, Install and run Apache Atlas 

https://atlas.apache.org/#/Downloads


## 1. Build atlas war 

In this example, we use the atlas release version `2.3.0`. You need to replace it if you want build another version.

### 1.1 Install dependencies

```shell
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install apt-utils
sudo apt-get -y install maven \
        wget \
        python \
        openjdk-8-jdk-headless \
        patch \
        unzip 
```

### 1.2 Get the atlas source

```shell
mkdir -p /tmp/atlas-src
cd /tmp

export VERSION=2.3.0

# get the source tar ball
wget https://dlcdn.apache.org/atlas/${VERSION}/apache-atlas-${VERSION}-sources.tar.gz

# untar it to the target folder
tar --strip 1 -xzvf apache-atlas-${VERSION}-sources.tar.gz -C /tmp/atlas-src

# delete the source tar ball
rm apache-atlas-${VERSION}-sources.tar.gz

# go to the extracted source folder
cd /tmp/atlas-src

# replace the maven url with http by https 
sed -i 's/http:\/\/repo1.maven.org\/maven2/https:\/\/repo1.maven.org\/maven2/g' pom.xml

# patch the pom.xml file
cp conf_patch/pom.xml.patch /tmp/atlas-src/
patch -b -f < pom.xml.patch

# build the atlas war
export MAVEN_OPTS="-Xms2g -Xmx4g"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

mvn clean \
        -Dmaven.repo.local=/tmp/atlas-src/.mvn-repo \
        -Dhttps.protocols=TLSv1.2 \
        -DskipTests \
        -Drat.skip=true \
        package -Pdist,embedded-hbase-solr
```

## 2 Deploy the atlas application

If the above steps goes well, you should see a new tar ball(i.e. `apache-atlas-${VERSION}-server.tar.gz`) in 
`/tmp/atlas-src/distro/target/`

```shell
# create a working directory for atlas
mkdir -p /opt/apache-atlas
# create a working directory for gremlin (Optional)
mkdir -p /opt/gremlin

# untar the atlas bin 
tar --strip 1 -xzvf /tmp/atlas-src/distro/target/apache-atlas-${VERSION}-server.tar.gz -C /opt/apache-atlas

# copy the correct version of the hbase-site
cp conf_patch/hbase/hbase-site.xml.template /opt/apache-atlas/conf/hbase/hbase-site.xml.template

# copy the atlas-env.sh
cp conf_patch/atlas-env.sh /opt/apache-atlas/conf/atlas-env.sh

# copy the gremlin conf files (Optional)
cp -r conf_patch/gremlin /opt/gremlin/

# copy the patch file for atlas_config.py
cp atlas_config.py.patch /opt/apache-atlas/bin/
# copy the patch file for atlas_start.py
cp atlas_start.py.patch /opt/apache-atlas/bin/

# goto bin and patch the files
cd /opt/apache-atlas/bin/
patch -b -f < atlas_start.py.patch
patch -b -f < atlas_config.py.patch


# goto the conf file and change the log configuration
cd /opt/apache-atlas/conf
# replace the log dir by /opt/apache-atlas/logs
sed -i 's/\${atlas.log.dir}/\/opt\/apache-atlas\/logs/g' atlas-log4j.xml
# replace the log file name by application.log
sed -i 's/\${atlas.log.file}/application.log/g' atlas-log4j.xml

# create the log file
touch /opt/apache-atlas/logs/application.log

# initiate the application
./atlas_start.py -setup
```

## 3 Run the application

```shell
# start the application
./opt/apache-atlas/bin/atlas_start.py

# watch the log file
tail -f /apache-atlas/logs/application.log
```

## 4. Advance configuration

With the above configuration, we use a file to store user login and password, and there is no access control. To make
a production instance, we need to add an authentication and an authorization mechanism to the Atlas server.

We need to follow the below steps:
- modify the **atlas-application.properties** to enable authentication and authorization mechanism 
- add required authentication conf file (e.g. keycloak.json for keycloak auth)
- add required authorization conf file (e.g. authorization-policy.json)