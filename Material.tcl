
# ##################################
# Prepared by - Anurag Upadhyay, PhD Student, Civil and Environmental Engineering
#               University of Utah, Salt Lake City, UT - 84112
# Date - 3/3/2016
# Prepared for - Analysis of a 3 column bridge bent for earthquake retrofit
# ##################################

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

# MATERIAL parameters -------------------------------------------------------------------
set CoreConcMat		1; 			# material ID tag -- confined core concrete
set CoverConcMat	2;			# material ID tag -- unconfined cover concrete
set IDreinf			3; 			# material ID tag -- reinforcement
set IDShearCol		4;
set IDTorsionCol	5;
set IDShearBeam		6;
set IDTorsionBeam	7;
set IDShearColLim	8;

set MatBearingVert	11;
set MatBearingLat	12;
set MatBearingLong	13;
set MatBearingRotZ	14;
set MatBearingRotX	15;
set MatBearingRotY	16;
set MatBearingFixed 27;

set MatPounding     17;

set matTagPT2 18;
set matTagPT  19;

set PTBarPSMatFail	25;
set PTBarMat		26;


########################################
########### Concrete Material ##########
########################################

set fc            [expr 1.1*5.0*$ksi];	                      # CONCRETE Compressive Strength, MPa  (+Tension, -Compression); In-situ strangth = 1.2* Design strength
set Ec            [expr 1820*pow($fc,0.5)*$ksi];              # should be in 'ksi' units
set Uc            0.2;                                        # Poisson's ratio
set Gc            [expr $Ec/(2*(1+$Uc))];                     # Shear Modulus of Elasticity
set wconc	      [expr 143.96*$lb/pow($ft,3)];               # Normal Concrete Weight per Volume                                    
set mconc	      [expr 143.96*$lb/pow($ft,3)/$g];            # Normal Mass Weight per Volume

# ######## Confined Concrete ###########
set fc1 			[expr -1.2*$fc];			# CONFINED concrete, maximum stress
set eps1			-0.0045;					# strain at maximum strength of confined concrete
set fc2 			[expr -3.5*$ksi];			# ultimate stress  
set eps2	 		-0.03;						# strain at ultimate stress  
set lambda 			0.1;						# ratio between unloading slope at $eps2 and initial slope $Ec

uniaxialMaterial Concrete04 $CoreConcMat	$fc1 $eps1 $eps2 $Ec; # $ft $et $beta;
uniaxialMaterial Concrete04 $CoverConcMat	-$fc -0.0028 -0.0045 $Ec; # $ft $et $beta;


##############################
##### Steel Parameters
##############################

set Es           [expr 29000.0*$ksi];				# modulus of steel
set Us           0.2;                                   # Poisson's ratio
set Gs           [expr $Es/(2*(1+$Us))];                # Shear Modulus of Elasticity
set Fy           [expr 60*$ksi];                        # Yield Strength

set Bs 		0.005;								# strain-hardening ratio 
set R0 		18;									# control the transition from elastic to plastic branches
set cR1 	0.925;								# control the transition from elastic to plastic branches
set cR2 	0.15;								# control the transition from elastic to plastic branches
set a1    	0.03;   #default=0
set a2    	1.0;    #default=1.0
set a3    	0.03;   #default=0
set a4    	1.0;    #default=1.0
set si    	0.0;

uniaxialMaterial Steel02 $IDreinf $Fy $Es $Bs $R0 $cR1 $cR2;				# build reinforcement material


# Other steel properties
set Us           0.2;                                       # Poisson's ratio
set Gs           [expr $Es/(2*(1+$Us))];                    # Shear Modulus of Elasticity


uniaxialMaterial Elastic $IDShearCol	[expr (9./10.)*$Gc*$ACol];
uniaxialMaterial Elastic $IDTorsionCol	[expr 0.2*$Gc*$JCol];
uniaxialMaterial Elastic $IDShearBeam	[expr (9./10.)*$Gc*$ABeam];
uniaxialMaterial Elastic $IDTorsionBeam	[expr 0.2*$Gc*$JBeam];

#
##
#######
##
#

#############################################################
## Bearing Material 
#############################################################

