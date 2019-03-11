# code-challenge

##### This is a sample set of instructions to build out an EC2 instance with the latest version of the HVM Ubuntu Trusty AMI
##### It installs and configures and Apache instance that will randomly select from {1..5} different cat images.
##### It also provisions an S3 bucket, although not used, but non-the-less, it is still there. :)

__What happens__
1.  A T2.Micro is configured and setup
2.  Security group is created and assigned to the ec2 instance allowing port 80 and 22. ( I would remove port 22 from the external side )
3.  IAM Policy,Role,Profile, all get created and assigned to the ec2 instance.
4.  S3 Bucket get created

__Things to note.__
 *There are some variables that will be specific to the environment.  (aws_region, aws_profile, vpc_id, subnet_id are examples)*

As always there is *many* ways to skin the cat, as the ol' saying goes. I picked one and went with it.
There are some files that are referenced that I purposely didn't include in the repo. In the notes below, I did include the script used to rotate the cat image(s).

__My Thoughts__

I had the thought process of very minimal infrastructure was already in place. Just a VPC and subnets were counted in the infrastructure. Nothing else. No Configuration Management, no docker repos, etc...

If I was to do this with some more existing infrastructure, like a docker repo , I would have utilized/created  a docker image with all the necessary configs and source files to deploy.
Or if there was a configuration management solution (Puppet, SaltStack), I would put some of the config management there.

I made use of both the "userdata" and the terraform "provisioner" options here. I chose the provisioner to upload the "payload" with all the files needed to configure apache.

1.  .htaccess file to make sure apache doesn't cache in this case.
2.  index.html to serve up the page and images
3.  The script cron calls to rotate the images. (See Code below)


__rotate_image.sh__
```#!/usr/bin/env bash
images=(1 2 3 4 5)
rand=$[$RANDOM % ${#images[@]}]
img_loc=/var/www/html
img_liv=/var/www/html/cat.jpg
while [ ${rand} = 0 ]
  do
    rand=$[$RANDOM % ${#images[@]}]
  done
img_name=cat${rand}.jpg
cp ${img_loc}/${img_name} ${img_liv}
echo " ${img_name} on `date` " >> /tmp/rotate.log```
