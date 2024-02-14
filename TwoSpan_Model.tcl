##########################################################################################
## This code is a part of Anurag Upadhyay's Ph.D. research work.                        ##
##																						##
## This file calls other helper files to set up the OpenSees model						##
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


# Set CPU Time calculation for analysis
 # set startTime [clock clicks -milliseconds];	# Record Elapsed-Time (Debugging)

wipe all;

model BasicBuilder -ndm 3 -ndf 6;		# Define the model builder, ndm=#dimension, ndf=#dofs

logFile logFile.txt;

#set BridgeType B ; # A - Riverdale    B - Alternative
set SSI Yes;
set BRB No;
#set skewAngle 0 ;

# set ModalAnalysis   Yes;
set SteelType ReinforcingSteel;
set AnalysisType  Gravity;  # Dynamic , Pushover , Gravity, Cyclic
# set dataDir Temp

if {$AnalysisType == "Cyclic"} {
	set dataDir	Cyclic_Bridge_$BridgeType
	file mkdir $dataDir;
	}

source Units&Constants.tcl ;


######################################################
###### Define Geometry (INPUT)    ####################
######################################################

#####################################################
########## Riverdale Dimensions #####################
#####################################################
set a_Col  		[expr 17.4*$in];  	# One side of octagon
#set LCol  		[expr 182*$in];  	# Column clear height
set s_bar   	[expr 0.60*$in];  		# Spacing of confinment reinforcement
set Dbar   		[expr 0.875*$in]; 		# Diameter of Main Rebar - 0.750 for #6;  0.875 for #7;  1.00 for #8
set Abar   		[expr 0.60*$in*$in]; 	# Area of Main Rebar - 0.44 for #6;  0.60 for #7;  0.79 for #8
set coverCol   	[expr 2.0*$in]; 		# Clear cover of column

set Hpilecap	[expr 48.0*$in];

set Lp_col 		[expr 0.10*$LCol];  			# Length of plastic hinge

# Bent dimensions
#set LCol [expr 182.*$in];   # 
set LBeam [expr 0.5*24.5*$ft];   # 24.5 feet  *** IMP: Since the code generates a middle node in the beam, use half of the actual beam length
set DeckWidth [expr $LBeam + 2*96.*$in];  # Width of deck - for outer nodes of the deck;  18.9

# Column section

set HCol [expr 42.0*$in]; 		# Column Depth (36 in.)
set BCol [expr 42.0*$in];		# Column Width  (36 in.)
#set coverCol [expr 0.090*$m];			# Column cover to reinforcing steel NA. (3.5 original)

set s_bar   	[expr 0.60*$in];  		# Spacing of confinment reinforcement
set Dbar   		[expr 0.875*$in]; 		# Diameter of Main Rebar - 0.750 for #6;  0.875 for #7;  1.00 for #8
set Abar   		[expr 0.60*$in*$in]; 	# Area of Main Rebar - 0.44 for #6;  0.60 for #7;  0.79 for #8

set RCol	[expr 0.5*$HCol];
#set RCol 	[expr 0.4*(1.306*$a_Col + 0.5*$HCol)];  			# Equivalent radius of the column
set DCol	[expr 2.00*$RCol];  				# Equivalent diameter of the column

puts "RCol = $RCol"

#puts "Exiting in line 62"
#exit 

# Beam section
# ### Beam Parameters  ############################
set HBeam  [expr 4.0*$ft];     # Beam Depth (48 in.)
set BBeam  [expr 4.0*$ft];		# Beam width 48 in.
set coverBeam [expr 2.0*$in];	
set barAreaBeam [expr 1.0*$in*$in] ;		# area of longitudinal-reinforcement bars  (square mm)

# Footing Dimensions
# Grade Beam Section
set HGBeam	[expr 6*0.46*$ft];
set BGBeam	[expr 3*1.68*$ft];


# ### Post tensioning Strands  ####################
set PTnum		6;
set PTdist		[expr 1.0*14.*$in];
set PTdia  		[expr 1.125*$in];  		# Diameter of PT strands each
set prestress 	[expr 90*$ksi];   		# 133 ksi = 919 MPa ; 123 ksi = 850 MPa
#set PTArea     	[expr 1.58*$in*$in];  	# All three strands

# Super structure weight

set Wdeck		[expr 2*213*$kip];

 ###############################################
 ###### Calculated Parameters ##################
 ###############################################
 
set Lrigid		[expr 0.5*$HBeam];		# Distance from cap beam bottom to cap beam middle
set Lloading	[expr $LCol+$Lrigid];	# Location of beam integration point. Mid height of the cap beam
set LTotal		[expr $LCol+$HBeam];		# Total height of the bent. Also serves as the top anchorage of PT bars
set ACol		[expr $pi*$RCol*$RCol];		# Column cross-section area

set ICol [expr 1./12.*$BCol*pow($HCol,3.)]; 	   			 # Column moment of inertia "m^4"
set JCol [expr ($BCol*$HCol/12.)*($BCol**2. + $HCol**2.)];   # Shear modulus of the column section "m^3"