set E  		[expr 5000.*$kip/$in] ;		# Changed from 1000 kip/in on 6-21-2020
set Elat  	[expr 0.4*$E];  # 0.01*$E  # changed from 0.2E on 6-21-2020
set Elong  	[expr 0.001*$E];  # 0.001*
set Erot	[expr 0.001*$E];

uniaxialMaterial Elastic $MatBearingVert		$E   0.0  $E ;
uniaxialMaterial Elastic $MatBearingRotZ		$Erot   0.0  $Erot ;
uniaxialMaterial Elastic $MatBearingRotX		$Erot   0.0  $Erot ;
uniaxialMaterial Elastic $MatBearingRotY		$E   0.0  $E ;

 ### Use for pushover
# uniaxialMaterial Elastic $MatBearingLong		$Elong   0.0  $Elong ;
# uniaxialMaterial Elastic $MatBearingLat			$Elong   0.0  $Elong ;

 ### Use for Dynamic
# uniaxialMaterial Steel01 		$MatBearingLat		[expr 2*4352.0*$kN]  $Elat  0.05;

# Fixed bearing
uniaxialMaterial ElasticPP $MatBearingFixed		$E   [expr 1.0*$in];

# Slider Bearing
uniaxialMaterial Elastic 		$MatBearingLat		$Elat   0.0  $Elat ;
uniaxialMaterial ElasticPP		$MatBearingLong		[expr (38.4*25.4/4.4482)*$kip/$in] [expr 0.2*$in];
#
##
###
##
#

##############################################################
## Pounding Material 
##############################################################

# set K1		[expr  0.2*8.41e6*$kN/$m] ;
# set K2		[expr  0.2*2.89e6*$kN/$m] ;
set K1		[expr  9540.0*$kip/$in] ;  # Muthukumar, Nelson
set K2		[expr  3277.8*$kip/$in] ;
set dm		[expr  -1.0*$in];
set dy		[expr  -0.1*$dm];		# Yield Displacement
set ExpGap	[expr  -1.0*$in];				# Expansion Gap
set HardRatio [expr $K2/$K1]

# uniaxialMaterial ImpactMaterial $MatPounding $K1 $K2 $dy $ExpGap ;
uniaxialMaterial ElasticPPGap $MatPounding $K1 [expr $K1*$dy] $ExpGap $HardRatio damage ;

############################################################
#### COncrete Filled Steel Piles
############################################################

set Ecomp  [expr $Es + (0.9/0.1)*$Ec];     #  LRFD design data



##################################
#######  PT Material  ############
##################################

set E_pt		[expr 28500.*$ksi] ;
set Fy_pt		[expr 121.0*$ksi];		# 1672 MPa for PT strands
set Eneg_pt		[expr 0.000001*$E_pt]; 
set gap_pt		[expr $prestress/$E_pt]
set eta_pt   	0.05 ;

#uniaxialMaterial Elastic			$matTagPT2	$E_pt   0.0  $Eneg_pt ;
uniaxialMaterial ElasticPP			$matTagPT2	$E_pt   [expr $Fy_pt/$E_pt] [expr -0.01*$Fy_pt/$E_pt];
uniaxialMaterial InitStressMaterial $matTagPT	$matTagPT2 [expr 1.06*$prestress] ;


######################################

set Fu_pt		[expr 150.*$ksi];
set Fy_pt  		[expr 121.*$ksi];
set E_pt   		[expr 1.0*28500.*$ksi];

set Bs 0.005;								# strain-hardening ratio 
set R0 18;									# control the transition from elastic to plastic branches
set cR1 0.925;								# control the transition from elastic to plastic branches
set cR2 0.15;								# control the transition from elastic to plastic branches
set a1    0.03;   	#default=0
set a2    1.0;   	#default=1.0
set a3    0.03;   	#default=0
set a4    1.0;   	#default=1.0
set si    $prestress;

uniaxialMaterial Steel02  	$PTBarMat   $Fy_pt  $E_pt   0.01  $R0 $cR1 $cR2  $a1 $a2 $a3 $a4 $si;  
uniaxialMaterial MinMax 	$PTBarPSMatFail $PTBarMat  -min -0.05   -max 0.05 ;

