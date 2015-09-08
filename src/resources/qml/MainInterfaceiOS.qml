import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: mainInterface
	property variant screenNames: ['/dashboard', '/devices', '/sensors', '/scheduler', '/settings', '/debug']
	property bool menuViewVisible: false
	color: "#404040";
	Rectangle {
		id: menuView
		anchors.top: parent.top
		anchors.topMargin: Qt.platform.os == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		width: Math.min((screen.showHeaderAtTop ? mainInterface.width : mainInterface.height) * 0.8, Units.dp(288))
		color: "#404040";

		Item {
			id: menuUserDetails
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			height: Units.dp(72)
			Rectangle {
				id: menuUserDetailsDivider
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				anchors.bottomMargin: Units.dp(20)
				height: Units.dp(1)
				color: "#BDBDBD"
			}
			Rectangle {
				id: menuUserDetailsInitialsBox
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(12)
				anchors.verticalCenter: parent.verticalCenter
				color: properties.theme.colors.telldusOrange
				width: Units.dp(40)
				height: width
				radius: Units.dp(4)
				Text {
					id: menuUserDetailsInitials
					anchors.centerIn: parent
					text: user.firstname.charAt(0) + user.lastname.charAt(0)
					font.pixelSize: Units.dp(20)
					color: "#ffffff"
				}

			}
			Text {
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
				anchors.verticalCenter: parent.verticalCenter
				text: user.firstname + " " + user.lastname
				width: parent.width
				wrapMode: Text.WordWrap
				font.pixelSize: Units.dp(16)
				color: "#ffffff"
			}
		}
		MainMenu {
			id: mainMenu
			anchors.top: menuUserDetails.bottom
			anchors.left: parent.left
			anchors.right: parent.right
		}
	}

	View {
		id: mainView
		anchors.fill: parent
		elevation: 4
		tintColor: properties.theme.colors.dashboardBackground
		transform: Translate {
			id: mainViewTranslate
			x: 0
			Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
		}
		Rectangle {
			id: mainViewOffset
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			color: properties.theme.colors.telldusBlue
			height: Qt.platform.os == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
			z: 999999999999
		}
		TabPage {
			component: "DashboardPage.qml"
			pageId: 0
			currentPage: mainMenu.activePage
			visible: mainMenu.activePage == 0
		}

		TabPage {
			component: "DevicePage.qml"
			pageId: 1
			currentPage: mainMenu.activePage
			visible: mainMenu.activePage == 1
		}
		TabPage {
			component: "SensorPage.qml"
			pageId: 2
			currentPage: mainMenu.activePage
			visible: mainMenu.activePage == 2
		}
		TabPage {
			component: "SchedulerPage.qml"
			pageId: 3
			currentPage: mainMenu.activePage
			visible: mainMenu.activePage == 3
		}
		TabPage {
			component: "SettingsPage.qml"
			pageId: 4
			currentPage: mainMenu.activePage
			visible: mainMenu.activePage == 4
		}
		TabPage {
			component: "DebugPage.qml"
			pageId: 5
			currentPage: mainMenu.activePage
			visible: mainMenu.activePage == 5
		}
		SwipeArea {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: mainInterface.menuViewVisible ? parent.width : Units.dp(16)
			onMove: {
				console.log("onMove")
			}
			onSwipe: {
				switch (direction) {
				case "left":
					mainInterface.swipeLeft()
					break
				case "right":
					mainInterface.swipeRight()
					break
				}
			}
			onCanceled: {
				console.log("onCanceled")
			}
			onClicked: {
				if (mainInterface.menuViewVisible) {
					console.log("onClicked")
					swipeBoth()
				}
			}
		}
	}

	/* this functions toggles the menu and starts the animation */
	function onMenu()
	{
		console.log("onMenu");
		mainViewTranslate.x = mainInterface.menuViewVisible ? 0 : menuView.width;
		mainInterface.menuViewVisible = !mainInterface.menuViewVisible;
	}

	function setActivePage(pageId) {
		mainMenu.activePage = pageId;
		dev.logScreenView(screenNames[pageId]);
	}

	function swipeLeft() {
		console.log("swipeLeft");
		swipeBoth();
	}

	function swipeRight() {
		console.log("swipeRight");
		if (mainInterface.menuViewVisible == false) {
			onMenu();
		}
	}

	function swipeBoth() {
		mainViewTranslate.x = 0;
		mainInterface.menuViewVisible = false;
	}

}