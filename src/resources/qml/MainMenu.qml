import QtQuick 2.0

Item {
	id: componentRoot
	property int activePage: 0
	anchors.fill: parent

	Column {
		id: buttonRow
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: parent.height
		Item {
			width: parent.width
			height: 64 * SCALEFACTOR
			Text {
				id: dashboardButton
				color: "#ffffff"
				font.pixelSize: 24 * SCALEFACTOR
				text: "Dashboard"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(0)
			}
		}
		Item {
			width: parent.width
			height: 64 * SCALEFACTOR
			Text {
				id: deviceButton
				color: "#ffffff"
				font.pixelSize: 24 * SCALEFACTOR
				text: "Devices"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(1)
			}
		}
		Item {
			width: parent.width
			height: 64 * SCALEFACTOR
			Text {
				id: sensorButton
				color: "#ffffff"
				font.pixelSize: 24 * SCALEFACTOR
				text: "Sensors"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(2)
			}
		}
		Item {
			width: parent.width
			height: 64 * SCALEFACTOR
			Text {
				id: schedulerButton
				color: "#ffffff"
				font.pixelSize: 24 * SCALEFACTOR
				text: "Scheduler"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(3)
			}
		}
		Item {
			width: parent.width
			height: 64 * SCALEFACTOR
			Text {
				id: settingsButton
				color: "#ffffff"
				font.pixelSize: 24 * SCALEFACTOR
				text: "Settings"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(4)
			}
		}
		Item {
			visible: false
			width: parent.width
			height: 64 * SCALEFACTOR
			Text {
				id: debugButton
				color: "#ffffff"
				font.pixelSize: 24 * SCALEFACTOR
				text: "Debug"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(5)
			}
		}
	}

	states: [
		State {
			when: activePage == 0
			//PropertyChanges { target: dashboardButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 1
			//PropertyChanges { target: deviceButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 2
			//PropertyChanges { target: sensorButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 3
			//PropertyChanges { target: schedulerButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 4
			//PropertyChanges { target: settingsButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 5
			//PropertyChanges { target: settingsButtonBackground; opacity: 1 }
		}
	]

	transitions: [
		Transition {
			NumberAnimation { properties: "opacity"; duration: 100 }
		}
	]

	function changePage(pageId) {
		mainInterface.setActivePage(pageId);
		mainInterface.onMenu();
	}
}