set ABeam [expr $BBeam*$HBeam];					# cross-sectional area "m^2"
set I3Beam [expr 1./12.*$BBeam*pow($HBeam,3.)]; 	    # Column moment of inertia "m^4"
set I2Beam [expr 1./12.*$HBeam*pow($BBeam,3.)]; 	    # Column moment of inertia "m^4"
set JBeam [expr ($BBeam*$HBeam/12.)*($BBeam**2. + $HBeam**2.)];   # Shear modulus of the beam section "m^3"

set Arigid [expr 100.*$BBeam*$HBeam];					# cross-sectional area "m^2"
set Irigid [expr 10000./12.*$BBeam*pow($HBeam,3.)]; 	    # Column moment of inertia "m^4"
set Jrigid [expr 100000.*($BBeam*$HBeam/12.)*($BBeam**2. + $HBeam**2.)];   # Shear modulus of the beam section "m^3"

set AGBeam [expr $BGBeam*$HGBeam];					# cross-sectional area "m^2"
set IGBeam [expr 1./12.*$BGBeam*pow($HGBeam,3.)]; 	    # Column moment of inertia "m^4"
set JGBeam [expr ($BGBeam*$HGBeam/12.)*($BGBeam**2. + $HGBeam**2.)];   # Shear modulus of the beam section "m^3"
set BaseAreaGB [expr $BGBeam*($LBeam - 2.2*$m)];

 #### Material Input
source Material.tcl;
source MaterialSoil_Elastic.tcl;

# Calculate Coordinates
source Coordinates_Skew.tcl;

####################################################
######## Assign Nodes 
####################################################


 ##### Abutment A (Span 2 start)

node 10000 $Xspan2_1   $Yspan2_1   $Lloading;				# Changed from LTotal to Lloading on 06/22/2020
node 10001 $Xspan2_1_in    $Yspan2_1_in    $Lloading;
node 10002 $Xspan2_1_out   $Yspan2_1_out   $Lloading;

 # Nodes for abutment A soil
 if {$SSI == "Yes"} {
	node 10010 $Xspan2_1   $Yspan2_1   $Lloading;
	node 10011 $Xspan2_1_in    $Yspan2_1_in    $Lloading;
	node 10012 $Xspan2_1_out   $Yspan2_1_out   $Lloading;
	 }
	 ##### Abutment B (Span 3 end)

node 20000  $Xspan3_6   $Yspan3_6   $Lloading;
node 20001 $Xspan3_6_in    $Yspan3_6_in    $Lloading;
node 20002 $Xspan3_6_out   $Yspan3_6_out   $Lloading;

if {$SSI == "Yes"} {
	node 20010  $Xspan3_6   $Yspan3_6   $Lloading;
	node 20011 $Xspan3_6_in    $Yspan3_6_in    $Lloading;
	node 20012 $Xspan3_6_out   $Yspan3_6_out   $Lloading;
	}

# Nodes Bent 2

node 40   $X2_in   $Y2_in   -$Hpilecap;
node 41   $X2_in   $Y2_in   0;
node 42   $X2_in   $Y2_in   [expr 0.0*$LCol]; 
node 43   $X2_in   $Y2_in   [expr 1.00*$LCol]; 
node 44   $X2_in   $Y2_in   [expr 1.00*$LCol]; 
node 45   $X2_in   $Y2_in   [expr 1.00*$Lloading]; 
node 46   $X2_inCant   $Y2_inCant    [expr 1.00*$Lloading];	# Internal cantilever node
node 47   $X2_in   $Y2_in   [expr 1.00*$LTotal]; # Top Anchorage node

node 55   $X2_mid  $Y2_mid    [expr 1.00*$Lloading];

node 60   $X2_out   $Y2_out   -$Hpilecap;
node 61   $X2_out   $Y2_out   0;
node 62   $X2_out   $Y2_out   [expr 0.0*$LCol];
node 63   $X2_out   $Y2_out   [expr 1.00*$LCol];
node 64   $X2_out   $Y2_out   [expr 1.00*$LCol];
node 65   $X2_out   $Y2_out   [expr 1.00*$Lloading];
node 66   $X2_outCant   $Y2_outCant     [expr 1.00*$Lloading];
node 67   $X2_out   $Y2_out      [expr 1.00*$LTotal];

 ###############################
 ##### Deck nodes
node 111001 $Xspan2_1_in    $Yspan2_1_in    $ZDeck;
node 111002 $Xspan2_1_out   $Yspan2_1_out   $ZDeck;
node 111  $Xspan2_1   $Yspan2_1   $ZDeck;
node 112  $Xspan2_2   $Yspan2_2   $ZDeck;
node 113  $Xspan2_3   $Yspan2_3   $ZDeck;
node 114  $Xspan2_4   $Yspan2_4   $ZDeck;
node 115  $Xspan2_5   $Yspan2_5   $ZDeck;
node 116  $Xspan2_6   $Yspan2_6   $ZDeck;
node 116001 $Xspan2_6_in    $Yspan2_6_in    $ZDeck;
node 116002 $Xspan2_6_out   $Yspan2_6_out   $ZDeck;

