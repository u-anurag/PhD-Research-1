###############################################################################
### Procedure to generate contact nodes and elements for ...				###
###  ... a predefined set of two main nodes.								###
###																			###																			##
### Created By: Anurag Upadhyay											     ##
### 			PhD Candidate, University of Utah							##
### Date: 11-03-2018														##
###                     https://github.com/u-anurag                         ##
##############################################################################

"""
Citation -


A. Upadhyay, C.P. Pantelides,
Fragility-informed seismic design of multi-column bridge bents with post-tensioned concrete columns for accelerated bridge construction,
Engineering Structures,
Volume 269,
2022,
114807,
ISSN 0141-0296,
https://doi.org/10.1016/j.engstruct.2022.114807.
(https://www.sciencedirect.com/science/article/pii/S0141029622008926)

"""

proc ContactSurf {Node1 Node2 Rcol pi nAreas RadFactorList ContactMatList ContactLat ContactRot ContactTen tempFileDir} {

	set tempX [nodeCoord $Node1 1] ;
	set tempY [nodeCoord $Node1 2] ;
	set tempZ [nodeCoord $Node1 3] ;
	
	###################################################################
	# Slave nodes for top of foundation ###############################
	
	set num 0 ; 
	#set RadFactorList {0.4 0.6 0.7 0.8 0.9 1.0} ;


	foreach RadFactor $RadFactorList {
		for {set theta 0} {$theta <= 15} {incr theta} {
		  set Angle  [expr $theta*22.5];
		  set number $num ;

		  node [expr ($Node1*1000)+$num+1]    [expr $tempX + $RadFactor*$Rcol*cos($pi*$Angle/180)]  	 [expr $tempY + $RadFactor*$Rcol*sin($pi*$Angle/180)]     $tempZ ;
		  node [expr ($Node2*1000)+$num+1]    [expr $tempX + $RadFactor*$Rcol*cos($pi*$Angle/180)]  	 [expr $tempY + $RadFactor*$Rcol*sin($pi*$Angle/180)]     $tempZ ;
		  
		  incr num  ;
		 }
		}
		

	puts "num = $num"
	
			
	# Number of Contact Elements to be defined
	set nContSet [expr $num/$nAreas] ;  # Number of contact elements in each circle
	
	#puts "nContSet = $nContSet"

	# Rigid elements connecting slave nodes to master nodes #############
	
	for {set i 0} {$i < $num} {incr i } {
		# element elasticBeamColumn     [expr ($Node1*1000)+$i+1]  $Node1  [expr ($Node1*1000)+$i+1]    25      10000  10000      10000  10000  10000   10; 
		# element elasticBeamColumn     [expr ($Node2*1000)+$i+1]  $Node2  [expr ($Node2*1000)+$i+1]    25      10000  10000      10000  10000  10000   10; 
		
		rigidLink beam     $Node1  [expr ($Node1*1000)+$i+1]
		rigidLink beam     $Node2  [expr ($Node2*1000)+$i+1]
		}
	#
	#puts "Rigid elements done"
	
	# Contact elements ###################################################
	
	for {set i 0} {$i < $num} {incr i } {
		set AreaNum  [expr ($i/$nContSet)+1];  # number tag for contact area/material defined for each set of perimeter

		# puts "AreaNum = $AreaNum"
		# set MatTemp [lindex $ContactMatList [expr ($AreaNum-1)]]
		# puts "MatTemp = $MatTemp"
		
		element twoNodeLink   [expr ($Node1*1000 + $Node2*100)+$i+1]  [expr ($Node1*1000)+$i+1]  [expr ($Node2*1000)+$i+1]  -mat [lindex $ContactMatList [expr ($AreaNum-1)]] $ContactLat  $ContactLat   $ContactRot $ContactRot $ContactRot  -dir 1 2 3  4 5 6 -orient 0 0 1    0 1 0;  # Contact Spring Vertical from 1 to 2
		#puts "ElementNo. = [expr ($Node1*1000 + $Node2*100)+$i+1] :: Material = [lindex $ContactMatList [expr ($AreaNum-1)]]"
		
		#recorder Element -file $dataDir/Contact[expr ($Node1*1000 + $Node2*100)+$i+1].out -ele	[expr ($Node1*1000 + $Node2*100)+$i+1]	deformationsANDforces ; # deformation  
		# field_MonitorEle
		puts $tempFileDir	"[expr ($Node1*1000 + $Node2*100)+$i+1]"
		}
	
	unset i ;
	
	#element twoNodeLink   [expr ($Node1*1000 + $Node2*1000)+100]  $Node1  $Node2  -mat $ContactTen $ContactLat  $ContactLat   $ContactRot $ContactRot $ContactRot  -dir 1 2 3  4 5 6 -orient 0 0 1    0 1 0;  # Contact Spring Vertical from 1 to 2

	#puts "Contact elements done"
	# close $field_MonitorEle
}