####  CONFIG SECTION ####
ADMIN_USER=m2d2   # your username. 
THIS_IP=192.168.122.251
HOSTNAME=m2d2 # this hostname.
DOMAIN=localdomain  #  this internet domain.
YUM="yum -y"        # how to run yum.
DELAY=1             # how long to delay before an action, hit control-c to break
GLOBAL_PRETEND=N    # will do everything but actually run the step 
# do_step --again 1  # will do a step again the first time; bump the number for
#                    #   multiple agains. 
# do_step --logfirst # will log the step as done, then do it. needed for reboot.
# do_step --pretend # will pretend to do only this step
. ../common.sh  # bring in definition of do_step