node 122  $Xspan3_2   $Yspan3_2   $ZDeck;
node 123  $Xspan3_3   $Yspan3_3   $ZDeck;
node 124  $Xspan3_4   $Yspan3_4   $ZDeck;
node 125  $Xspan3_5   $Yspan3_5   $ZDeck;
node 126  $Xspan3_6   $Yspan3_6   $ZDeck;
node 126001 $Xspan3_6_in    $Yspan3_6_in    $ZDeck;
node 126002 $Xspan3_6_out   $Yspan3_6_out   $ZDeck;


source ProcColFiberSection.tcl;
source ProcBeamFiberSection.tcl;

set ColSecTag	1;
set BeamSecTag	2;

# Command :: ColCircularSection ColSecTag CoreConcMat CoverConcMat ReinfMat ColDia cover numBarCol barArea barDia
# Command :: BeamFiberSection   BeamSecTag CoreConcMat CoverConcMat ReinfMat HBeam BBeam BeamConcCover numBarsTop numBarsBot barAreaBeam

ColCircularSection	$ColSecTag $CoreConcMat $CoverConcMat $IDreinf $DCol $coverCol 12  $Abar $Dbar $IDTorsionCol
BeamFiberSection	$BeamSecTag $CoreConcMat $CoverConcMat $IDreinf $HBeam $BBeam $coverBeam 20 20 $barAreaBeam $IDTorsionBeam


set SecAggCol	21;	
set SecAggBeam  22;

# section Aggregator for column to include shear
section Aggregator $SecAggCol	$IDShearCol Vy	$IDShearCol Vz	$IDTorsionCol T		-section $ColSecTag;
section Aggregator $SecAggBeam	$IDShearBeam Vy	$IDShearBeam Vz	$IDTorsionBeam T	-section $BeamSecTag;

# element connectivity:
set numIntgrPts 3;								# number of integration points for force-based element
set numIntgrPtsBeam 2;

 ######################
 ####### BENT 2 #######
 ######################
# Non-linear beam-column elements for Columns
element elasticBeamColumn	40 40 41 $Arigid $Ec $Gc $Jrigid $Irigid $Irigid $PileTransfTag;
element nonlinearBeamColumn	42 42 43 $numIntgrPts $SecAggCol $ColBent2TransfTag;
element elasticBeamColumn	44 44 45 $Arigid $Ec $Gc $Jrigid $Irigid $Irigid $PileTransfTag;
#element elasticBeamColumn	45 45 46 $Arigid $Ec $Gc $Jrigid $Irigid $Irigid $BeamTransfTag;
element elasticBeamColumn	45 45 46 $ABeam $Ec $Gc $JBeam $I3Beam $I2Beam $BeamTransfTag;
element elasticBeamColumn	46 45 47 $Arigid $Ec $Gc $Jrigid $Irigid $Irigid $PileTransfTag;

element elasticBeamColumn	60 60 61 $Arigid $Ec $Gc $Jrigid $Irigid $Irigid $PileTransfTag;
element nonlinearBeamColumn	62 62 63 $numIntgrPts $SecAggCol $ColBent2TransfTag;
element elasticBeamColumn	64 64 65 $Arigid $Ec $Gc $Jrigid $Irigid $Irigid $PileTransfTag;
#element elasticBeamColumn	65 65 66 $Arigid $Ec $Gc $Jrigid $Irigid $Irigid $BeamTransfTag;
element elasticBeamColumn	65 65 66 $ABeam $Ec $Gc $JBeam $I3Beam $I2Beam $BeamTransfTag;
element elasticBeamColumn	66 65 67 $Arigid $Ec $Gc $Jrigid $Irigid $Irigid $PileTransfTag;


# Beams
element nonlinearBeamColumn 47 45 55 $numIntgrPtsBeam $SecAggBeam $BeamTransfTag;
element nonlinearBeamColumn 57 55 65 $numIntgrPtsBeam $SecAggBeam $BeamTransfTag;
# element elasticBeamColumn	47 45 55 $ABeam $Ec $Gc $JBeam $I3Beam $I2Beam $BeamTransfTag;
# element elasticBeamColumn	57 55 65 $ABeam $Ec $Gc $JBeam $I3Beam $I2Beam $BeamTransfTag;

#######################  Rocking Plane
source GenContactMaterial.tcl

# source ProcContactSurf.tcl
source ProcContactSurf_2.tcl

ContactSurf 41 42 $RCol $pi $nAreas $RadFactorList $ContactMatList $ContactLat $ContactRot $ContactTen $field_MonitorEle
ContactSurf 43 44 $RCol $pi $nAreas $RadFactorList $ContactMatList $ContactLat $ContactRot $ContactTen $field_MonitorEle

ContactSurf 61 62 $RCol $pi $nAreas $RadFactorList $ContactMatList $ContactLat $ContactRot $ContactTen $field_MonitorEle
ContactSurf 63 64 $RCol $pi $nAreas $RadFactorList $ContactMatList $ContactLat $ContactRot $ContactTen $field_MonitorEle

