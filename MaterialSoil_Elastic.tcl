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
# Pile Cap springs

uniaxialMaterial  Elastic	100		10e-2; 

#uniaxialMaterial  Hysteretic   200     [expr 10.*0.8*41580.0*$N]  [expr 3.4*$mm]    [expr 10.*1.3*41580.0*$N] [expr 10.*$mm]    [expr 10.0*1.8*41580.0*$N] [expr 50.*$mm]    [expr -10.0*0.8*41580.0]  [expr -3.4*$mm]   [expr -10.0*1.3*41580.0*$N] [expr -10.*$mm]     [expr -10.0*1.8*61857.0] [expr -50.*$mm]     0.8 0.5 0 0 ;
# uniaxialMaterial  Elastic   200  [expr 15.*41580.0*$N/(3.4*$mm)] 
uniaxialMaterial  Elastic   200  [expr 1000.0*$kip/$in] 

uniaxialMaterial  Elastic	300	  [expr 10e10*$N/$mm]	; # High stiffness in vertical direction

set F1GB  [expr 2*$BaseAreaGB*1.35*(1.56*4.4482/(25.4*25.4))*$N];
set F2GB  [expr 2*$BaseAreaGB*0.90*(1.56*4.4482/(25.4*25.4))*$N];
set F3GB  [expr 2*$BaseAreaGB*0.85*(1.56*4.4482/(25.4*25.4))*$N];

# uniaxialMaterial  Hysteretic  400     $F1GB  0.125    $F2GB  0.88      $F3GB   1.4     1.5  $F3GB ;
uniaxialMaterial  Hysteretic  400     [expr 1.0*35.*$kN]  3.17    [expr 1.0*48.0*$kN]  8.3      [expr 1.0*80.0*$kN]   40.0    [expr -1.0*35.0*$kN]  -3.17    [expr -1.0*48.0*$kN]  -8.3      [expr -1.0*80.0*$kN]   -40.0    0.8 0.5 0 0; # First force 64 kN
# uniaxialMaterial  PySimple1    400     1    [expr 0.3*1.8*41580.0*$N]   7.5  0.3   135.52; # 0.4  -- 10.5


######################################################################################
####  Abutment Soil
######################################################################################

## Based on abutment stiffness models for bridge simulation proposed by Patrick Wilson and Ahmed Elgamal at UCSD

###
#####
###

########## Longitudinal Stiffness 


set Www   		[expr 5.*$m];
set WAbut 		$DeckWidth; # Total abutment width
set nPilesAbut  9.;


set Kmax  [expr (28728.*$kN/$m)*$WAbut/3];   # For each spring in longitudinal direction of the bridge
set Kur   $Kmax;
set Rf    0.7;
set Fult  [expr -326.*$kN*$WAbut/3];  #  Ultimate force for each spring
set gap   [expr -2.54*$mm];

uniaxialMaterial HyperbolicGapMaterial 5011 $Kmax $Kur $Rf $Fult $gap; # Longitudinal Direction 
uniaxialMaterial Elastic 			   5012  [expr ($nPilesAbut*7000*$kN/$m)/3]; 
uniaxialMaterial Parallel 			   501 5011 5012;

#--------------------------------------------SIMPLFIED ABUTMENT BASED ON PEER REPORT---------------------------------------

#
########### Transverse Stiffness
#
set CW				[expr 4.0/3.0];   # participation coefficients 
set CL				[expr 2.0/3.0];   # wall effectiveness
set KabutT		     [expr 89783.0*$kN/$m]; 

uniaxialMaterial Elastic 	502   $KabutT;  # Material in Transverse Direction

#
########### Vertical Stiffness
#
set   kv    [expr 8.0*10e10*$kN/$m];            # this stiffness value of the flexible portion of the bearing pad is derived from PEER report

#

# Longitudinal stiffness is working only in compression
# Transverse stiffness working in tension and compression, because they works parllel with half of SDC stiffness assigned for each
# Vertical stiffness has two portion constructed by two parallel uniaxialMaterial 

                            
uniaxialMaterial Elastic	503 	[expr 3.5*$kv];   # Vertical Stiffness

