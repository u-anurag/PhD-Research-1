###############################################################################
### Procedure to generate the vertical load generated by the ...			###
###  ... Pos-tensioned bar/strand elements at the top anchorage nodes ...	###
###  ... for a predefined list of the main nodes of column top.				###					
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

## Assign gravity load

## Define a list of column MAIN nodes of PT anchors at the top of the column/cap beams..
## .. in PTloadNodeList

proc PTload {PTloadNodeList pi PTnum PTArea prestress} {

	foreach topNode $PTloadNodeList {
		for {set i 1} {$i <= $PTnum} {incr i} {
			load [expr $topNode*100 +$i]   0 0 [expr -$PTArea*$prestress] 0 0 0;
			#puts "load [expr $topNode*100 +$i]   0 0 [expr -$PTArea*$prestress] 0 0 0;"
		}
	}
}

