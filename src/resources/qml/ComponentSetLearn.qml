import QtQuick 2.0
import Telldus 1.0

Item {
	Component.onCompleted: {
		tile.showBorder = true;
		tile.hue = 0.08
		tile.saturation = 0.99
		tile.lightness = 0.45
	}
	Text {
		id: text
		smooth: true
		anchors.centerIn: parent
		color: properties.theme.colors.telldusOrange
		font.pixelSize: 32 * SCALEFACTOR
		font.weight: Font.Bold
		style: Text.Raised
		styleColor: "white"
		text: "Learn"
	}
	MouseArea {
		id: buttonMouseArea
		preventStealing: true
		anchors.fill: parent
		onPressed: {
			bellIcon.opacity = 0.85
			tileWhite.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
		}
		onReleased: {
			bellIcon.opacity = 1
			tileWhite.color = "#ffffff"
		}
		onClicked: {
			device.learn()
		}
	}
}
