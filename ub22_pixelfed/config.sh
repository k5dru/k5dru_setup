####  CONFIG SECTION ####
ADMIN_USER=lemley   # your username. 
THIS_IP=127.0.0.1
HOSTNAME=pixelfed # this hostname.
DOMAIN=moist.live  #  this internet domain.
APT="apt -y"        # how to run yum.
DELAY=1             # how long to delay before an action, hit control-c to break
GLOBAL_PRETEND=N    # will do everything but actually run the step 
# do_step --again 1  # will do a step again the first time; bump the number for
#                    #   multiple agains. 
# do_step --logfirst # will log the step as done, then do it. needed for reboot.
# do_step --pretend # will pretend to do only this step
. ../common.sh  # bring in definition of do_step