#################
## PT BARS
#################

source ProcPTelements.tcl ;

# Add foundation node for bottom anchorage of PT bars
PTelements "40 42 43 47" $pi $PTnum $PTdist $PTArea $PTBarPSMatFail $ContactLat $ContactRot
PTelements "60 62 63 67" $pi $PTnum $PTdist $PTArea $PTBarPSMatFail $ContactLat $ContactRot


# Abutments

element elasticBeamColumn 10001 10001 10000 [expr 10000*$ACol] $Ec $Gc [expr 100000*$JCol] [expr 100000*$I3Beam] [expr 100000*$I2Beam] 4;	# abut-1=100000xCapbeam
element elasticBeamColumn 10002 10000 10002 [expr 10000*$ACol] $Ec $Gc [expr 100000*$JCol] [expr 100000*$I3Beam] [expr 100000*$I2Beam] 4;	# abut-1=100000xCapbeam

element elasticBeamColumn 20001 20001 20000 [expr 10000*$ACol] $Ec $Gc [expr 100000*$JCol] [expr 100000*$I3Beam] [expr 100000*$I2Beam] 4;	# abut-1=100000xCapbeam
element elasticBeamColumn 20002 20000 20002 [expr 10000*$ACol] $Ec $Gc [expr 100000*$JCol] [expr 100000*$I3Beam] [expr 100000*$I2Beam] 4;	# abut-1=100000xCapbeam


#  DECK Elements ##############################################

# I - Girder Properties 

set Agirder    [expr  135.*($in**2)];
set I2girder   [expr  31100.*($in**4)];   # 31100 in.^4     0.0129 m^4
set I3girder   [expr  1200.*($in**4)];   # 1200 in.^4      5.0e-4 m^4
set Jgirder    [expr  1000.*($in**2)];

# Concrete deck properties
set Adeck      [expr  10.*$Agirder];
set I2deck     [expr  5.*$I2girder];
# set I3deck     [expr  97.2*($m**4)]; # Cracked section - 25%   0.25*37.5
#set I3deck     [expr  100.*$I3girder];  # 97.2 m^4    100.*$I3girder
set I3deck     [expr  6.*$I3girder];  # 6.*$I3girder; Largely ignoring deck stiffness due to cracks.  Added 06-22-2020
set Jdeck      [expr  5.*$Jgirder];	# 90 m^4

# Superstructure properties - Combination of Deck and I-Girders
set Asuperstructure      [expr  300*$in*$in];
set I2superstructure     [expr  8*$I2girder + $I2deck];
set I3superstructure     [expr  0.35*(8*$I3girder + $I3deck)];
set Jsuperstructure      [expr  180*1.500*($in**4)];

######### Deck

element elasticBeamColumn 111   111  112   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;
element elasticBeamColumn 112   112  113   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;
element elasticBeamColumn 113   113  114   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;
element elasticBeamColumn 114   114  115   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;
element elasticBeamColumn 115   115  116   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;

# Since node 121 does not exist now.
element elasticBeamColumn 121   116  122   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;
element elasticBeamColumn 122   122  123   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;
element elasticBeamColumn 123   123  124   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;
element elasticBeamColumn 124   124  125   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;
element elasticBeamColumn 125   125  126   $Asuperstructure  $Es  $Gs    $Jsuperstructure  $I2superstructure  $I3superstructure     $DeckTransfTag;

# #
# #End segments for each span
for {set j 1} {$j <= 2} {incr j} {
	element elasticBeamColumn [expr (111)*1000+$j]   [expr 111] [expr (111)*1000+$j]   $Agirder  $Es  $Gs    $Jgirder  $I2girder  $I3girder     $DeckTransfTag;
	element elasticBeamColumn [expr (116)*1000+$j]   [expr 116] [expr (116)*1000+$j]   $Agirder  $Es  $Gs    $Jgirder  $I2girder  $I3girder     $DeckTransfTag;
	element elasticBeamColumn [expr (126)*1000+$j]   [expr 126] [expr (126)*1000+$j]   $Agirder  $Es  $Gs    $Jgirder  $I2girder  $I3girder     $DeckTransfTag;
	# element truss $eleTag $iNode $jNode $A $matTag
	}

#
# Bearing Elements ################################################
# BridgeType A is the existing Riverdale bridge. Isolation bearings at the bent and integral abutments.
# BridgeType B is the alternative design with fixed bearings at the bent and expansion bearings at the abutments.

