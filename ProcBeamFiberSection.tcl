##########################################################################################
## This code is a part of Anurag Upadhyay's Ph.D. research work.                        ##
##																						##
##																						##
### Created By: Anurag Upadhyay											            	##
### 			PhD Candidate, University of Utah										##
### Date: 11-03-2018																	##
###                     https://github.com/u-anurag                         			##
##########################################################################################

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
# FIBER SECTION properties -------------------------------------------------------------
# symmetric section  (section orientation 'plain transformation' keeping local and global Z same)
#                       ^
#                      /|\   local z axis
#                       |
#                       |  
#             |-------- B --------|
#             ---------------------   --
#             |  o   o     o   o  |     | -- cover
#             |                   |     |            # calculate stress-strain in an element at +-coreZ for push in global x direction
#             |                   |     |
#             |  o             o  |     |
#             |         +         |     H _______________\  local y axis
#             |                   |     |                /
#             |  o             o  |     |
#             |                   |     |
#             |                   |     |
#             |  o      o      o  |     |    
#             |  o o o  o  o o o  |     |-- cover
#             ---------------------    --
#                       

# define section tags beforehand in the main file.

proc BeamFiberSection {BeamSecTag CoreConcMat CoverConcMat ReinfMat HBeam BBeam BeamConcCover numBarsTop numBarsBot barAreaBeam IDTorsionBeam} {
# RC section  
   set coverBY [expr $BBeam/2.0];	# The distance from the section z-axis to the side edge of the beam 
   set coverBZ [expr $HBeam/2.0];	# The distance from the section y-axis to the top edge of the beam 
   set coreBY [expr $coverBY-$BeamConcCover] ;
   set coreBZ [expr $coverBZ-$BeamConcCover] ;
   set nfBY 10;			# number of fibers for concrete in y-direction
   set nfBZ 10;			# number of fibers for concrete in z-direction
   
   # Using only one section throughout the beam
    section Fiber  $BeamSecTag  -GJ $IDTorsionBeam  {;	# Define the fiber section
	# Define the rect concrete patch, bottom left first -- top right corner second 
	patch rect		$CoreConcMat	$nfBY $nfBZ		-$coreBY  -$coreBZ      $coreBY   $coreBZ ;		# Core section patch
	patch rect		$CoverConcMat	$nfBY 3			-$coverBY -$coverBZ     $coverBY -$coreBZ ;		# Bottom cover patch
	patch rect		$CoverConcMat	$nfBY 3			-$coverBY  $coreBZ      $coverBY  $coverBZ ;	# Top cover patch
	patch rect		$CoverConcMat	3	  $nfBZ		-$coverBY -$coreBZ     -$coreBY   $coreBZ ;		# Left cover patch
	patch rect		$CoverConcMat	3	  $nfBZ		 $coreBY  -$coreBZ      $coverBY  $coreBZ ;		# Right cover patch
	
	layer straight	$ReinfMat	$numBarsBot	$barAreaBeam   -$coreBY -$coreBZ     $coreBY -$coreBZ;	# Bottom layer reinfocement 
	layer straight	$ReinfMat	$numBarsTop $barAreaBeam   -$coreBY  $coreBZ     $coreBY  $coreBZ;	# Top layer reinforcement 
	layer straight	$ReinfMat	3			$barAreaBeam	-$coreBY [expr ($coreBZ-2*$BeamConcCover)]  -$coreBY [expr -($coreBZ-2*$BeamConcCover)] ;	# Left layer reinforcement
	layer straight	$ReinfMat	3			$barAreaBeam	 $coreBY [expr ($coreBZ-2*$BeamConcCover)]   $coreBY [expr -($coreBZ-2*$BeamConcCover)] ;	# Right layer reinforcement in original
    } ;	# end of fibersection definition
}
