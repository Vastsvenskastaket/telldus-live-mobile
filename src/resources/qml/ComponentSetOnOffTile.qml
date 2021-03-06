import QtQuick 2.0
import Telldus 1.0
import Tui 0.1

Item {
	id: onOffTile
	property var deviceState: device.state
	property var dimHandleValue: Math.round(100 - Math.round(dimHandle.y / (dimArea.height - dimHandle.height) * 100))

	onDimHandleValueChanged: {
		overlayDimmer.dimValue = dimHandleValue
	}

	anchors.fill: parent
	focus: true

	Component.onCompleted: {
		tile.showBorder = true;
	}

	Keys.onPressed: {
		if (properties.ui.supportsKeys) {
			if (event.key == Qt.Key_Enter) {
				if (deviceState == 1 || deviceState == 16) {
					device.turnOff();
				} else {
					device.turnOn();
				}
				event.accepted = true;
			}
		}
	}

	Item {
		id: buttonContainer
		anchors.fill: parent

		Rectangle {
			id: onButtonBackgroundSquarer1
			width: onButton.width / 2
			anchors.top: onButton.top
			anchors.left: onButton.left
			anchors.bottom: onButton.bottom
			color: onButton.color
		}
		Rectangle {
			id: onButtonBackgroundSquarer2
			visible: tile.hasNameInTile
			height: onButton.height / 2
			anchors.left: onButton.left
			anchors.right: onButton.right
			anchors.bottom: onButton.bottom
			color: onButton.color
		}
		Rectangle {
			id: onButton
			height: parent.height
			anchors.right: parent.right
			anchors.left: tileSeperator.right
			color: "#DDDDDD"
			radius: tileCard.radius
			Text {
				id: onButtonText
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				color: "#BDBDBD"
				font.pixelSize: onButton.height < onButton.width ? parent.height * 0.4 : parent.height * 0.2
				text: qsTranslate("", "On")
			}
			ButtonMouseArea {
				id: onMouseArea
				anchors.fill: parent
				drag.target: dimHandle
				drag.axis: Drag.XandYAxis
				drag.minimumX: 0
				drag.maximumX: 0
				drag.minimumY: 0
				drag.maximumY: dimArea.height - dimHandle.height
				onPressed: {
					pressAndHoldTimer.start();
				}
				onReleased: buttonReleased("onMouseArea")
			}
		}

		Rectangle {
			id: tileSeperator
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.horizontalCenter: parent.horizontalCenter
			width: 1 * SCALEFACTOR
			color: "#BDBDBD"
		}

		Rectangle {
			id: offButtonBackgroundSquarer1
			width: offButton.width / 2
			anchors.top: offButton.top
			anchors.right: offButton.right
			anchors.bottom: offButton.bottom
			color: offButton.color
		}
		Rectangle {
			id: offButtonBackgroundSquarer2
			visible: tile.hasNameInTile
			height: offButton.height / 2
			anchors.left: offButton.left
			anchors.right: offButton.right
			anchors.bottom: offButton.bottom
			color: offButton.color
		}
		Rectangle {
			id: offButton
			height: parent.height
			anchors.left: parent.left
			anchors.right: tileSeperator.left
			color: "#EAEAEA"
			radius: tileCard.radius
			Text {
				id: offButtonText
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				color: "#BDBDBD"
				font.pixelSize: offButton.height < offButton.width ? parent.height * 0.4 : parent.height * 0.2
				text: qsTranslate("", "Off")
			}
			ButtonMouseArea {
				id: offMouseArea
				anchors.fill: parent
				drag.target: dimHandle
				drag.axis: Drag.XandYAxis
				drag.minimumX: 0
				drag.maximumX: 0
				drag.minimumY: 0
				drag.maximumY: dimArea.height - dimHandle.height
				onPressed: {
					pressAndHoldTimer.start();
				}
				onReleased: buttonReleased("offMouseArea")
			}
		}
	}

	Item {
		id: dimArea
		anchors.fill: parent
		visible: !((methods & 16) == 0)
		Rectangle {
			id: dimHandle
			anchors.horizontalCenter: parent.horizontalCenter
			height: Units.dp(12)
			width: Units.dp(24)
			radius: height
			y: (dimArea.height - dimHandle.height) - ((device.stateValue / 255) * (dimArea.height - dimHandle.height))
			color: Qt.hsla(0.0, 0.0, 0.75, 1)
			Behavior on y {
				NumberAnimation { duration: 150 }
			}
			Rectangle {
				anchors.centerIn: parent
				height: Units.dp(10)
				width: Units.dp(22)
				radius: dimHandle.radius
				color: "#FFFFFF"
			}
			Text {
				id: dimmerValueText
				anchors.centerIn: parent
				font.pixelSize: Units.dp(8)
				text: onOffTile.dimHandleValue == 0 ? qsTranslate("", "Off") : (onOffTile.dimHandleValue == 100 ? qsTranslate("", "On") : onOffTile.dimHandleValue)
				color: Qt.hsla(0.0, 0.0, 0.65, 1)
			}
		}
	}
	ProgressCircle {
		id: progressCircle
		visible: device.changesInQueue > 0
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.topMargin: Units.dp(4)
		anchors.leftMargin: Units.dp(4)
		anchors.rightMargin: Units.dp(4)
		height: Units.dp(10)
	}
	Timer {
		id: pressAndHoldTimer
		interval: 250
		running: false
		repeat: false
		onTriggered: {
			onMouseArea.canceled();
			offMouseArea.canceled();
			if (!((methods & 16) == 0)) {
				overlayDimmer.device = device;
			}
		}
	}

	function buttonReleased(sender) {
		var ignoreButtonPresses = false
		if (overlayDimmer.device != '') {
			ignoreButtonPresses = true
		}
		pressAndHoldTimer.stop();
		overlayDimmer.device = ''
		var maxY = dimArea.height - dimHandle.height;
		var value = 255 - Math.round(dimHandle.y / maxY * 255);
		if (value == device.stateValue) {
			if (!ignoreButtonPresses) {
				if (sender == "offMouseArea") {
					device.turnOff()
				} else if (sender == "onMouseArea") {
					device.turnOn()
				}
			}
		} else {
			if (value == 0) {
				device.turnOff();
			} else if (value == 255) {
				device.turnOn();
			} else {
				device.dim(value);
			}
		}
	}

	states: [
		State {
			name: ''
			PropertyChanges {
				target: tile
				hue: 0.08
				saturation: 0.99
				lightness: 0.45
			}
		},
		State {
			name: 'on_or_dimmed'
			when: deviceState == 1 || deviceState == 16
			PropertyChanges {
				target: tile
				hue: 0.08
				saturation: 0.99
				lightness: 0.45
			}
			PropertyChanges {
				target: onButton
				color: "#FAFAFA"
			}
			PropertyChanges {
				target: offButton
				color: "#EEEEEE"
			}
			PropertyChanges {
				target: onButtonText
				color: "#2E7D32"
			}
			PropertyChanges {
				target: offButtonText
				color: "#9E9E9E"
			}
		},
		State {
			name: 'off'
			when: deviceState == 2
			PropertyChanges {
				target: tile
				hue: 0.0
				saturation: 0.0
				lightness: 0.75
			}
			PropertyChanges {
				target: onButton
				color: "#EEEEEE"
			}
			PropertyChanges {
				target: offButton
				color: "#FAFAFA"
			}
			PropertyChanges {
				target: onButtonText
				color: "#9E9E9E"
			}
			PropertyChanges {
				target: offButtonText
				color: "#C62828"
			}
		}
	]
}
