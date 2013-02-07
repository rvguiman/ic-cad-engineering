#------- Sample N Transistor Tcl Pcell for laker L3 -----------------#
# what:   14nm sample n transistor
# params: 	pc length, number of fins, number of gate
# author:	Ricardo Victor Guiman II
# comment:	This is a sample tcl pcell only. Make sure you have created a paramCellLib before sourcing this script
#--------------------------------------------------------------------# 

dbDefineParameterizedCell -lib paramCellLib -cell ntrans -params [list [list devLen 0.014 Float] [list pGate 1 Integer] [list pNumFins 1 Integer] ] -vars { cvId xPt yPt rxFinLen rxFinHt rxLen rxHt pcEndCap pcPitch pcHorPitch rxFinPitch ttLen pcLayer tbLayer rxLayer ttLayer rxFinLayer rxFinPurpose addPc xPt2 yPt2 c llx lly urx ury pcBbox endCapBbox ttEx ttBbox addGate horEx verEx rxBbox addRxFin rxFinBbox } \
-exec {
	#------- vars -------#
	set cvId $dbParameterizedCell
	set xPt 0
	set yPt 0

	set rxFinLen 0.48
	set rxFinHt 0.014
	set rxLen 0.18
	set rxHt 0.048
	set pcEndCap 0.142
	set pcPitch 0.048
	set pcHorPitch 0.09
	set rxFinPitch 0.048
	set ttLen 0.072

	set pcLayer "PC"
	set tbLayer "TB"
	set rxLayer "RX"
	set ttLayer "TT"
	set rxFinLayer "RX"
	set rxFinPurpose "fin"
	#------- PC,TB Start-------#
	if { $pNumFins != 1 } {
		set addPc [expr ($pNumFins - 1) * $pcPitch]
		} else {
		set addPc 0
		}
	set xPt2 $xPt
	set yPt2 $yPt
	for { set c 1 } { $c <= $pGate } { incr c } {
		set llx $xPt2
		set lly $yPt2
		set urx [expr $xPt2 + $devLen]
		set ury [expr $yPt2 + $rxFinHt + $addPc]
		set pcBbox [list $llx $lly $urx $ury]  
		dbCreateRect -cv $cvId -layer $pcLayer -bbox $pcBbox
		
		#------- endcap -------#
		set llx $xPt2
		set lly [expr $yPt2 - $pcEndCap]
		set urx [expr $xPt2 + $devLen]
		set ury [expr $yPt2 + $rxFinHt + $pcEndCap + $addPc]
		set endCapBbox [list $llx $lly $urx $ury]
		dbCreateRect -cv $cvId -layer $pcLayer -bbox $endCapBbox
		#------- TB dg -------#
		set ttEx [expr ($ttLen - $devLen)/2]
		set ttBbox [list [expr $llx - $ttEx] $lly [expr $urx + $ttEx] $ury]
		dbCreateRect -cv $cvId -layer $tbLayer -bbox $ttBbox

		set xPt2 [expr $xPt2 + $pcHorPitch]
		}
	#------- PC End -------#

	#------- RX,TT Start -------#
	if { $pGate != 1 } {
		set addGate [expr ($pGate - 1) * $pcHorPitch]
		} else {
		set addGate 0
		}
	set horEx [expr ($rxLen - $devLen)/2]
	set verEx [expr ($rxHt - $rxFinHt)/2]
	set llx [expr $xPt - $horEx]
	set lly [expr $yPt - $verEx]
	set urx [expr $xPt + $devLen + $horEx + $addGate]
	set ury [expr $yPt + $rxFinHt + $verEx + $addPc]
	set rxBbox [list $llx $lly $urx $ury]
	dbCreateRect -cv $cvId -layer $rxLayer -bbox $rxBbox
	#------- TT dg -------#
	dbCreateRect -cv $cvId -layer $ttLayer -bbox $rxBbox
	#------- RX End -------#
	
	#------- RX FIN Start -------#
	if { $pGate != 1 } {
		set addRxFin [expr ($pGate - 1) * $pcHorPitch]
		} else {
		set addRxFin 0
		}
	set horEx [expr ($rxFinLen - $devLen)/2]
	set verEx 0
	set xPt2 $xPt
	set yPt2 $yPt
	for { set c 1 } { $c <= $pNumFins } { incr c } {
		set llx [expr $xPt2 - $horEx]
		set lly [expr $yPt2 - $verEx]
		set urx [expr $xPt2 + $devLen + $horEx + $addRxFin]
		set ury [expr $yPt2 + $rxFinHt + $verEx]
		set rxFinBbox [list $llx $lly $urx $ury]
		dbCreateRect -cv $cvId -layer $rxFinLayer -purpose $rxFinPurpose -bbox $rxFinBbox
		set yPt2 [expr $yPt2 + $rxFinPitch]
		}
	#------- RX FIN End -------#
	}
