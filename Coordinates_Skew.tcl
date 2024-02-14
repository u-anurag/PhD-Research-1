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

 ###################################
 ####### General Coordinates #######
 ###################################

set BridgeRadius [expr 50.0*134.*$ft];
set SpanL        [expr 75.*$ft];

# skewAngle is defined in DynamicAll.tcl file

set PileDistance  [expr 2.44*3.*$ft];
set RPile         [expr 0.5*$PileDistance/sqrt(2.0)];

# radial angle will be used to get the location of bent center and not for the bent rotation.
set AbutAAng [expr -2*($SpanL/$BridgeRadius)];  # Radian
set Bent1Ang [expr -1*($SpanL/$BridgeRadius)];
set Bent2Ang [expr  0*($SpanL/$BridgeRadius)]; 
set Bent3Ang [expr  1*($SpanL/$BridgeRadius)];
set AbutBAng [expr  2*($SpanL/$BridgeRadius)];

# set ZDeck  [expr $LTotal + 20.*$in];
set ZDeck  $Lloading;   # Changed on 06/22/2020

 #########################
 ### Abutment A   ########
 #########################
 
 set XA_inCant  [expr ($BridgeRadius*cos($AbutAAng)- 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set YA_inCant  [expr ($BridgeRadius*sin($AbutAAng)- 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 set XA_in  [expr ($BridgeRadius*cos($AbutAAng) - $LBeam*cos($skewAngle*$pi/180))];
 set YA_in  [expr ($BridgeRadius*sin($AbutAAng) - $LBeam*sin($skewAngle*$pi/180))];

 set XA_mid  [expr ($BridgeRadius)*cos($AbutAAng)];
 set YA_mid  [expr ($BridgeRadius)*sin($AbutAAng)];

 set XA_out  [expr ($BridgeRadius*cos($AbutAAng) + $LBeam*cos($skewAngle*$pi/180))];
 set YA_out  [expr ($BridgeRadius*sin($AbutAAng) + $LBeam*sin($skewAngle*$pi/180))];

 set XA_outCant  [expr ($BridgeRadius*cos($AbutAAng) + 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set YA_outCant  [expr ($BridgeRadius*sin($AbutAAng) + 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 #########################
 ####  Abutment B  #######
 #########################
 
 set XB_inCant  [expr ($BridgeRadius*cos($AbutBAng)- 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set YB_inCant  [expr ($BridgeRadius*sin($AbutBAng)- 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 set XB_in  [expr ($BridgeRadius*cos($AbutBAng) - $LBeam*cos($skewAngle*$pi/180))];
 set YB_in  [expr ($BridgeRadius*sin($AbutBAng) - $LBeam*sin($skewAngle*$pi/180))];

 set XB_mid  [expr ($BridgeRadius)*cos($AbutBAng)];
 set YB_mid  [expr ($BridgeRadius)*sin($AbutBAng)];

 set XB_out  [expr ($BridgeRadius*cos($AbutBAng) + $LBeam*cos($skewAngle*$pi/180))];
 set YB_out  [expr ($BridgeRadius*sin($AbutBAng) + $LBeam*sin($skewAngle*$pi/180))];

 set XB_outCant  [expr ($BridgeRadius*cos($AbutBAng) + 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set YB_outCant  [expr ($BridgeRadius*sin($AbutBAng) + 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 #########################
 ####### Bent 1   ########
 #########################
 
 set X1_inCant  [expr ($BridgeRadius*cos($Bent1Ang)- 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set Y1_inCant  [expr ($BridgeRadius*sin($Bent1Ang)- 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 set X1_in  [expr ($BridgeRadius*cos($Bent1Ang) - $LBeam*cos($skewAngle*$pi/180))];
 set Y1_in  [expr ($BridgeRadius*sin($Bent1Ang) - $LBeam*sin($skewAngle*$pi/180))];

 set X1_inRigid  [expr ($BridgeRadius*cos($Bent1Ang) - ($LBeam-0.5*$HCol)*cos($skewAngle*$pi/180))];
 set Y1_inRigid  [expr ($BridgeRadius*sin($Bent1Ang) - ($LBeam-0.5*$HCol)*sin($skewAngle*$pi/180))];

	 set X1_midRigid1  [expr ($BridgeRadius*cos($Bent1Ang) - 0.5*$HCol*cos($skewAngle*$pi/180))];
	 set Y1_midRigid1  [expr ($BridgeRadius*sin($Bent1Ang) - 0.5*$HCol*sin($skewAngle*$pi/180))];

	 set X1_mid  [expr ($BridgeRadius)*cos($Bent1Ang)];
	 set Y1_mid  [expr ($BridgeRadius)*sin($Bent1Ang)];

	 set X1_midRigid2  [expr ($BridgeRadius*cos($Bent1Ang) + 0.5*$HCol*cos($skewAngle*$pi/180))];
	 set Y1_midRigid2  [expr ($BridgeRadius*sin($Bent1Ang) + 0.5*$HCol*sin($skewAngle*$pi/180))];

 set X1_outRigid  [expr ($BridgeRadius*cos($Bent1Ang) + ($LBeam-0.5*$HCol)*cos($skewAngle*$pi/180))];
 set Y1_outRigid  [expr ($BridgeRadius*sin($Bent1Ang) + ($LBeam-0.5*$HCol)*sin($skewAngle*$pi/180))];

 set X1_out  [expr ($BridgeRadius*cos($Bent1Ang) + $LBeam*cos($skewAngle*$pi/180))];
 set Y1_out  [expr ($BridgeRadius*sin($Bent1Ang) + $LBeam*sin($skewAngle*$pi/180))];

 set X1_outCant  [expr ($BridgeRadius*cos($Bent1Ang) + 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set Y1_outCant  [expr ($BridgeRadius*sin($Bent1Ang) + 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 #########################
 ####### Bent 2   ########
 #########################
 
 set X2_inCant  [expr ($BridgeRadius*cos($Bent2Ang)- 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set Y2_inCant  [expr ($BridgeRadius*sin($Bent2Ang)- 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 set X2_in  [expr ($BridgeRadius*cos($Bent2Ang) - $LBeam*cos($skewAngle*$pi/180))];
 set Y2_in  [expr ($BridgeRadius*sin($Bent2Ang) - $LBeam*sin($skewAngle*$pi/180))];

 set X2_inRigid  [expr ($BridgeRadius*cos($Bent2Ang) - ($LBeam-0.5*$HCol)*cos($skewAngle*$pi/180))];
 set Y2_inRigid  [expr ($BridgeRadius*sin($Bent2Ang) - ($LBeam-0.5*$HCol)*sin($skewAngle*$pi/180))];

		 set X2_midRigid1  [expr ($BridgeRadius*cos($Bent2Ang) - 0.5*$HCol*cos($skewAngle*$pi/180))];
		 set Y2_midRigid1  [expr ($BridgeRadius*sin($Bent2Ang) - 0.5*$HCol*sin($skewAngle*$pi/180))];

		 set X2_mid  [expr ($BridgeRadius)*cos($Bent2Ang)];
		 set Y2_mid  [expr ($BridgeRadius)*sin($Bent2Ang)];

		 set X2_midRigid2  [expr ($BridgeRadius*cos($Bent2Ang) + 0.5*$HCol*cos($skewAngle*$pi/180))];
		 set Y2_midRigid2  [expr ($BridgeRadius*sin($Bent2Ang) + 0.5*$HCol*sin($skewAngle*$pi/180))];

 set X2_outRigid  [expr ($BridgeRadius*cos($Bent2Ang) + ($LBeam-0.5*$HCol)*cos($skewAngle*$pi/180))];
 set Y2_outRigid  [expr ($BridgeRadius*sin($Bent2Ang) + ($LBeam-0.5*$HCol)*sin($skewAngle*$pi/180))];

 set X2_out  [expr ($BridgeRadius*cos($Bent2Ang) + $LBeam*cos($skewAngle*$pi/180))];
 set Y2_out  [expr ($BridgeRadius*sin($Bent2Ang) + $LBeam*sin($skewAngle*$pi/180))];

 set X2_outCant  [expr ($BridgeRadius*cos($Bent2Ang) + 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set Y2_outCant  [expr ($BridgeRadius*sin($Bent2Ang) + 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 #########################
 ####### Bent 3   ########
 #########################
 
 set X3_inCant  [expr ($BridgeRadius*cos($Bent3Ang)- 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set Y3_inCant  [expr ($BridgeRadius*sin($Bent3Ang)- 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 set X3_in  [expr ($BridgeRadius*cos($Bent3Ang) - $LBeam*cos($skewAngle*$pi/180))];
 set Y3_in  [expr ($BridgeRadius*sin($Bent3Ang) - $LBeam*sin($skewAngle*$pi/180))];

 set X3_inRigid  [expr ($BridgeRadius*cos($Bent3Ang) - ($LBeam-0.5*$HCol)*cos($skewAngle*$pi/180))];
 set Y3_inRigid  [expr ($BridgeRadius*sin($Bent3Ang) - ($LBeam-0.5*$HCol)*sin($skewAngle*$pi/180))];

		 set X3_midRigid1  [expr ($BridgeRadius*cos($Bent3Ang) - 0.5*$HCol*cos($skewAngle*$pi/180))];
		 set Y3_midRigid1  [expr ($BridgeRadius*sin($Bent3Ang) - 0.5*$HCol*sin($skewAngle*$pi/180))];

		 set X3_mid  [expr ($BridgeRadius)*cos($Bent3Ang)];
		 set Y3_mid  [expr ($BridgeRadius)*sin($Bent3Ang)];

		 set X3_midRigid2  [expr ($BridgeRadius*cos($Bent3Ang) + 0.5*$HCol*cos($skewAngle*$pi/180))];
		 set Y3_midRigid2  [expr ($BridgeRadius*sin($Bent3Ang) + 0.5*$HCol*sin($skewAngle*$pi/180))];

 set X3_outRigid  [expr ($BridgeRadius*cos($Bent3Ang) + ($LBeam-0.5*$HCol)*cos($skewAngle*$pi/180))];
 set Y3_outRigid  [expr ($BridgeRadius*sin($Bent3Ang) + ($LBeam-0.5*$HCol)*sin($skewAngle*$pi/180))];

 set X3_out  [expr ($BridgeRadius*cos($Bent3Ang) + $LBeam*cos($skewAngle*$pi/180))];
 set Y3_out  [expr ($BridgeRadius*sin($Bent3Ang) + $LBeam*sin($skewAngle*$pi/180))];

 set X3_outCant  [expr ($BridgeRadius*cos($Bent3Ang) + 0.5*$DeckWidth*cos($skewAngle*$pi/180))];
 set Y3_outCant  [expr ($BridgeRadius*sin($Bent3Ang) + 0.5*$DeckWidth*sin($skewAngle*$pi/180))];

 ###################################
 ########  Bent 1 PileCap ##########
 ###################################
 
 # Inner PileCap
 
 set X1PCin_1   [expr  $X1_in + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y1PCin_1   [expr  $Y1_in + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X1PCin_2   [expr  $X1_in - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y1PCin_2   [expr  $Y1_in - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X1PCin_3   [expr  $X1_in - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y1PCin_3   [expr  $Y1_in - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X1PCin_4   [expr  $X1_in + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y1PCin_4   [expr  $Y1_in + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 # Middle PileCap
 
 set X1PCmid_1   [expr  $X1_mid + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y1PCmid_1   [expr  $Y1_mid + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X1PCmid_2   [expr  $X1_mid - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y1PCmid_2   [expr  $Y1_mid - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X1PCmid_3   [expr  $X1_mid - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y1PCmid_3   [expr  $Y1_mid - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X1PCmid_4   [expr  $X1_mid + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y1PCmid_4   [expr  $Y1_mid + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X1PCmid_5   [expr  $X1_mid];
 set Y1PCmid_5   [expr  $Y1_mid];
 
  # Outer PileCap
 
 set X1PCout_1   [expr  $X1_out + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y1PCout_1   [expr  $Y1_out + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X1PCout_2   [expr  $X1_out - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y1PCout_2   [expr  $Y1_out - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X1PCout_3   [expr  $X1_out - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y1PCout_3   [expr  $Y1_out - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X1PCout_4   [expr  $X1_out + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y1PCout_4   [expr  $Y1_out + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 
 ###################################
 ########  Bent 2 PileCap ##########
 ###################################
 
 # Inner PileCap
 
 set X2PCin_1   [expr  $X2_in + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y2PCin_1   [expr  $Y2_in + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X2PCin_2   [expr  $X2_in - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y2PCin_2   [expr  $Y2_in - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X2PCin_3   [expr  $X2_in - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y2PCin_3   [expr  $Y2_in - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X2PCin_4   [expr  $X2_in + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y2PCin_4   [expr  $Y2_in + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 # Middle PileCap
 
 set X2PCmid_1   [expr  $X2_mid + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y2PCmid_1   [expr  $Y2_mid + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X2PCmid_2   [expr  $X2_mid - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y2PCmid_2   [expr  $Y2_mid - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X2PCmid_3   [expr  $X2_mid - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y2PCmid_3   [expr  $Y2_mid - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X2PCmid_4   [expr  $X2_mid + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y2PCmid_4   [expr  $Y2_mid + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X2PCmid_5   [expr  $X2_mid];
 set Y2PCmid_5   [expr  $Y2_mid];
 
  # Outer PileCap
 
 set X2PCout_1   [expr  $X2_out + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y2PCout_1   [expr  $Y2_out + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X2PCout_2   [expr  $X2_out - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y2PCout_2   [expr  $Y2_out - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X2PCout_3   [expr  $X2_out - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y2PCout_3   [expr  $Y2_out - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X2PCout_4   [expr  $X2_out + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y2PCout_4   [expr  $Y2_out + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 
 ###################################
 ########  Bent 3 PileCap ##########
 ###################################
 
 # Inner PileCap
 
 set X3PCin_1   [expr  $X3_in + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y3PCin_1   [expr  $Y3_in + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X3PCin_2   [expr  $X3_in - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y3PCin_2   [expr  $Y3_in - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X3PCin_3   [expr  $X3_in - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y3PCin_3   [expr  $Y3_in - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X3PCin_4   [expr  $X3_in + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y3PCin_4   [expr  $Y3_in + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 # Middle PileCap
 
 set X3PCmid_1   [expr  $X3_mid + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y3PCmid_1   [expr  $Y3_mid + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X3PCmid_2   [expr  $X3_mid - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y3PCmid_2   [expr  $Y3_mid - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X3PCmid_3   [expr  $X3_mid - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y3PCmid_3   [expr  $Y3_mid - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X3PCmid_4   [expr  $X3_mid + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y3PCmid_4   [expr  $Y3_mid + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X3PCmid_5   [expr  $X3_mid];
 set Y3PCmid_5   [expr  $Y3_mid];
 
  # Outer PileCap
 
 set X3PCout_1   [expr  $X3_out + $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y3PCout_1   [expr  $Y3_out + $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X3PCout_2   [expr  $X3_out - $RPile*cos(($skewAngle + 45.)*$pi/180.)];
 set Y3PCout_2   [expr  $Y3_out - $RPile*sin(($skewAngle + 45.)*$pi/180.)];
 
 set X3PCout_3   [expr  $X3_out - $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y3PCout_3   [expr  $Y3_out - $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 set X3PCout_4   [expr  $X3_out + $RPile*cos(($skewAngle - 45.)*$pi/180.)];
 set Y3PCout_4   [expr  $Y3_out + $RPile*sin(($skewAngle - 45.)*$pi/180.)];
 
 
 #######################################
 ######## SPAN 1 DECK ##################
 #######################################
 
		 set Xspan1_1_in    $XA_inCant;   # Inner node of span 1 end at abutment A
		 set Yspan1_1_in    $YA_inCant;

		 set Xspan1_1_out   $XA_outCant;  # Outer node of span 1 end at abutment A
		 set Yspan1_1_out   $YA_outCant;

 set Xspan1_1 [expr ($BridgeRadius)*cos(-2.0*$SpanL/$BridgeRadius)];
 set Yspan1_1 [expr ($BridgeRadius)*sin(-2.0*$SpanL/$BridgeRadius)];
 
 set Xspan1_2 [expr ($BridgeRadius)*cos(-1.8*$SpanL/$BridgeRadius)];
 set Yspan1_2 [expr ($BridgeRadius)*sin(-1.8*$SpanL/$BridgeRadius)];
 
 set Xspan1_3 [expr ($BridgeRadius)*cos(-1.6*$SpanL/$BridgeRadius)];
 set Yspan1_3 [expr ($BridgeRadius)*sin(-1.6*$SpanL/$BridgeRadius)];
 
 set Xspan1_4 [expr ($BridgeRadius)*cos(-1.4*$SpanL/$BridgeRadius)];
 set Yspan1_4 [expr ($BridgeRadius)*sin(-1.4*$SpanL/$BridgeRadius)];
 
 set Xspan1_5 [expr ($BridgeRadius)*cos(-1.2*$SpanL/$BridgeRadius)];
 set Yspan1_5 [expr ($BridgeRadius)*sin(-1.2*$SpanL/$BridgeRadius)];
 
 set Xspan1_6     $X1_mid;
 set Yspan1_6     $Y1_mid;

		 set Xspan1_6_in    $X1_inCant;   # Inner node of span 1 end at bent 1
		 set Yspan1_6_in    $Y1_inCant; 

		 set Xspan1_6_out   $X1_outCant;  # Outer node of span 1 end at bent 1
		 set Yspan1_6_out   $Y1_outCant;
		  
 #######################################
 ######## SPAN 2 DECK ##################
 #######################################
 

		 set Xspan2_1_in    $X1_inCant;  # Inner node of span 2 end at bent 1
		 set Yspan2_1_in    $Y1_inCant;

		 set Xspan2_1_out   $X1_outCant;  # Outer node of span 2 end at bent 1
		 set Yspan2_1_out   $Y1_outCant;
		 
 set Xspan2_1 [expr ($BridgeRadius)*cos(-1.0*$SpanL/$BridgeRadius)];
 set Yspan2_1 [expr ($BridgeRadius)*sin(-1.0*$SpanL/$BridgeRadius)];
 
 set Xspan2_2 [expr ($BridgeRadius)*cos(-0.8*$SpanL/$BridgeRadius)];
 set Yspan2_2 [expr ($BridgeRadius)*sin(-0.8*$SpanL/$BridgeRadius)];
 
 set Xspan2_3 [expr ($BridgeRadius)*cos(-0.6*$SpanL/$BridgeRadius)];
 set Yspan2_3 [expr ($BridgeRadius)*sin(-0.6*$SpanL/$BridgeRadius)];
 
 set Xspan2_4 [expr ($BridgeRadius)*cos(-0.4*$SpanL/$BridgeRadius)];
 set Yspan2_4 [expr ($BridgeRadius)*sin(-0.4*$SpanL/$BridgeRadius)];
 
 set Xspan2_5 [expr ($BridgeRadius)*cos(-0.2*$SpanL/$BridgeRadius)];
 set Yspan2_5 [expr ($BridgeRadius)*sin(-0.2*$SpanL/$BridgeRadius)];
 
 set Xspan2_6     $X2_mid;
 set Yspan2_6     $Y2_mid;

		 set Xspan2_6_in    $X2_inCant;  # Inner node of span 2 end at bent 2
		 set Yspan2_6_in    $Y2_inCant;

		 set Xspan2_6_out   $X2_outCant;  # Outer node of span 2 end at bent 2
		 set Yspan2_6_out   $Y2_outCant;
		 
 
  ################# Reached Global X-axis direction #####################

 #######################################
 ######## SPAN 3 DECK ##################
 #######################################
   
 set Xspan3_1     $X2_mid;
 set Yspan3_1     $Y2_mid;

		 set Xspan3_1_in    $X2_inCant;  # Inner node of span 3 end at bent 2
		 set Yspan3_1_in    $Y2_inCant;

		 set Xspan3_1_out   $X2_outCant; # Outer node of span 3 end at bent 2
		 set Yspan3_1_out   $Y2_outCant;
		 
 set Xspan3_2 [expr ($BridgeRadius)*cos(0.2*$SpanL/$BridgeRadius)];
 set Yspan3_2 [expr ($BridgeRadius)*sin(0.2*$SpanL/$BridgeRadius)];
 
 set Xspan3_3 [expr ($BridgeRadius)*cos(0.4*$SpanL/$BridgeRadius)];
 set Yspan3_3 [expr ($BridgeRadius)*sin(0.4*$SpanL/$BridgeRadius)];
 
 set Xspan3_4 [expr ($BridgeRadius)*cos(0.6*$SpanL/$BridgeRadius)];
 set Yspan3_4 [expr ($BridgeRadius)*sin(0.6*$SpanL/$BridgeRadius)];
 
 set Xspan3_5 [expr ($BridgeRadius)*cos(0.8*$SpanL/$BridgeRadius)];
 set Yspan3_5 [expr ($BridgeRadius)*sin(0.8*$SpanL/$BridgeRadius)];

 set Xspan3_6     $X3_mid;
 set Yspan3_6     $Y3_mid;

		 set Xspan3_6_in    $X3_inCant;  # Inner node of span 3 end at bent 3 
		 set Yspan3_6_in    $Y3_inCant;

		 set Xspan3_6_out   $X3_outCant; # Outer node of span 3 end at bent 3 
		 set Yspan3_6_out   $Y3_outCant;
		 	 
 #######################################
 ######## SPAN 4 DECK ##################
 #######################################
  
 set Xspan4_1     $X3_mid;
 set Yspan4_1     $Y3_mid;

		 set Xspan4_1_in    $X3_inCant;  # Inner node of span 4 end at bent 3
		 set Yspan4_1_in    $Y3_inCant;

		 set Xspan4_1_out   $X3_outCant; # Outer node of span 4 end at bent 3
		 set Yspan4_1_out   $Y3_outCant;

 set Xspan4_2 [expr ($BridgeRadius)*cos(1.2*$SpanL/$BridgeRadius)];
 set Yspan4_2 [expr ($BridgeRadius)*sin(1.2*$SpanL/$BridgeRadius)];
 
 set Xspan4_3 [expr ($BridgeRadius)*cos(1.4*$SpanL/$BridgeRadius)];
 set Yspan4_3 [expr ($BridgeRadius)*sin(1.4*$SpanL/$BridgeRadius)];
 
 set Xspan4_4 [expr ($BridgeRadius)*cos(1.6*$SpanL/$BridgeRadius)];
 set Yspan4_4 [expr ($BridgeRadius)*sin(1.6*$SpanL/$BridgeRadius)];
 
 set Xspan4_5 [expr ($BridgeRadius)*cos(1.8*$SpanL/$BridgeRadius)];
 set Yspan4_5 [expr ($BridgeRadius)*sin(1.8*$SpanL/$BridgeRadius)];
 
 set Xspan4_6 [expr ($BridgeRadius)*cos(2.0*$SpanL/$BridgeRadius)];
 set Yspan4_6 [expr ($BridgeRadius)*sin(2.0*$SpanL/$BridgeRadius)];
 
		 set Xspan4_6_in    $XB_inCant;  # Inner node of span 4 end at abutment B
		 set Yspan4_6_in    $YB_inCant;

		 set Xspan4_6_out   $XB_outCant; # Outer node of span 4 end at abutment B
		 set Yspan4_6_out   $YB_outCant;


#####################################################################
##########  COORDINATE TRANSFORMATION DEFINITION ####################
#####################################################################

set ColBent1TransfTag	1; 			# associate a tag to column transformation  
set ColBent2TransfTag	2; 			# associate a tag to column transformation  
set ColBent3TransfTag	3; 			# associate a tag to column transformation  
set BeamTransfTag		4;
set DeckTransfTag		5;
set PileTransfTag		6;

# Define transformation vectors for the bent columns in coordinate file
geomTransf  PDelta $ColBent1TransfTag	[expr	cos($skewAngle*$pi/180)]	[expr	sin($skewAngle*$pi/180)]	0;
geomTransf  PDelta $ColBent2TransfTag	[expr	cos($skewAngle*$pi/180)]	[expr	sin($skewAngle*$pi/180)]	0;  # Fot Bent2Ang = 0,-1,0
geomTransf  PDelta $ColBent3TransfTag	[expr	cos($skewAngle*$pi/180)]	[expr	sin($skewAngle*$pi/180)]	0;
geomTransf  Linear $BeamTransfTag		0  0  1; # local z is along global Z. (see the ProcColFiberSection.tcl for definition)
geomTransf  Linear $DeckTransfTag		0  0  1; # local z is along global Z to accomade any orientation of the deck in XY plane.
geomTransf  Linear $PileTransfTag		0 -1  0; # local x axis is in global Z. Hence, anything other than that. Piles are elastic.


#####################################################################
#########  ABUTMENT DIRECTION VECTORS
#####################################################################

set xV1	[expr cos($skewAngle*$pi/180)]
set yV1	[expr sin($skewAngle*$pi/180)]
set zV1	0


set xV2_AbutA	[expr cos(($skewAngle - 90.)*$pi/180)]
set yV2_AbutA	[expr sin(($skewAngle - 90.)*$pi/180)]
set zV2_AbutA	0

set xV2_AbutB	[expr cos(($skewAngle + 90.)*$pi/180)]
set yV2_AbutB	[expr sin(($skewAngle + 90.)*$pi/180)]
set zV2_AbutB	0

