###############################################################################
### Create material for contact surface bed                                 ###
###																			###
### Created By: Anurag Upadhyay												###
### 			PhD Candidate, University of Utah							###
### Date: 11-03-2018														###
###                     https://github.com/u-anurag                         ###
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

	set RadFactorList {0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0} ;		# Define RadFactorList before calling the procedure.  0.4 0.6 0.7 0.8 0.9 1.0
	set ContactMatList { } ;							# Define an empty list for contact materials

	# Define some material tags
	set ContactLat 		20;
	set ContactRot 		21;
	set ContactTen 		22;
	
	# ### Area for contact element
	set nAreas [llength $RadFactorList]

	for {set n 0} {$n < $nAreas} {incr n} {
		if {$n == 0} {
			set R1 0;
		}
		if {$n > 0} {
			set R1 [lindex $RadFactorList $n-1];
		}

		set R2 [lindex $RadFactorList $n] ;
		set ContactArea([expr $n+1]) [expr $ACol*($R2**2 - $R1**2)/16] ;  # Contact area of each element

		# puts "ContactArea([expr $n+1])    $ContactArea([expr $n+1])"

		}

	puts "nAreas $nAreas"
	
	##### Contact Element Material #############################################

	set E  		[expr  4000.*$kip/$in] ;

	uniaxialMaterial Elastic 		$ContactLat   $E   0.0  $E ;
	uniaxialMaterial Elastic 		$ContactRot   [expr 0.00000001*$E]   0.0  [expr 0.00000001*$E] ;
	uniaxialMaterial Elastic 		$ContactTen   [expr 0.005*$E]   0.0  [expr 0.005*$E] ;

	for {set i 1} {$i <= $nAreas} {incr i} {  ; # Generate material for contact elements
		
		set KcompSp($i) 	[expr 0.9*$ContactArea($i)*$Ec/(0.25*$DCol)] ;  # Contact area of each element  0.5*0.7*
		puts "contact stiffness is = $KcompSp($i)"
		set FycompSp($i) 	[expr -$ContactArea($i)*$fc];
		set Eneg($i)  	[expr 0.0005*$E] ; #[expr 0.001*$KcompSp($i)];			# 0.004502 works good.
		set gap 		[expr -0.0001*$in];
		set eta   		0.005 ;
				
		####### Define material tags
		set ContactGap($i)		[expr 100+$i];
		set ContactE($i)		[expr 110+$i];
		set ContactMat($i)		[expr 120+$i];
		
		####### Define material 
		uniaxialMaterial ElasticPPGap 	$ContactGap($i)   	$KcompSp($i) $FycompSp($i) $gap  $eta ; 
		uniaxialMaterial Elastic 		$ContactE($i)   	$Eneg($i)   0.0  $Eneg($i) ;
		uniaxialMaterial Parallel   	$ContactMat($i)   	$ContactGap($i)  $ContactE($i) ;
		
		# puts "KcompSp($i) 	$KcompSp($i)"
		# puts "FycompSp($i) 	$FycompSp($i)"
		
		set ContactMatList [concat $ContactMatList $ContactMat($i)]
	
		}
	unset i ;
	
	## Set geometric transformation
	geomTransf  Linear 10  0 0 1;
	
puts "Contact Material Done"
