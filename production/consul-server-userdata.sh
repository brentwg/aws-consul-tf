#!/bin/bash
# ------------------------------------------------------------------------
# Userdata script used to bootstrap the installation/config of Consul
# Server instances.
# 
# Brent G.
# 2018-02-21
# ------------------------------------------------------------------------

# Update software package list
apt-get -y update
                              
# Install required packages
apt-get install -y ${BOOTSTRAP_PACKAGES}

# Install the AWS cfn-init tools
easy_install ${CFN_BOOTSTRAP_URL}

# Run Consul server bootstrap script
echo https://${S3BUCKET_NAME}.s3.amazonaws.com/${S3BUCKET_PREFIX}scripts/${CONSUL_BOOTSTRAP_FILE}
wget https://${S3BUCKET_NAME}.s3.amazonaws.com/${S3BUCKET_PREFIX}scripts/${CONSUL_BOOTSTRAP_FILE}
chmod +x ${CONSUL_BOOTSTRAP_FILE}

./${CONSUL_BOOTSTRAP_FILE} \
  --consul_expect ${CONSUL_EXPECT} \
  --consul_tag_key ${CONSUL_TAG_KEY} \
  --consul_tag_value ${CONSUL_TAG_VALUE} \
  --s3bucket ${S3BUCKET_NAME} \
  --s3prefix ${S3BUCKET_PREFIX}
