import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

PanelWindow {
	id: musicPanel
	screen: Quickshell.screens.length > 0 ? (root.focusedScreen ?? Quickshell.screens[0]) : undefined
	visible: true
	exclusionMode: ExclusionMode.Ignore
	anchors {
		top: true
		left: true
		right: true
	}
	margins {
		top: root.musicVisible ? 50 : -350
		left: 0
		right: 0
	}
	implicitWidth: 400
	implicitHeight: musicPanel.playerDropdownOpen
		? 188 + 8 + 28 + 1 + 34 + (musicPanel.availablePlayers.length * 34) + 16
		: 188
	color: "transparent"
	focusable: true
	WlrLayershell.keyboardFocus: root.musicVisible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
	Behavior on margins.top {
		NumberAnimation {
			duration: 300
			easing.type: Easing.OutCubic
		}
	}
	Behavior on implicitHeight {
		NumberAnimation {
			duration: 200
			easing.type: Easing.OutCubic
		}
	}
	property string configPath: root.configPath
	property string playerStatus: "Stopped"
	property string trackTitle: ""
	property string trackArtist: ""
	property string trackArtUrl: ""
	property real position: 0
	property real lastPosition: 0
	property real length: 0
	property bool hasTrack: playerStatus === "Playing" || playerStatus === "Paused"
	property string activePlayer: "%any"
	property string resolvedPlayer: "%any"
	property var availablePlayers: []
	property bool playerDropdownOpen: false

	function formatTime(seconds) {
		var mins = Math.floor(seconds / 60)
		var secs = Math.floor(seconds % 60)
		return mins + ":" + (secs < 10 ? "0" : "") + secs
	}
	function playerDisplayName(player) {
		if (!player || player === "%any") return "Auto"
		var name = player
		var dotIdx = name.indexOf(".")
		if (dotIdx > 0) name = name.substring(0, dotIdx)
		return name.charAt(0).toUpperCase() + name.slice(1)
	}
	function playerIcon(player) {
		if (!player || player === "%any") return "󰝚"
		var n = player.toLowerCase()
		if (n.indexOf("firefox") >= 0 || n.indexOf("mozilla") >= 0) return "󰈹"
		if (n.indexOf("chromium") >= 0 || n.indexOf("chrome") >= 0) return ""
		if (n.indexOf("spotify") >= 0) return "󰓇"
		if (n.indexOf("mpv") >= 0) return "󰐌"
		if (n.indexOf("vlc") >= 0) return "󰕼"
		if (n.indexOf("rhythmbox") >= 0 || n.indexOf("clementine") >= 0) return "󰝚"
		if (n.indexOf("cmus") >= 0 || n.indexOf("ncmpcpp") >= 0 || n.indexOf("mpd") >= 0) return "󰎆"
		if (n.indexOf("youtube") >= 0) return "󰗃"
		return "󰝚"
	}
	function refreshPlayers() {
		if (!playerListProc.running) playerListProc.running = true
	}
	Timer {
		id: playerRefreshTimer
		interval: 3000
		running: root.musicVisible
		repeat: true
		triggeredOnStart: true
		onTriggered: musicPanel.refreshPlayers()
	}
	Process {
		id: playerListProc
		command: ["bash", "-c", "playerctl --list-all 2>/dev/null | tr '\\n' '|' | sed 's/|$//'"]
		stdout: SplitParser {
			onRead: data => {
				var line = data.trim()
				if (line.length === 0) {
					musicPanel.availablePlayers = []
					return
				}
				var players = line.split("|").filter(function(p) { return p.length > 0 })
				musicPanel.availablePlayers = players
				if (musicPanel.activePlayer !== "%any") {
					var found = players.indexOf(musicPanel.activePlayer) >= 0
					if (!found) musicPanel.activePlayer = "%any"
				}
			}
		}
	}
	Item {
		anchors.fill: parent
		focus: root.musicVisible
		Keys.onPressed: function(event) {
			if (event.key === Qt.Key_Escape) {
				if (musicPanel.playerDropdownOpen) {
					musicPanel.playerDropdownOpen = false
				} else {
					root.musicVisible = false
				}
				event.accepted = true
			} else if (event.key === Qt.Key_Space && !musicPanel.playerDropdownOpen) {
				if (!playPauseProc.running) playPauseProc.running = true
				event.accepted = true
			} else if (event.key === Qt.Key_N && !musicPanel.playerDropdownOpen) {
				if (!nextProc.running) nextProc.running = true
				event.accepted = true
			} else if (event.key === Qt.Key_P && !musicPanel.playerDropdownOpen) {
				if (!prevProc.running) prevProc.running = true
				event.accepted = true
			}
		}
		Column {
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 8
			Rectangle {
				width: 400
				height: 180
				color: Qt.rgba(root.walBackground.r, root.walBackground.g, root.walBackground.b, 0.95)
				border.width: 1
    border.color: Qt.rgba(root.walColor5.r, root.walColor5.g, root.walColor5.b, 0.45)
				radius: 15
				clip: true
				RowLayout {
					anchors.fill: parent
					anchors.margins: 15
					spacing: 15
					ColumnLayout {
						Layout.fillWidth: true
						Layout.fillHeight: true
						Layout.minimumWidth: 180
						spacing: 6
						RowLayout {
							Layout.fillWidth: true
							spacing: 6
							Text {
								text: musicPanel.trackTitle || "Nothing is playing"
								color: root.walColor5
								font.pixelSize: 15
								font.bold: true
								font.family: root.fontMono
								Layout.fillWidth: true
								elide: Text.ElideRight
							}
							Rectangle {
								width: playerBtnRow.width + 14
								height: 22
								radius: 7
								color: playerBtnMa.containsMouse || musicPanel.playerDropdownOpen
									? Qt.rgba(root.walColor5.r, root.walColor5.g, root.walColor5.b, 0.25)
									: Qt.rgba(0, 0, 0, 0.35)
								border.width: musicPanel.playerDropdownOpen ? 1 : 0
								border.color: Qt.rgba(root.walColor5.r, root.walColor5.g, root.walColor5.b, 0.5)
								Behavior on color {
									ColorAnimation { duration: 150 }
								}
								Row {
									id: playerBtnRow
									anchors.centerIn: parent
									spacing: 5
									Text {
										text: musicPanel.playerIcon(musicPanel.activePlayer)
										color: root.walColor5
										font.pixelSize: 11
										font.family: root.fontMono
										anchors.verticalCenter: parent.verticalCenter
									}
									Text {
										text: musicPanel.playerDisplayName(musicPanel.activePlayer)
										color: root.walColor5
										font.pixelSize: 10
										font.family: root.fontMono
										anchors.verticalCenter: parent.verticalCenter
									}
									Text {
										text: musicPanel.playerDropdownOpen ? "󰅃" : "󰅀"
										color: root.walColor5
										font.pixelSize: 9
										font.family: root.fontMono
										anchors.verticalCenter: parent.verticalCenter
									}
								}
								MouseArea {
									id: playerBtnMa
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: Qt.PointingHandCursor
									onClicked: {
										musicPanel.playerDropdownOpen = !musicPanel.playerDropdownOpen
										if (musicPanel.playerDropdownOpen) musicPanel.refreshPlayers()
									}
								}
							}
						}
						Text {
							text: musicPanel.trackArtist || ""
							color: root.walForeground
							font.pixelSize: 12
							font.family: root.fontMono
							opacity: 0.7
							Layout.fillWidth: true
							elide: Text.ElideRight
							visible: musicPanel.trackArtist !== ""
						}
						Item { Layout.fillHeight: true }
						RowLayout {
							Layout.fillWidth: true
							spacing: 8
							visible: musicPanel.hasTrack

							Text {
								text: musicPanel.formatTime(musicPanel.position)
								color: root.walColor8
								font.pixelSize: 10
								font.family: root.fontMono
							}
							Rectangle {
								Layout.fillWidth: true
								height: 4
								radius: 2
								color: Qt.rgba(0, 0, 0, 0.5)
								Rectangle {
									width: musicPanel.length > 0 ? parent.width * (musicPanel.position / musicPanel.length) : 0
									height: parent.height
									radius: 2
									color: root.walColor5
								}
								MouseArea {
									anchors.fill: parent
									cursorShape: Qt.PointingHandCursor
									onClicked: function(mouse) {
										if (musicPanel.length > 0 && !seekProc.running) {
											var seekPos = (mouse.x / parent.width) * musicPanel.length
											seekProc.command = ["playerctl", "--player=" + musicPanel.resolvedPlayer, "position", seekPos.toString()]
											seekProc.running = true
										}
									}
								}
							}
							Text {
								text: musicPanel.formatTime(musicPanel.length)
								color: root.walColor8
								font.pixelSize: 10
								font.family: root.fontMono
							}
						}
						Row {
							Layout.alignment: Qt.AlignHCenter
							spacing: 12
							opacity: musicPanel.hasTrack ? 1.0 : 0.5
							Rectangle {
								width: 32
								height: 32
								radius: 8
								color: prevMa.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent"
								Text {
									anchors.centerIn: parent
									text: "󰒮"
									color: root.walForeground
									font.pixelSize: 16
									font.family: root.fontMono
								}
								MouseArea {
									id: prevMa
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: Qt.PointingHandCursor
									onClicked: if (!prevProc.running) prevProc.running = true
								}
							}
							Rectangle {
								width: 40
								height: 40
								radius: 20
								color: root.walColor5
								Text {
									anchors.centerIn: parent
									text: musicPanel.playerStatus === "Playing" ? "󰏤" : "󰐊"
									color: root.walBackground
									font.pixelSize: 18
									font.family: root.fontMono
								}
								MouseArea {
									anchors.fill: parent
									cursorShape: Qt.PointingHandCursor
									onClicked: if (!playPauseProc.running) playPauseProc.running = true
								}
							}
							Rectangle {
								width: 32
								height: 32
								radius: 8
								color: nextMa.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent"
								Text {
									anchors.centerIn: parent
									text: "󰒭"
									color: root.walForeground
									font.pixelSize: 16
									font.family: root.fontMono
								}
								MouseArea {
									id: nextMa
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: Qt.PointingHandCursor
									onClicked: if (!nextProc.running) nextProc.running = true
								}
							}
						}
					}
					Item {
						Layout.preferredWidth: 160
						Layout.maximumWidth: 160
						Layout.fillHeight: true
						Item {
							id: artContainer
							anchors.centerIn: parent
							width: Math.min(parent.width, parent.height) - 4
							height: width
							Image {
								id: trackArtImage
								anchors.fill: parent
								source: musicPanel.trackArtUrl
								fillMode: Image.PreserveAspectCrop
								smooth: true
								asynchronous: true
								sourceSize: Qt.size(300, 300)
								visible: false
							}
							Rectangle {
								id: trackArtMask
								anchors.fill: parent
								radius: 12
								visible: false
							}
							OpacityMask {
								anchors.fill: trackArtImage
								source: trackArtImage
								maskSource: trackArtMask
								visible: musicPanel.trackArtUrl !== ""
							}
							Rectangle {
								anchors.fill: parent
								radius: 12
								visible: musicPanel.trackArtUrl === ""
								color: Qt.rgba(0, 0, 0, 0.4)
								border.width: 1
								border.color: Qt.rgba(1, 1, 1, 0.07)
								Text {
									anchors.centerIn: parent
									text: "󰝚"
									color: root.walColor8
									font.pixelSize: 32
									font.family: root.fontMono
									opacity: 0.5
								}
							}
						}
					}
				}
				Rectangle {
					id: playerDropdownCard
					width: 380
					anchors.horizontalCenter: parent.horizontalCenter
					height: visible ? (28 + 1 + 34 + (musicPanel.availablePlayers.length * 34) + 16) : 0
					radius: 12
					color: Qt.rgba(root.walBackground.r, root.walBackground.g, root.walBackground.b, 0.92)
					border.color: Qt.rgba(root.walColor5.r, root.walColor5.g, root.walColor5.b, 0.45)
					border.width: 1
					visible: musicPanel.playerDropdownOpen
					clip: true
					Item {
						id: pdHeader
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.margins: 8
						height: 28
						Text {
							anchors.left: parent.left
							anchors.verticalCenter: parent.verticalCenter
							anchors.leftMargin: 6
							text: "󰝚  Select Player"
							color: root.walColor5
							font.pixelSize: 11
							font.bold: true
							font.family: root.fontMono
						}
						Text {
							anchors.right: parent.right
							anchors.verticalCenter: parent.verticalCenter
							anchors.rightMargin: 6
							text: musicPanel.availablePlayers.length === 0 ? "No players" : musicPanel.availablePlayers.length + " found"
							color: root.walColor8
							font.pixelSize: 9
							font.family: root.fontMono
							opacity: 0.6
						}
					}
					Rectangle {
						id: pdDivider
						anchors.top: pdHeader.bottom
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.leftMargin: 8
						anchors.rightMargin: 8
						height: 1
						color: Qt.rgba(1,1,1,0.06)
					}
					Column {
						id: pdRows
						anchors.top: pdDivider.bottom
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.leftMargin: 8
						anchors.rightMargin: 8
						anchors.topMargin: 2
						spacing: 2
						Rectangle {
							width: parent.width
							height: 34
							radius: 8
							color: musicPanel.activePlayer === "%any"
								? Qt.rgba(root.walColor5.r, root.walColor5.g, root.walColor5.b, 0.18)
								: autoMa.containsMouse ? Qt.rgba(1,1,1,0.07) : "transparent"
							Behavior on color {
								ColorAnimation { duration: 120 }
							}
							Row {
								anchors.fill: parent
								anchors.leftMargin: 10
								anchors.rightMargin: 10
								spacing: 8
								Text {
									anchors.verticalCenter: parent.verticalCenter
									text: "󰝚"
									color: musicPanel.activePlayer === "%any" ? root.walColor5 : root.walColor8
									font.pixelSize: 14
									font.family: root.fontMono
								}
								Text {
									anchors.verticalCenter: parent.verticalCenter
									text: "Auto"
									color: musicPanel.activePlayer === "%any" ? root.walColor5 : root.walForeground
									font.pixelSize: 12
									font.bold: musicPanel.activePlayer === "%any"
									font.family: root.fontMono
									width: 120
								}
								Text {
									anchors.verticalCenter: parent.verticalCenter
									text: "any active"
									color: root.walColor8
									font.pixelSize: 9
									font.family: root.fontMono
									opacity: 0.5
								}
								Text {
									anchors.verticalCenter: parent.verticalCenter
									visible: musicPanel.activePlayer === "%any"
									text: "󰄬"
									color: root.walColor5
									font.pixelSize: 12
									font.family: root.fontMono
								}
							}
							MouseArea {
								id: autoMa
								anchors.fill: parent
								hoverEnabled: true
								cursorShape: Qt.PointingHandCursor
								onClicked: {
									musicPanel.activePlayer = "%any"
									musicPanel.playerDropdownOpen = false
									if (!musicStatusProc.running) musicStatusProc.running = true
								}
							}
						}
						Repeater {
							model: musicPanel.availablePlayers
							Rectangle {
								width: pdRows.width
								height: 34
								radius: 8
								color: musicPanel.activePlayer === modelData
									? Qt.rgba(root.walColor5.r, root.walColor5.g, root.walColor5.b, 0.18)
									: playerItemMa.containsMouse ? Qt.rgba(1,1,1,0.07) : "transparent"
								Behavior on color {
									ColorAnimation { duration: 120 }
								}
								Row {
									anchors.fill: parent
									anchors.leftMargin: 10
									anchors.rightMargin: 10
									spacing: 8
									Text {
										anchors.verticalCenter: parent.verticalCenter
										text: musicPanel.playerIcon(modelData)
										color: musicPanel.activePlayer === modelData ? root.walColor5 : root.walColor8
										font.pixelSize: 14
										font.family: root.fontMono
									}
									Text {
										anchors.verticalCenter: parent.verticalCenter
										text: musicPanel.playerDisplayName(modelData)
										color: musicPanel.activePlayer === modelData ? root.walColor5 : root.walForeground
										font.pixelSize: 12
										font.bold: musicPanel.activePlayer === modelData
										font.family: root.fontMono
										width: 200
										elide: Text.ElideRight
									}
									Text {
										anchors.verticalCenter: parent.verticalCenter
										visible: musicPanel.activePlayer === modelData
										text: "󰄬"
										color: root.walColor5
										font.pixelSize: 12
										font.family: root.fontMono
									}
								}
								MouseArea {
									id: playerItemMa
									anchors.fill: parent
									hoverEnabled: true
									cursorShape: Qt.PointingHandCursor
									onClicked: {
										musicPanel.activePlayer = modelData
										musicPanel.playerDropdownOpen = false
										if (!musicStatusProc.running) musicStatusProc.running = true
									}
								}
							}
						}
					}
				}
			}
		}
		Connections {
			target: root
			function onMusicVisibleChanged() {
				if (!root.musicVisible) {
					musicPanel.playerDropdownOpen = false
				}
			}
		}

		Timer {
			id: playerPollTimer
			interval: 1000
			running: root.musicVisible
			repeat: true
			triggeredOnStart: true
			onTriggered: { if (!musicStatusProc.running) musicStatusProc.running = true }
		}
		Timer {
			interval: 1000
			running: musicPanel.playerStatus === "Playing"
			repeat: true
			onTriggered: {
				if (musicPanel.position < musicPanel.length)
					musicPanel.position += 1
			}
		}
	Process {
	  id: musicStatusProc
	  command: [musicPanel.configPath + "/assets/get-player.sh", musicPanel.activePlayer]
	  stdout: SplitParser {
	      splitMarker: ""
	      onRead: data => {
	          var lines = data.split("\n")
	          for (var i = 0; i < lines.length; i++) {
	              var line = lines[i].trim()
	              var idx = line.indexOf(":")
	              if (idx < 0) continue
	              var key = line.substring(0, idx)
	              var val = line.substring(idx + 1)
	              switch (key) {
	                  case "player": musicPanel.resolvedPlayer = val; break
	                  case "status": musicPanel.playerStatus = val || "Stopped"; break
	                  case "title":  musicPanel.trackTitle  = val; break
	                  case "artist": musicPanel.trackArtist = val; break
	                  case "arturl": musicPanel.trackArtUrl = val; break
	                  case "pos":    musicPanel.position    = parseFloat(val) || 0; break
	                  case "len":    musicPanel.length      = parseFloat(val) || 0; break
	              }
	          }
	      }
	  }
	  onExited: code => {
	      if (code !== 0) {
	          musicPanel.playerStatus = "Stopped"
	          musicPanel.trackTitle   = ""
	          musicPanel.trackArtist  = ""
	          musicPanel.trackArtUrl  = ""
	      }
	  }
	}
		Process {
			id: playPauseProc
			command: ["playerctl", "--player=" + musicPanel.resolvedPlayer, "play-pause"]
			onExited: { if (!musicStatusProc.running) musicStatusProc.running = true }
		}
		Process {
			id: nextProc
			command: ["playerctl", "--player=" + musicPanel.resolvedPlayer, "next"]
			onExited: { if (!musicStatusProc.running) musicStatusProc.running = true }
		}
		Process {
			id: prevProc
			command: ["playerctl", "--player=" + musicPanel.resolvedPlayer, "previous"]
			onExited: { if (!musicStatusProc.running) musicStatusProc.running = true }
		}
		Process {
			id: seekProc
			command: ["playerctl", "--player=" + musicPanel.resolvedPlayer, "position", "0"]
		}
	}
}
