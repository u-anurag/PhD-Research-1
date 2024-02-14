###############################################################################
### Procedure to generate Pos-tensioned bar/strand elements in a ...		###
###  ... column  with a predefined set of main nodes.						###
###																			###
### Created By: Anurag Upadhyay												###
### 			PhD Candidate, University of Utah							###
### Date: 11-15-2018														###
###                     https://github.com/u-anurag                         ##
###############################################################################


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


# Define nodes involved in the column segment in a list "NodeList" before writing command for PT generation

# 05-06-2019 : Deleted nodeField and eleField for writing the node and celement data.

proc PTelements {NodeList pi PTnum PTdist PTArea PTBarPSMatFail ContactLat ContactRot} {

	set PTangle		[expr 2*$pi/$PTnum];
	set NumNodes	[llength $NodeList];
	#puts "NumNodes = $NumNodes"
	########### Create PT nodes and connections to the main nodes
	
	for {set j 0} {$j < $NumNodes } {incr j} {	;	# loop for node along the column
		puts "j = $j"
		set tempNode [lindex $NodeList $j] 
		set tempX [nodeCoord $tempNode 1] ;
		set tempY [nodeCoord $tempNode 2] ;
		set tempZ [nodeCoord $tempNode 3] ;
		
		
		for {set i 1} {$i <= $PTnum } {incr i} {		; # loop to generate PT connect nodes for each main node
		
			# PT slave nodes
			node [expr $tempNode*100+ $i]		[expr $tempX+ $PTdist*cos($PTangle*($i-0.5))]	[expr $tempY+ $PTdist*sin($PTangle*($i-0.5))]	$tempZ;
			#puts $fieldNodes   "[expr $tempNode*100+ $i]\t[expr $tempX+ $PTdist*cos($PTangle*($i-0.5))]\t[expr $tempY+ $PTdist*sin($PTangle*($i-0.5))]\t$tempZ ";
			
			# Connection from main column node to PT slave nodes
			if {$PTdist == 0} {				;  # if PT bar is at the column center
				if {$j == 0 || $j == $NumNodes-1} {			;	# Adding rigid link element for PT anchors (end nodes)
					element twoNodeLink			[expr $tempNode*100+ $i]  $tempNode  [expr $tempNode*100+ $i]  -mat  $ContactLat $ContactLat $ContactLat  $ContactLat $ContactLat $ContactLat -dir 1 2 3 4 5 6  -orient 1 0 0  0 1 0;
					#puts $filedElements	"twoNodeLink\t[expr $tempNode*100+ $i]\t$tempNode\t[expr $tempNode*100+ $i]"
				} else {
					element twoNodeLink			[expr $tempNode*100+ $i]  $tempNode  [expr $tempNode*100+ $i]  -mat  $ContactLat $ContactLat $ContactRot  $ContactRot $ContactRot $ContactRot -dir 1 2 3 4 5 6  -orient 1 0 0  0 1 0;
					#puts $filedElements	"twoNodeLink\t[expr $tempNode*100+ $i]\t$tempNode\t[expr $tempNode*100+ $i]"
				}
			} else {					;  # if PT bars are not at the column center
				if {$j == 0 || $j == $NumNodes-1} {			;	# Adding rigid elastic element for PT anchors (end nodes)
					element elasticBeamColumn	[expr $tempNode*100+ $i]  $tempNode  [expr $tempNode*100+ $i]    10.0e+10      500000.0 100000000.0    100000000.0		100000000.0	100000000.0		10; # GeoTransform is 10 (No variable)
					#puts $filedElements	"elasticBeamColumn\t[expr $tempNode*100+ $i]\t$tempNode\t[expr $tempNode*100+ $i]"
				} else {
					element twoNodeLink			[expr $tempNode*100+ $i]  $tempNode  [expr $tempNode*100+ $i]  -mat  $ContactLat $ContactLat $ContactRot  $ContactRot $ContactRot $ContactRot -dir 1 2 3 4 5 6  -orient 1 0 0  0 1 0;
					#puts $filedElements	"twoNodeLink\t[expr $tempNode*100+ $i]\t$tempNode\t[expr $tempNode*100+ $i]"
				}
			}
		}
	}
	
	unset i j tempNode; # Unset values 
	
	#puts "PT connection elements done"
	
	############ Assign PT elements

	for {set j 0} {$j < [expr $NumNodes-1] } {incr j} {					# loop for node
		# puts "NumNodes = $NumNodes"
		# puts "NodeList = $NodeList"
		# puts "j = $j"
		set tempNode1 [lindex $NodeList $j] ;				# First node
		set tempNode2 [lindex $NodeList [expr $j+1]];		# Second node
	
		for {set i 1} {$i <= $PTnum } {incr i } {

			element corotTruss  [expr $tempNode1*100 + 50+$i]  [expr $tempNode1*100+ $i]  [expr $tempNode2*100+ $i]   $PTArea $PTBarPSMatFail  ;
			#puts $filedElements	"corotTruss\t[expr $tempNode1*100 + 50+$i]\t[expr $tempNode1*100+ $i]\t[expr $tempNode2*100+ $i]"
			#puts "corotTruss\t[expr $tempNode1*100 + 50+$i]\t[expr $tempNode1*100+ $i]\t[expr $tempNode2*100+ $i]"
		}
	}
	#puts "PT corrotational elements done"

}

