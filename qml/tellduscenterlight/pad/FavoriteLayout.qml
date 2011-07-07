import Qt 4.7
import "../mainscripts.js" as MainScripts
import "favoritelayoutscripts.js" as FavoriteLayoutScripts

Rectangle {
   Rectangle{
	   id: tabSelection
	   color: "darkgray"
	   height: parent.height
	   width: MainScripts.TOOLBARWIDTH  //TODO
   }
   Rectangle{
	   id: tabArea
	   color: "gray"
	   anchors.left: tabSelection.right
	   anchors.top: tabSelection.top
	   height: parent.height
	   width: parent.width - tabSelection.width
	   //button for each tab
	   //then another button för adding new tab, and possibly upload image (menu options), or option for this in lower right corner or something

	   //clickable components...
   }

   Component.onCompleted: {
	   FavoriteLayoutScripts.fillVisualObjects()
   }
}