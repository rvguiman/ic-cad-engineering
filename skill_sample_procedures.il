;;-------- Skill Sample Procedures for Cadence Tools  ------------------------------------------;;
;; What:    These are sample codes written in skill++ that can be loaded in Cadence Virtuoso Tool
;; Author:  Ricardo Victor Guiman II
;; Note:    Layer Names, Purposes , Etc may need to be change base on your techfile
;;----------------------------------------------------------------------------------------------;;


;;------- mkIcon ----------------------------------------------------------------------------------;;
;; what:        Procedure to create icon file that can be use as image in menus, buttons, etc
;; params:      iconName and saveLoc which is a path or directory where you want to save the icon
;;-------------------------------------------------------------------------------------------------;;


procedure( mkIcon( iconName saveLoc )
  wId = getCurrentWindow()
	geSaveIcon(
		wId
		iconName
		saveLoc
		)
	)

;;------- menuLoad ----------------------------------------------------------------------------------;;
;; what:        Procedure to load icon file and create menu items
;; params:      none
;;---------------------------------------------------------------------------------------------------;;

procedure( menuLoad()
    iconW = 30
	iconH = 30
	iconList = list( "icon_m1" "icon_m2" "icon_m3" )
	iconLoc = "home/ricardo/test/icons/"
	foreach( curIcon iconList
		pathStr = buildString( list( iconLoc curIcon ".ico" ) "")
		geLoadIcon(
			curIcon
			pathStr
			iconW
			iconH
			)
		)
	icon_m1_pic = dlDlistToIcon(
			icon_m1dlist
			iconW
			iconH
			)
	icon_m2_pic = dlDlistToIcon(
			icon_m2dlist
			iconW
			iconH
			)
	icon_m3_pic = dlDlistToIcon(
			icon_m3dlist
			iconW
			iconH
			)

	m1ViewHan  = hiCreateMenuItem( ?name 'm1ViewHan ?itemIcon icon_m1_pic ?callback "togView(1)")
	m2ViewHan  = hiCreateMenuItem( ?name 'm2ViewHan ?itemIcon icon_m2_pic ?callback "togView(2)")
	m3ViewHan  = hiCreateMenuItem( ?name 'm3ViewHan ?itemIcon icon_m3_pic ?callback "togView(3)")
	hideViewHan  = hiCreateMenuItem( ?name 'hideViewHan ?itemIcon icon_hide_pic ?callback "hideAll()")
	allViewHan  = hiCreateMenuItem( ?name 'allViewHan ?itemIcon icon_all_pic ?callback "showAll()")
	lineBrkHan = hiCreateMenuItem(?name 'lineBrkHan ?itemText "        " ?disable t )

	if( boundp('metRevMenuHan) != t
	hiCreateVerticalFixedMenu( 'metRevMenuHan
								list(
									allViewHan		
									hideViewHan
									lineBrkHan
									lineBrkHan
									m1ViewHan
									m2ViewHan
									m3ViewHan
									lineBrkHan				
									) 
									22 2)
		);if

)

;;------- menuInvoke ----------------------------------------------------------------------------------;;
;; what:        Procedure to invoke a sample fixed menu using our created icons that we have loaded
;; params:      none
;;-----------------------------------------------------------------------------------------------------;;

procedure( menuInvoke()
    if( boundp('metRevMenuHan) != t
		menuLoad()
		);if
	hiDisplayFixedMenu(metRevMenuHan "left")
	)

;;------- drawRect ----------------------------------------------------------------------------------;;
;; what:        Procedure to draw a rectangle in layout
;; params:      bounding box points ( llx lly urx ury ), lay ( layer name ), and optional pur ( purpose, defaults to drawing )
;;-----------------------------------------------------------------------------------------------------;;

procedure( drawRect( llx lly urx ury lay @optional ( pur "drawing" ) )
    cvId = geGetEditCellView(getCurrentWindow()) 	; get window number and id for edit
	topCv = geGetTopLevelCellView() 			    ; get top view cell name				
	dbCreateRect(
		cvId
		list(lay pur)
		list( list( llx lly ) list( urx ury ) )
		) 
	)

;;------- moveTo ----------------------------------------------------------------------------------;;
;; what:        Procedure to move selected objects to new position base on given point
;; params:      xPos ( new x position ) , yPos ( new y position )
;;-----------------------------------------------------------------------------------------------------;;

procedure( moveTo( xPos yPos )
    cvId = geGetEditCellView(getCurrentWindow())
	selObjs = geGetSelSet()
	let( ( xPosP yPosP bbx bby xNew yNew xRef yRef inSw negSw )
		if( xPos == nil
			then
			xPosP = 0
			else
			xPosP = xPos	
			)
		if( yPos == nil
			then
			yPosP = 0
			else
			yPosP = yPos
			)
		xRef = 0
		yRef = 0
		inSw = 0
		negSw = 0
		foreach( curObj selObjs
			curBbox = curObj~>bBox
			bbx = car( car( curBbox ))
			bby = car( cdr( car( curBbox ) ) )
			xNew = xPosP-bbx
			yNew = yPosP-bby
			if( inSw == 0
				then
				xRef = xNew
				yRef = yNew
				inSw = 1
				else
				if( xNew > xRef
					xRef = xNew
					)
				if( yNew > yRef
					yRef = yNew
					)
				)
			)
		if( xPos == nil
			xRef = 0
			)
		if( yPos == nil
			yRef = 0
			)
		foreach( curObj selObjs
			dbMoveFig(
				curObj
				cvId
				list( xRef:yRef "R0" 1.0 ) 
				)
			)
		)
	)

;;------- copyLay ----------------------------------------------------------------------------------;;
;; what:        Procedure to copy figure into a new layer and purpose with possible offset
;; params:      xOff ( x offset ) , yOff ( y offset ), newLay ( new Layer ) , optional newPur defaults to original ( new purpose )
;;-----------------------------------------------------------------------------------------------------;;

procedure( copyLay( xOff yOff newLay @optional ( newPur nil ) )
    cvId = geGetEditCellView(getCurrentWindow())
	selObjs = geGetSelSet()
	foreach( curObj selObjs
		if( newPur == nil 
			then
			oldPur = curObj~>purpose
			else
			oldPur = newPur
			)
		newFig = dbCopyFig(
			curObj
			cvId
			list( xOff:yOff "R0" 1.0 ) 
			)
		newFig~>layerName = newLay
		newFig~>purpose = oldPur
		)
	)

