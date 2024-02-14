
# ########################################################################
# Prepared by - Anurag Upadhyay, PhD Student, Civil and Environmental Engineering
#               University of Utah, Salt Lake City, UT - 84112
# Date - 05/08/2019
# Prepared for - Analysis of bridges with precast post-tensioned concrete bents
# ########################################################################

# Define ColSecTag for each section beforehand in the main file.
# This procedure is only for a circular column, add more procedures to this file

proc ColCircularSection {ColSecTag CoreConcMat CoverConcMat ReinfMat ColDia cover numBarCol barArea barDia IDTorsionCol} {

set yCenter		      	0.00;		# y coordinate of the center of the circle
set zCenter		      	0.00;		# z coordinate of the center of the circle

set numSubdivCircCore	$numBarCol;	# Number of subdivisions (fibers) in the circumferential direction for core concrete
set numSubdivRadCore	10;			# Number of subdivisions (fibers) in the radial direction for the core concrete
set intRadCore			0.00;		# Internal radius of core concrete
set extRadCore			[expr $ColDia/2 -$cover];  # External radius of core concrete

set numSubdivCircCover	$numBarCol;	# Number of subdivisions (fibers) in the circumferential direction for cover concrete
set numSubdivRadCover	2;			# Number of subdivisions (fibers) in the radial direction for cover concrete
set intRadCover			[expr $ColDia/2-$cover];	# Internal radius of the cover concrete
set extRadCover			[expr $ColDia/2];			# External radius of the cover concrete

set radius				[expr $ColDia-$cover-$barDia/2];# Radius of reinforcing layer
# 
# Create fiber section. This gives the column fiber section with ColSecTag.

section Fiber $ColSecTag -GJ $IDTorsionCol {
		patch circ $CoreConcMat  $numSubdivCircCore  $numSubdivRadCore  $yCenter $zCenter $intRadCore  $extRadCore 0.0 360.0;  #Core
		patch circ $CoverConcMat $numSubdivCircCover $numSubdivRadCover $yCenter $zCenter $intRadCover $extRadCover 0.0 360.0;  #Cover
		# layer circ $ReinfMat $numBarCol $barArea $yCenter $zCenter $radius; # Rebar circular layer
	} 
#
# puts "Column section $ColSecTag built"

}