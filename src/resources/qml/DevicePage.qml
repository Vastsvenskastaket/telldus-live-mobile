import QtGraphicalEffects 1.0
import QtQuick 2.4
import Telldus 1.0
import Tui 0.1

Item {
	id: devicePage
	property bool showEditButtons: false
	property var pageTitle: "Devices"

	Component {
		id: deviceDelegate
		FocusScope {
			height: wrapper.height
			width: list.width
			/*Keys.onPressed: {
				if (properties.ui.supportsKeys) {
					if (event.key == Qt.Key_Right) {
						devicePage.state = 'showDevice';
						showDevice.selected = device;
						showDevice.focus = true;
						event.accepted = true;
					}
					if (event.key == Qt.Key_MediaPlay) {
						showEditButtons = !showEditButtons
						event.accepted = true;
					}
				}
			}*/
			Rectangle {
				color: "#EEEEEE"
				height: parent.height
				width: parent.width

				Rectangle {
					id: wrapper
					property Device dev: device
					state: showEditButtons ? 'showEditButtons' : ''
					width: list.width
					height: Units.dp(72)
					clip: false
					color: index ==  list.currentIndex && properties.ui.supportsKeys ? "#f5f5f5" : "#ffffff"
					z: model.index
					anchors.left: parent.left
					anchors.leftMargin: 0
					anchors.top: parent.top
					ButtonSet {
						id: buttons
						device: wrapper.dev
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: Units.dp(16)
						height: Units.dp(40)
						width: Units.dp(100)
					}
					Column {
						id: nameCol
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: buttons.right
						anchors.leftMargin: Units.dp(16)
						anchors.right: arrow.left
						anchors.rightMargin: Units.dp(16)
						Text {
							color: properties.theme.colors.telldusBlue
							width: parent.width
							font.pixelSize: Units.dp(16)
							text: device.name
							elide: Text.ElideRight
						}
					}
					MouseArea {
						id: mouseArea
						width: parent.height
						anchors.top: parent.top
						anchors.right: parent.right
						anchors.bottom: parent.bottom
						onClicked: {
							overlayPage.title = device.name
							overlayPage.icon = 'devices'
							overlayPage.source = Qt.resolvedUrl("DeviceDetails.qml");
							overlayPage.childObject = device
						}
					}
					Item {
						id: arrow
						anchors.right: wrapper.right
						anchors.rightMargin: Units.dp(16)
						anchors.verticalCenter: parent.verticalCenter
						height: Units.dp(24)
						width: height
						Image {
							id: arrowImage
							anchors.fill: parent
							source: "image://icons/settings/#BDBDBD"
							asynchronous: true
							smooth: true
							fillMode: Image.PreserveAspectCrop
							sourceSize.width: width * 2
							sourceSize.height: height * 2
						}
					}
					MouseArea {
						anchors.fill: parent
						enabled: showEditButtons
						onClicked: {
							devicePage.showEditButtons = false
						}
					}
					states: [
						State {
							name: 'showEditButtons'
							PropertyChanges { target: wrapper; anchors.leftMargin: Units.dp(48) * (underMenu.children.length - 1) }
						}
					]
					transitions: [
						Transition {
							to: 'showEditButtons'
							reversible: true
							PropertyAnimation { property: "anchors.leftMargin";  duration: 300; easing.type: Easing.InOutQuad }
						}
					]
				}
				Rectangle {
					id: underMenu
					anchors.right: wrapper.left
					anchors.top: parent.top
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					color: "#F5F5F5"
					clip: true
					Item {
						id: favouriteButton
						height: parent.height
						width: Units.dp(48)
						anchors.left: parent.left
						anchors.top: parent.top
						Image {
							id: favouriteButtonImage
							anchors.centerIn: parent
							height: Units.dp(30)
							width: height
							source: "image://icons/favourite/" + properties.theme.colors.telldusOrange
							asynchronous: true
							smooth: true
							fillMode: Image.PreserveAspectFit
							sourceSize.width: width * 2
							sourceSize.height: height * 2
							opacity: device.isFavorite ? 1 : 0.2
						}
						MouseArea {
							anchors.fill: parent
							onClicked: device.isFavorite = !device.isFavorite
						}
					}
					LinearGradient {
						anchors.top: parent.top
						anchors.right: parent.right
						anchors.bottom: parent.bottom
						width: Units.dp(3)
						start: Qt.point(0, 0)
						end: Qt.point(Units.dp(3), 0)
						gradient: Gradient {
							GradientStop { position: 0.0; color: "#00999999" }
							GradientStop { position: 1.0; color: "#80999999" }
						}
					}
				}
			}
		}
	}
	Component {
		id: deviceListHeader
		Item {
			height: Units.dp(60)
			width: parent.width
			y: -list.contentY - height

			property bool refresh: state == "pulled" ? true : false

			Rectangle {
				id: deviceListHeaderBorder
				height: Units.dp(1)
				color: "#E0E0E0"
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
			}

			Item {
				id: arrow
				anchors.fill: parent
				Image {
					id: arrowImage
					visible: !refreshTimer.running
					anchors.centerIn: parent
					height: parent.height * 0.5
					width: height
					source: "image://icons/refreshArrow/#999999"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
				Image {
					id: arrowImageRunning
					visible: closeTimer.running
					anchors.centerIn: parent
					height: parent.height * 0.5
					width: height
					source: "image://icons/refresh/#999999"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
					transformOrigin: Item.Center
					RotationAnimation on rotation {
						loops: Animation.Infinite
						from: 0
						to: 360
						duration: 1000
						running: closeTimer.running
					}
				}
				transformOrigin: Item.Center
				Behavior on rotation { NumberAnimation { duration: 200 } }
			}
			Text {
				anchors.centerIn: parent
				visible: refreshTimer.running && !closeTimer.running
				color: properties.theme.colors.telldusBlue
				font.pixelSize: Units.dp(12)
				text: qsTranslate("misc", "You can refresh once every 10 seconds.")
				elide: Text.ElideRight
			}
			states: [
				State {
					name: "base"; when: list.contentY >= -Units.dp(140)
					PropertyChanges { target: arrow; rotation: 180 }
				},
				State {
					name: "pulled"; when: list.contentY < -Units.dp(140)
					PropertyChanges { target: arrow; rotation: 0 }
				}
			]
		}
	}
	Component {
		id: deviceListSectionHeader
		Rectangle {
			width: parent.width
			height: Units.dp(27)
			color: properties.theme.colors.dashboardBackground

			Rectangle {
				height: Units.dp(26)
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.top: parent.top
				color: "#FAFAFA"

				Text {
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(20)
					text: section
					font.bold: true
					font.pixelSize: Units.dp(14)
					color: "#999999"
				}

			}
		}
	}
	Rectangle {
		id: listEmptyView
		anchors.fill: parent
		visible : list.count == 0
		color: "#F5F5F5"
		onVisibleChanged: {
			if (list.count == 0) {
				refreshTimer.stop()
				closeTimer.stop()
			}
		}

		Text {
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			anchors.leftMargin: Units.dp(20)
			anchors.rightMargin:Units.dp(20)
			color: properties.theme.colors.telldusBlue
			font.pixelSize: Units.dp(16)
			wrapMode: Text.Wrap
			horizontalAlignment: Text.AlignHCenter
			text: refreshTimer.running ? qsTranslate("messages", "Refreshing...\n\nyou can only refresh once every 10 seconds!") : qsTranslate("messages", "No devices have been added yet, please go to http://live.telldus.com to add them.\n\nThen tap here to refresh!")
		}
		MouseArea {
			anchors.fill: parent
			enabled: listEmptyView.visible && !refreshTimer.running
			onReleased: {
				refreshTimer.start();
				deviceModelController.authorizationChanged();
			}
		}
	}
	Item {
		id: listPage
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		width: parent.width
		visible : list.count > 0
		ListView {
			id: list
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.topMargin: closeTimer.running ? Units.dp(4) : -headerItem.height
			model: deviceListSortFilterModel
			delegate: deviceDelegate
			maximumFlickVelocity: Units.dp(1500)
			spacing: Units.dp(1)
			focus: true
			header: deviceListHeader
			section.property: "device.clientName"
			section.criteria: ViewSection.FullString
			section.delegate: deviceListSectionHeader
			pressDelay: 100
			onDragEnded: {
				if (headerItem.refresh && !refreshTimer.running) {
					console.log("Refreshing DeviceModel")
					deviceModelController.authorizationChanged()
					refreshTimer.start()
					closeTimer.start()
				}
			}
		}
		Timer {
			id: closeTimer
			interval: 1000
			running: false
			repeat: false
		}
		Timer {
			id: refreshTimer
			interval: 10000
			running: false
			repeat: false
		}
	}

	function onBackClicked() {
		if (devicePage.showEditButtons) {
			devicePage.showEditButtons = false;
		} else {
			mainInterface.setActivePage(0);
		}
	}

	function onEditClicked() {
		devicePage.showEditButtons = !devicePage.showEditButtons;
	}

	function updateHeader() {
		header.title =  qsTranslate("pages", "Devices");
		header.editButtonVisible = true;
		header.backVisible = false;
	}


}
