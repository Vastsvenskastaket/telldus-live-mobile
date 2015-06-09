import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import "../scripts/DB.js" as DB
import "../scripts/Device.js" as Device
import "../scripts/Sensor.js" as Sensor

Rectangle {
	id: screen
	color: "#dceaf6"

	Component.onCompleted: {
		Device.setupCache(deviceModelController, DB.db)
		Sensor.setupCache(sensorModel, DB.db)
	}

	Loader {
		id: loader_mainInterface
		opacity: telldusLive.isAuthorized ? 1 : 0
		Behavior on opacity { NumberAnimation { duration: 100 } }
		source: opacity > 0  ? "MainInterface.qml" : ''
		anchors.fill: parent
	}
	Loader {
		id: loader_loginScreen
		opacity: telldusLive.isAuthorized ? 0 : 1
		Behavior on opacity { NumberAnimation { duration: 100 } }
		source: opacity > 0  ? "LoginScreen.qml" : ''
		anchors.fill: parent
	}
}
