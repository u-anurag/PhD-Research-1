

 ###############################################################
 ########### Cyclic Analysis
 ###############################################################

set LColBase  		[expr 182.];  	# Base case Column clear height in basic units
set AspRBase		[expr $LColBase/44.] ; # Base case aspect ratio
set PTAreaBase     	[expr 1.58];  	# Base case PT bar area


# Set CPU Time calculation for analysis
 set startTime [clock clicks -milliseconds];	# Record Elapsed-Time (Debugging)

set CyclicCheckFile "CyclicAnalysis_Summary.out"

#Loop for Cyclic analyses
foreach Bridge {"B"} {  ; # "B" 
	foreach AspectRatio {4.13 5 5.5 6 6.5 7 7.5 8} {  ; # 4.13 5 5.5 6 6.5 7 7.5 8
		foreach PTratio {0.09 0.1027 0.11 0.12 0.1295} { ;  # 0.09 0.1027 0.11 0.12 0.1295
			for {set skew 0} {$skew <= 0} {incr skew} {
				
					set BridgeType $Bridge 
					set LCol [expr $LColBase*$AspectRatio/$AspRBase];
					set PTArea [expr $PTAreaBase*$PTratio/0.1027]
					set skewAngle	[expr $skew*15] ;	# degrees

					set dataDir Cyclic_Bridge_$BridgeType/$AspectRatio/$PTratio/$skewAngle;
					file mkdir $dataDir;
				
					# logFile $dataDir/logFile_Cyclic.txt;
					
					# set FinishTfile "$dataDir/FinishDrift.txt"
					# set field [open $FinishTfile "w"] ;
					
					source Bent_Model.tcl;   #   TwoSpan_Model_Cloud
					set field_Cyclic [open $CyclicCheckFile w+]
					
					puts "Running Cyclic analysis for Bridge $BridgeType AspRatio $AspectRatio PTratio $PTratio skewAngle $skewAngle"
					
					# Define RECORDERS -------------------------------------------------------------
					recorder Node -file $dataDir/DFree.out -node 43 -dof 1  disp;		# displacements of free node 5
					recorder Drift -file $dataDir/Drift.out -iNode 42 -jNode 43 -dof 1 -perpDirn 3;

					recorder Node -file $dataDir/ReactionsBent.out  -node 4100011 6100011 -dof 1 2 3 reaction;		# support reaction at column 1

					recorder Element -file $dataDir/ContactAll_Col4.out		-eleRange [expr (41*1000 + 42*100)+144+1] [expr (41*1000 + 42*100)+159+1] deformation;
					recorder Element -file $dataDir/ContactAll_Col6.out		-eleRange [expr (61*1000 + 62*100)+144+1] [expr (61*1000 + 62*100)+159+1] deformation;

					recorder Element -file $dataDir/ConcCol1y.out  -ele 42 section 1 fiber  [expr $RCol-$coverCol] 0		$CoreConcMat stressStrain; # y,z location of fiber
					recorder Element -file $dataDir/ConcCol1.out  -ele 42 section 1 fiber	0 [expr $RCol-$coverCol] 		$CoreConcMat stressStrain; # y,z location of fiber
					recorder Element -file $dataDir/ConcCol1Top.out  -ele 42 section $numIntgrPts fiber	0 [expr $RCol-$coverCol] 		$CoreConcMat stressStrain; # y,z location of fiber
					recorder Element -file $dataDir/ConcCol2.out  -ele 62 section 1 fiber	0 [expr $RCol-$coverCol] 		$CoreConcMat stressStrain; # y,z location of fiber

					recorder Element -file $dataDir/PTCol4Force.out -ele 4051 4251 4351  axialForce;
					recorder Element -file $dataDir/PTCol4Def.out   -ele 4051 4251 4351  deformations;
					recorder Element -file $dataDir/PTCol6Force.out -ele 6051 6251 6351  axialForce;
					recorder Element -file $dataDir/PTCol6Def.out   -ele 6051 6251 6351  deformations;

					# STATIC Cyclic ANALYSIS --------------------------------------------------------------------------------------------------
					#
					# we need to set up parameters that are particular to the model.

					set ControlNode 55;
					set ControlDOF  1;
					set Dincr  [expr 0.00005*$LCol];
					set algorithmType	Newton;  # Newton;

					# create load pattern for lateral Cyclic load
					set Hload [expr 10*$kip];				# define the lateral load as a proportion of the weight so that the pseudo time equals the lateral-load coefficient when using linear load pattern
					pattern Plain 200 Linear {   			# define load pattern -- generalized
						load $ControlNode $Hload 0.0 0.0 0.0 0.0 0.0;	# define lateral load in static lateral analysis # node#, FX FY MZ --
					}

					# 
					set maxNumIter		1000;
					set printFlag		0;
					
					set Tol 1.0e-5;			# convergence tolerance for test
					set LVALUE 30;
					constraints 	Transformation;     		# how it handles boundary conditions   ;   Plain	Transformation
					numberer 		RCM;			# renumber dof's to minimize band-width (optimization), if you want to;  Plain  RCM
					# system 			UmfPack  -lvalueFact $LVALUE;		# how to store and solve the system of equations in the analysis ->   UmfPack  -lvalueFact $LVALUE;    BandSPD 
					system			SparseSYM 
					test 			EnergyIncr  $Tol 1000 ;
					#test			NormDispIncr $Tol 6 
					algorithm	 	$algorithmType ;			# use Newton's solution algorithm: updates tangent stiffness at every iteration;  Broyden 8;  KrylovNewton  -maxDim 3;   Newton
					integrator 		DisplacementControl  $ControlNode   $ControlDOF $Dincr $maxNumIter; # 0.0001  0.01;	# use displacement-controlled analysis
					analysis 		Static;			# define type of analysis static or transient
					
					#####         /-- Cycle 1 --\ /-- Cycle 2 --\ for first step of the loading. 
					##### Cycle 1 = 0 in. -> +0.04 -> 2 in. -> -0.08 -> -2 in. -> +0.04 -> 0 in.
					##### at node 33,  Peak displacement  
					##### integrator DisplacementControl $nodeTag $ndf $Dincr
					 
					set Dincr [expr 0.0005*$LCol]   ; # 0.00005*$LCol = 0.2311 mm						 
					 
					foreach driftPeak {0.1 0.2 0.3 0.5 0.75 1.0 1.5 2.0 2.5 3.0 4.0} { ; # 0.25 0.5 0.75  3.0  ;  1% =  mm
						foreach Dmax "$driftPeak -$driftPeak -$driftPeak $driftPeak" {
							integrator DisplacementControl $ControlNode   $ControlDOF [expr $Dincr*$Dmax/$driftPeak]
							set ok [analyze [expr round(0.01*$driftPeak*$LCol/$Dincr)]]
							source SolverAlgorithms.tcl;
						}
					}
					
					set currentDisp [nodeDisp $ControlNode $ControlDOF ]
					
					if {$ok != 0 } {
						puts " Could not converge at drift [expr $currentDisp*100/$LCol] %"
						puts $field_Cyclic	"Bridge $BridgeType AspRatio $AspectRatio PTratio $PTratio skewAngle $skewAngle: \t Fail \t during driftPeak $driftPeak at:  drift [expr $currentDisp*100/$LCol] %"
						}
							  
					if {$ok == 0 } {
						puts " Analysis converged at drift [expr $currentDisp*100/$LCol] %"
						puts $field_Cyclic	"Bridge $BridgeType AspRatio $AspectRatio PTratio $PTratio skewAngle $skewAngle: \t PASS \t during driftPeak $driftPeak :  drift [expr $currentDisp*100/$LCol] %"
						}
					#puts "Cyclic analysis is done"
					close $field_Cyclic

					#puts $field  "[expr $currentDisp*100/$LCol]"

				}
			}
		}
	}