if {$BridgeType == "A"} {
	element	twoNodeLink	201	10001	111001	   	-mat	$MatBearingVert	$MatBearingVert  $MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutAAng)]	[expr	sin($AbutAAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	202	10000	111	   		-mat	$MatBearingVert	$MatBearingVert  $MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutAAng)]	[expr	sin($AbutAAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	203	10002	111002	  	-mat	$MatBearingVert	$MatBearingVert  $MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutAAng)]	[expr	sin($AbutAAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2

	element	twoNodeLink	210	46	116001	   	-mat	$MatBearingVert	$MatBearingLong	$MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($Bent2Ang)]	[expr	sin($Bent2Ang)]	0	-pDelta 0.1 0.1 0.1 0.1  -shearDist 0.6 0.6;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	211	55	116	   		-mat	$MatBearingVert	$MatBearingLong	$MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($Bent2Ang)]	[expr	sin($Bent2Ang)]	0	-pDelta 0.1 0.1 0.1 0.1  -shearDist 0.6 0.6;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	212	66	116002	   	-mat	$MatBearingVert	$MatBearingLong	$MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($Bent2Ang)]	[expr	sin($Bent2Ang)]	0	-pDelta 0.1 0.1 0.1 0.1  -shearDist 0.6 0.6;	#	Contact	Spring	Vertical	from	1	to	2


	element	twoNodeLink	222	20001	126001	   	-mat	$MatBearingVert	$MatBearingVert  $MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutBAng)]	[expr	sin($AbutBAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	223	20000	126	  		-mat	$MatBearingVert	$MatBearingVert  $MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutBAng)]	[expr	sin($AbutBAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	224	20002	126002	   	-mat	$MatBearingVert	$MatBearingVert  $MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutBAng)]	[expr	sin($AbutBAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2

	}

if {$BridgeType == "B"} {
	element	twoNodeLink	201	10001	111001	   	-mat	$MatBearingVert	$MatBearingLat  $MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutAAng)]	[expr	sin($AbutAAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	202	10000	111	   		-mat	$MatBearingVert	$MatBearingLat  $MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutAAng)]	[expr	sin($AbutAAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	203	10002	111002	  	-mat	$MatBearingVert	$MatBearingLat  $MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutAAng)]	[expr	sin($AbutAAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2

	element	twoNodeLink	210	46	116001	   	-mat	$MatBearingVert	$MatBearingVert	$MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($Bent2Ang)]	[expr	sin($Bent2Ang)]	0	; # -pDelta 0.1 0.1 0.1 0.1  -shearDist 0.6 0.6;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	211	55	116	   		-mat	$MatBearingVert	$MatBearingVert	$MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($Bent2Ang)]	[expr	sin($Bent2Ang)]	0	; # -pDelta 0.1 0.1 0.1 0.1  -shearDist 0.6 0.6;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	212	66	116002	   	-mat	$MatBearingVert	$MatBearingVert	$MatBearingVert	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($Bent2Ang)]	[expr	sin($Bent2Ang)]	0	; # -pDelta 0.1 0.1 0.1 0.1  -shearDist 0.6 0.6;	#	Contact	Spring	Vertical	from	1	to	2


	element	twoNodeLink	222	20001	126001	   	-mat	$MatBearingVert	$MatBearingLat  $MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutBAng)]	[expr	sin($AbutBAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	223	20000	126	  		-mat	$MatBearingVert	$MatBearingLat  $MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutBAng)]	[expr	sin($AbutBAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2
	element	twoNodeLink	224	20002	126002	   	-mat	$MatBearingVert	$MatBearingLat  $MatBearingLong	$MatBearingRotZ	$MatBearingRotX	$MatBearingRotY	   -dir	1	2	3	4	5	6	   -orient	0	0	1	[expr	cos($AbutBAng)]	[expr	sin($AbutBAng)]	0;	#	Contact	Spring	Vertical	from	1	to	2

	# Pounding Elements ####################

	element	twoNodeLink	501	10001	111001	   	   -mat	$MatPounding	   -dir	1		   -orient		$xV2_AbutA	$yV2_AbutA  $zV2_AbutA		$xV1 $yV1 $zV1 ;
	element	twoNodeLink	502	10000	111	   	   	   -mat	$MatPounding	   -dir	1		   -orient		$xV2_AbutA	$yV2_AbutA  $zV2_AbutA		$xV1 $yV1 $zV1 ;
	element	twoNodeLink	503	10002	111002	  	   -mat	$MatPounding	   -dir	1		   -orient		$xV2_AbutA	$yV2_AbutA  $zV2_AbutA		$xV1 $yV1 $zV1 ;

	element	twoNodeLink	513	20001	126001	   	   -mat	$MatPounding	   -dir	1		   -orient		$xV2_AbutB	$yV2_AbutB  $zV2_AbutB		$xV1 $yV1 $zV1 ;
	element	twoNodeLink	514	20000	126	  	       -mat	$MatPounding	   -dir	1		   -orient		$xV2_AbutB	$yV2_AbutB  $zV2_AbutB		$xV1 $yV1 $zV1 ;
	element	twoNodeLink	515	20002	126002	   	   -mat	$MatPounding	   -dir	1		   -orient		$xV2_AbutB	$yV2_AbutB  $zV2_AbutB		$xV1 $yV1 $zV1 ;
	}


if {$SSI == "Yes"} {
	 ##############################
	 ### Soil springs for Abutments
	 ##############################

	element twoNodeLink		10010 10010 10000  -mat	502	501	503 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutA	$yV2_AbutA $zV2_AbutA;
	element twoNodeLink		10011 10011 10001  -mat	502	501	503 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutA	$yV2_AbutA $zV2_AbutA;
	element twoNodeLink		10012 10012 10002  -mat	502	501	503 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutA	$yV2_AbutA $zV2_AbutA;

	element twoNodeLink		20010 20010 20000  -mat	502	501	503 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutB	$yV2_AbutB $zV2_AbutB;
	element twoNodeLink		20011 20011 20001  -mat	502	501	503 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutB	$yV2_AbutB $zV2_AbutB;
	element twoNodeLink		20012 20012 20002  -mat	502	501	503 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutB	$yV2_AbutB $zV2_AbutB;


	###########################
	## Soil Springs for PC
	###########################

	node 4100011   $X2_in   $Y2_in   -$Hpilecap;
	# node 5100011   $X2_mid  $Y2_mid    0;
	node 6100011   $X2_out   $Y2_out   -$Hpilecap;

	element twoNodeLink		4100011 40 4100011  -mat	200	200	300 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutA	$yV2_AbutA $zV2_AbutA;
	#element twoNodeLink		5100011 51 5100011  -mat	200	200	300 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutA	$yV2_AbutA $zV2_AbutA;
	element twoNodeLink		6100011 60 6100011  -mat	200	200	300 	300 300 300 -dir	1 2	3	4 5 6  -orient $xV1	$yV1 $zV1    $xV2_AbutA	$yV2_AbutA $zV2_AbutA;

	}

############################################
####### Mass Assignment 
############################################

 set massCol		[expr (0.5*$mconc*$ACol*$LCol)];
 set massBeamOut	[expr (0.5*$mconc*$ABeam*$LBeam)]; 
 set massBeamMid	[expr (1.0*$mconc*$ABeam*$LBeam)]; 
 set massRot		[expr 10e-6];
 
set MassDeck      [expr $Wdeck/($g*6)];    # Mass Per node   (N - s2/m)
set MassDeckEnd   [expr 0.01*$MassDeck/3];      # Mass at each end node
set MassDeckRot   [expr 10e-6];

 
 ##########
 # Mass assignment for Bent 2
 
 mass 42 $massCol  $massCol  $massCol     $massRot   $massRot   $massRot;
 mass 43 $massCol  $massCol  $massCol     $massRot   $massRot   $massRot;
 mass 45 $massBeamOut  $massBeamOut  $massBeamOut     $massRot   $massRot   $massRot;
 
 mass 55 $massBeamMid  $massBeamMid  $massBeamOut     $massRot   $massRot   $massRot;
 
 mass 62 $massCol  $massCol  $massCol     $massRot   $massRot   $massRot;
 mass 63 $massCol  $massCol  $massCol     $massRot   $massRot   $massRot;
 mass 65 $massBeamOut  $massBeamOut  $massBeamOut     $massRot   $massRot   $massRot;
 
 
mass 111001   $MassDeckEnd    $MassDeckEnd    $MassDeckEnd     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 111002   $MassDeckEnd    $MassDeckEnd    $MassDeckEnd     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 111     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 112     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 113     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 114     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 115     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 116     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 116001   $MassDeckEnd    $MassDeckEnd    $MassDeckEnd     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 116002   $MassDeckEnd    $MassDeckEnd    $MassDeckEnd     $MassDeckRot  $MassDeckRot  $MassDeckRot;

mass 122     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 123     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 124     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 125     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 126     $MassDeck    $MassDeck    $MassDeck     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 126001   $MassDeckEnd    $MassDeckEnd    $MassDeckEnd     $MassDeckRot  $MassDeckRot  $MassDeckRot;
mass 126002   $MassDeckEnd    $MassDeckEnd    $MassDeckEnd     $MassDeckRot  $MassDeckRot  $MassDeckRot;

if {$SSI == "Yes"} {
	mass 10000		$massBeamOut $massBeamOut  $massBeamOut     $massRot   $massRot   $massRot;
	mass 10001		$massBeamMid $massBeamMid  $massBeamMid     $massRot   $massRot   $massRot;
	mass 10002		$massBeamOut $massBeamOut  $massBeamOut     $massRot   $massRot   $massRot;

	mass 20000		$massBeamOut $massBeamOut  $massBeamOut     $massRot   $massRot   $massRot;
	mass 20001		$massBeamMid $massBeamMid  $massBeamMid     $massRot   $massRot   $massRot;
	mass 20002		$massBeamOut $massBeamOut  $massBeamOut     $massRot   $massRot   $massRot;
	}
 
 #####################################
 ##### Constraints
 #####################################
 

if {$SSI == "No"} {
	fix		40			1 1 1	1 1 1;
	fix		60			1 1 1	1 1 1;

	fix		10000		1 1	1	1 1 1;
	fix		10001		1 1	1	1 1 1;
	fix		10002		1 1	1	1 1 1;

	fix		20000		1 1	1	1 1 1;
	fix		20001		1 1	1	1 1 1;
	fix		20002		1 1	1	1 1 1;
	}
#
if {$SSI == "Yes"} {
	fix		4100011			1 1 1	1 1 1;
	fix		6100011			1 1 1	1 1 1;

	fix		10010		1 1	1	1 1 1;
	fix		10011		1 1	1	1 1 1;
	fix		10012		1 1	1	1 1 1;

	fix		20010		1 1	1	1 1 1;
	fix		20011		1 1	1	1 1 1;
	fix		20012		1 1	1	1 1 1;

	}

#
# equalDOF 55 116  1 2 3 4 5 6;
# equalDOF 55 121  1 2 3 4 5 6; 

# Gravity Load

source ProcGravityLoad.tcl ;

 pattern Plain 1 Linear {

   load 42 0 0 [expr -$massCol*$g] 0 0 0;    # node#, FX FY MZ -- 
   load 43 0 0 [expr -$massCol*$g] 0 0 0;
   load 45 0 0 [expr -($Wdeck/8.0 + $massBeamOut*$g)] 0 0 0;

   load 55 0 0 [expr -($Wdeck/4.0 + $massBeamMid*$g)] 0 0 0;

   load 62 0 0 [expr -$massCol*$g] 0 0 0;    # node#, FX FY MZ -- 
   load 63 0 0 [expr -$massCol*$g] 0 0 0;
   load 65 0 0 [expr -($Wdeck/8.0 + $massBeamOut*$g)] 0 0 0;
   
   PTload 47 $pi $PTnum $PTArea $prestress
   PTload 67 $pi $PTnum $PTArea $prestress

}
#

set dataDir1	Gravity;
file mkdir $dataDir1 ;

recorder Node -file $dataDir1/React40.out -node 40  -dof 1 2 3  reaction;	   # section deformations, axial and curvature, node i
recorder Node -file $dataDir1/React60.out -node 60  -dof 1 2 3  reaction;

#source BentShapeOriginal.tcl;

# Gravity-analysis parameters -- load-controlled static analysis
set Tol 1.0e-6;			# convergence tolerance for test
set LVALUE 20;
constraints 	Transformation;     		# how it handles boundary conditions   ;   Plain	Transformation
numberer 		RCM;			# renumber dof's to minimize band-width (optimization), if you want to;  Plain  RCM
system 			UmfPack  -lvalueFact $LVALUE;		# how to store and solve the system of equations in the analysis ->   UmfPack  -lvalueFact $LVALUE;    BandSPD 
# system			SparseSYM 
# test NormDispIncr $Tol 10 ; 		# determine if convergence has been achieved at the end of an iteration step
test 			EnergyIncr  $Tol 150 5;
#test			NormDispIncr $Tol 6 
algorithm 		 KrylovNewton ;			# use Newton's solution algorithm: updates tangent stiffness at every iteration;  Broyden 8;  KrylovNewton  -maxDim 3;   Newton
set NstepGravity 80;  		# apply gravity in 10 steps
set DGravity 	[expr 1./$NstepGravity]; 	# first load increment;
integrator 		LoadControl $DGravity;	# determine the next time step for an analysis
analysis 		Static;			# define type of analysis static or transient
#analyze 		$NstepGravity;		# apply gravity

set ok_Gravity [analyze 50]
# ------------------------------------------------- maintain constant gravity loads and reset time to zero
loadConst 		-time 0.0 ;        # holds gravity loads and puts time counter to zero, restart time;  

puts "Gravity analysis complete"

if {$BRB == "Yes"} {
	# Create slave nodes for connection
	node 301	$X2_in		$Y2_in		0;
	node 302	$X2_mid		$Y2_mid		[expr 1.00*$LTotal];
	node 303	$X2_out		$Y2_out		0;

	equalDOF  41  301   1 2 3 4 5 6;
	equalDOF  55  302   1 2 3 4 5 6;
	equalDOF  61  303   1 2 3 4 5 6;

	source BRBs.tcl;

	set dataDir2	Gravity_PostBRB;
	file mkdir		$dataDir2

	recorder Element -file $dataDir2/ForcCol4.out -ele 41  globalForce;	   # section deformations, axial and curvature, node i
	recorder Element -file $dataDir2/ForcCol6.out -ele 61  globalForce;

	  recorder Element -file $dataDir2/BRB1.out -ele 301 deformationsANDforces;
	  recorder Element -file $dataDir2/BRB2.out -ele 302 deformationsANDforces;
	  
	# Gravity-analysis parameters -- load-controlled static analysis
	set Tol 1.0e-5;			# convergence tolerance for test
	constraints Transformation;     		# how it handles boundary conditions
	numberer Plain;			# renumber dof's to minimize band-width (optimization), if you want to
	system SparseGeneral -piv;  #BandGeneral;		# how to store and solve the system of equations in the analysis
	test 			EnergyIncr  $Tol 100 5;
	# test NormDispIncr $Tol 9 ; 		# determine if convergence has been achieved at the end of an iteration step
	algorithm Newton ;			# use Newton's solution algorithm: updates tangent stiffness at every iteration
	set NstepGravity 10;  		# apply gravity in 10 steps
	set DGravity [expr 1./$NstepGravity]; 	# first load increment;
	integrator LoadControl $DGravity;	# determine the next time step for an analysis
	analysis Static;			# define type of analysis static or transient
	analyze $NstepGravity;		# apply gravity
	# ------------------------------------------------- maintain constant gravity loads and reset time to zero
	loadConst -time 0.0 ;        # holds gravity loads and puts time counter to zero, restart time; 

	puts "BRBs/SCEDs Installed"
	}

# recorder Node -file RecordModeNodes.out  -node 40 41 42 43 44 45 46 -dof 1 2 3 "eigen 1";



#########################
## Rendering Geometry Data
##########################



set wa			[eigen -genBandArpack  16];
set wwa1		      [lindex $wa 0];
puts " wwa1 $wwa1";
set wwa2		      [lindex $wa 1];
puts " wwa2 $wwa2";
set wwa3		      [lindex $wa 2];
puts "wwa3 $wwa3";
set wwa4		      [lindex $wa 3];
set wwa5		      [lindex $wa 4];
set wwa6		      [lindex $wa 5];
set wwa7		      [lindex $wa 6];
set wwa8		      [lindex $wa 7];
set wwa9		      [lindex $wa 8];
set wwa10		      [lindex $wa 9];
set wwa11		      [lindex $wa 10];
set wwa12		      [lindex $wa 11];
set wwa13		      [lindex $wa 12];
set wwa14		      [lindex $wa 13];
set wwa15		      [lindex $wa 14];

set Ta1			[expr 2*$pi/sqrt($wwa1)];
set Ta2			[expr 2*$pi/sqrt($wwa2)];
set Ta3			[expr 2*$pi/sqrt($wwa3)];
set Ta4			[expr 2*$pi/sqrt($wwa4)];
set Ta5			[expr 2*$pi/sqrt($wwa5)];
set Ta6			[expr 2*$pi/sqrt($wwa6)];
set Ta7			[expr 2*$pi/sqrt($wwa7)];
set Ta8			[expr 2*$pi/sqrt($wwa8)];
set Ta9			[expr 2*$pi/sqrt($wwa9)];
set Ta10		[expr 2*$pi/sqrt($wwa10)];
set Ta11		[expr 2*$pi/sqrt($wwa11)];
set Ta12		[expr 2*$pi/sqrt($wwa12)];
set Ta13		[expr 2*$pi/sqrt($wwa13)];
set Ta14 		[expr 2*$pi/sqrt($wwa14)];
set Ta15		[expr 2*$pi/sqrt($wwa15)];

# set PeriodFile "ModalPeriods_$BridgeType.out"
# set fieldPeriod [open $PeriodFile w+]

source Get_Rendering.tcl

createODB "TwoSpan_Model" "none" 6  "none" "none"

# puts $fieldPeriod   "Period1= $Ta1"
# puts $fieldPeriod   "Period2= $Ta2"
# puts $fieldPeriod   "Period3= $Ta3"
# puts $fieldPeriod   "Period4= $Ta4"
# puts $fieldPeriod   "Period5= $Ta5"
# puts $fieldPeriod   "Period6= $Ta6"
# puts $fieldPeriod   "Period7= $Ta7"
# puts $fieldPeriod   "Period8= $Ta8"
# puts $fieldPeriod   "Period9= $Ta9"
# puts $fieldPeriod   "Period10= $Ta10"
# puts $fieldPeriod   "Period11= $Ta11"
# puts $fieldPeriod   "Period12= $Ta12"
# puts $fieldPeriod   "Period13= $Ta13"
# puts $fieldPeriod   "Period14= $Ta14"
# puts $fieldPeriod   "Period15= $Ta15"

# close $fieldPeriod

puts "Fundamental-Period After Gravity Analysis:"
puts "Period1= $Ta1"
puts "Period2= $Ta2"
puts "Period3= $Ta3"

#recorder Node -file RecordModeNodes.out  -node 40 41 42 43 44 45 46 -dof 1 2 3 "eigen 1";
record 

  set xDamp 0.05;
  set MpropSwitch 1.00;
  set KcurrSwitch 0.00;
  set KcommSwitch 1.00;
  set KinitSwitch 0.00;
  set nEigenI 1;
  set nEigenJ 2;
  set lambdaN [eigen $nEigenJ];
  set lambdaI [lindex $lambdaN [expr $nEigenI-1]];
  set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]];
  set omegaI [expr pow($lambdaI,0.5)];
  set omegaJ [expr pow($lambdaJ,0.5)];
  set alphaM [expr $MpropSwitch*$xDamp*(2*$omegaI*$omegaJ)/($omegaI+$omegaJ)];
  set betaKcurr [expr $KcurrSwitch*2.*$xDamp/($omegaI+$omegaJ)];
  set betaKcomm [expr $KcommSwitch*2.*$xDamp/($omegaI+$omegaJ)];
  set betaKinit [expr $KinitSwitch*2.*$xDamp/($omegaI+$omegaJ)];
  rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm;
  

  # print -ele 57 
  
if {$AnalysisType == "Cyclic"} {
	source Cyclic.tcl
	wipe
	}

  # wipe
  