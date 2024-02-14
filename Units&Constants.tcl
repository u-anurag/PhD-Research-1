
# UNITS AND CONSTANTS

####################
########### SI UNITS
####################
set kip 1.0;
set in	1.0;
set sec	1.0;

# Constants
set g		[expr 386.2*$in/pow($sec,2)];
set pi      [expr acos(-1.0)];

#################
###########################
########### DEPENDENT UNITS
###########################

set ft      [expr $in*12.0];
set lb      [expr $kip/1000.0];
set ksi     [expr $kip/pow($in,2)];  
set psi     [expr $lb/pow($in,2)];

###################
#### Conversion
###################

set mm	[expr $in/25.4] 
set m	[expr $mm*1000.]
set kN	[expr $kip/4.4482]
set N	[expr $kN/1000.]
