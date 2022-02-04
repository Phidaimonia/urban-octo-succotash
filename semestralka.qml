import QtQuick 2.3
import QtQuick.Controls 2.3

ApplicationWindow 
{
    id: window
	objectName: "window"
    width: 1200
    height: 800
    visible: true
	color: "gray"
	
	Rectangle 
	{						
		id: mainPanel
		objectName: "mainPanel"
		readonly property var borderSizeF: Math.min(parent.width, parent.height) * 0.01
		readonly property var canvasRatio: 0.8
		
		width: parent.width - borderSizeF * 2
		height: parent.height - borderSizeF * 2
		color: "white"
		visible: false
		
		anchors.centerIn: parent
		
		Canvas 
		{
			id: mycanvas
			objectName: "mycanvas"
			width: parent.width * parent.canvasRatio - parent.borderSizeF * 2
			height: parent.height - parent.borderSizeF * 2
			x: parent.borderSizeF
			y: parent.borderSizeF
			
			
			property var spoolAngle: 0.0
			property var ballAngle:  0.0
			
			property var spoolRadius: width / 6
			property var ballRadius: width / 10
			
			property var spoolPosX: width / 2
			property var spoolPosY: height / 4
			
			property var ballPosX: spoolPosX + (ballRadius + spoolRadius) * Math.cos(ballAngle)
			property var ballPosY: spoolPosY + (ballRadius + spoolRadius) * Math.sin(ballAngle)
			

			
			function drawAll() 
			{

				var ctx = getContext("2d");

				//ctx.fillStyle = Qt.rgba(1, 1, 0, 0.5);
				ctx.clearRect(0, 0, width, height);				
				
				
				
				// spool

				ctx.beginPath();
				ctx.arc(spoolPosX, height - spoolPosY, spoolRadius, 0, 2 * Math.PI, false);         // big spool circle
				ctx.fillStyle = 'green';
				ctx.fill();
				context.closePath();
				
				ctx.beginPath();
				ctx.lineWidth = 6;
				ctx.strokeStyle = 'black';
				ctx.arc(spoolPosX, height - spoolPosY, spoolRadius, 0, 2 * Math.PI, false);         // big spool circle outline
				context.stroke();
				
				ctx.beginPath();
				ctx.arc(spoolPosX, height - spoolPosY, spoolRadius / 16, 0, 2 * Math.PI, false);     // small spool circle
				ctx.fillStyle = 'black';
				ctx.fill();
				context.closePath();
				
				
				for (let i = 0; i < 1; i++)   // lines to show angle
				{
					ctx.beginPath()		
					ctx.lineWidth = 4;
					ctx.moveTo(spoolPosX, height - spoolPosY)
					ctx.lineTo(spoolPosX + spoolRadius * Math.cos(spoolAngle + Math.PI * 2 / 3 * i), height - spoolPosY - spoolRadius * Math.sin(spoolAngle + Math.PI * 2 / 3 * i))
					ctx.stroke();
				}
				
				
				
				
				
				// ball

				ctx.beginPath();
				ctx.arc(ballPosX, height - ballPosY, ballRadius, 0, 2 * Math.PI, false);         // big circle
				ctx.fillStyle = 'red';
				ctx.fill();
				context.closePath();
				
				ctx.beginPath();
				ctx.lineWidth = 4;
				ctx.strokeStyle = 'black';
				ctx.arc(ballPosX, height - ballPosY, ballRadius, 0, 2 * Math.PI, false);         // big circle outline
				context.stroke();
				
				ctx.beginPath();
				ctx.arc(ballPosX, height - ballPosY, ballRadius / 16, 0, 2 * Math.PI, false);     // small circle
				ctx.fillStyle = 'black';
				ctx.fill();
				context.closePath();
				
				for (let i = 0; i < 4; i++)   // lines to show angle
				{
					ctx.beginPath()		
					ctx.lineWidth = 4;
					ctx.moveTo(ballPosX, height - ballPosY)
					ctx.lineTo(ballPosX + ballRadius * Math.cos(ballAngle - spoolAngle / ballRadius * spoolRadius + Math.PI * 2 / 3 * i), height - ballPosY - ballRadius * Math.sin(ballAngle - spoolAngle / ballRadius * spoolRadius + Math.PI * 2 / 3 * i))
					ctx.stroke();
				}
				
				
			}
			
		}
		
		Rectangle 
		{						
			id: controlPanel
			objectName: "controlPanel"
			width: parent.width * (1.0 - parent.canvasRatio) - parent.borderSizeF
			height: parent.height - parent.borderSizeF * 2
			x: mycanvas.width + parent.borderSizeF * 2
			y: parent.borderSizeF
			color: "gray"
			
			Text 
			{
				id: controlLabel
				objectName: "controlLabel"
				y: mainPanel.borderSizeF * 2
				font.pointSize: Qt.application.font.pointSize * 2
				anchors.horizontalCenter: parent.horizontalCenter
				
				text: "CONTROLS"
			}
			
			
			
			
			
			Text 
			{
				id: initialAngleLabel
				objectName: "initialAngleLabel"
				y: controlLabel.y + controlLabel.height + mainPanel.borderSizeF * 1.5
				font.pointSize: Qt.application.font.pointSize * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				
				text: "Initial angle (rad)"
			}
			
			TextField 
			{
				id: initialAngleEdit
				objectName: "initialAngleEdit"
				y: initialAngleLabel.y + initialAngleLabel.height + mainPanel.borderSizeF * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width - mainPanel.borderSizeF * 2
				
				text: "0.0"
			}
			
			Button 
			{
				id: initialAngleResetButton
				objectName: "initialAngleResetButton"
				y: initialAngleEdit.y + initialAngleEdit.height + mainPanel.borderSizeF * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width - mainPanel.borderSizeF * 2
				
				text: "RESET"
			}
			
			
			
			
			
			
			
			Text 
			{
				id: nudgeLabel
				objectName: "nudgeLabel"
				y: initialAngleResetButton.y + initialAngleResetButton.height + mainPanel.borderSizeF * 2
				font.pointSize: Qt.application.font.pointSize * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				
				text: "Nudge"
			}
			
			Button 
			{
				id: nudgeButton
				objectName: "nudgeButton"
				y: nudgeLabel.y + nudgeLabel.height + mainPanel.borderSizeF * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width - mainPanel.borderSizeF * 2
				
				text: "NUDGE"
			}
			
			
			
			
			
			
			Text 
			{
				id: disturbanceLabel
				objectName: "disturbanceLabel"
				y: nudgeButton.y + nudgeButton.height + mainPanel.borderSizeF * 2
				font.pointSize: Qt.application.font.pointSize * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				
				text: "Disturbance"
			}
			
	
			
			Button 
			{
				id: disturbanceButton
				objectName: "disturbanceButton"
				y: disturbanceLabel.y + disturbanceLabel.height + mainPanel.borderSizeF * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width - mainPanel.borderSizeF * 2
				
				text: "DISTURB"
			}
			
			
			
			
			
			
			Text 
			{
				id: informationLabel
				objectName: "informationLabel"
				y: disturbanceButton.y + disturbanceButton.height + mainPanel.borderSizeF * 2
				font.pointSize: Qt.application.font.pointSize * 2
				anchors.horizontalCenter: parent.horizontalCenter
				
				text: "INFORMATION"
			}
			
			
			
			
			Text 
			{
				id: ballAngleInfo
				objectName: "ballAngleInfo"
				y: informationLabel.y + informationLabel.height + mainPanel.borderSizeF * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width - mainPanel.borderSizeF * 2
				font.pointSize: Qt.application.font.pointSize * 1.5
				
				text: "Ball angle:"
			}
			Text 
			{
				id: motorAngleInfo
				objectName: "motorAngleInfo"
				y: ballAngleInfo.y + ballAngleInfo.height + mainPanel.borderSizeF * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width - mainPanel.borderSizeF * 2
				font.pointSize: Qt.application.font.pointSize * 1.5
				
				text: "Motor angle:"
			}
			Text 
			{
				id: motorSpeedInfo
				objectName: "motorSpeedInfo"
				y: motorAngleInfo.y + motorAngleInfo.height + mainPanel.borderSizeF * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width - mainPanel.borderSizeF * 2
				font.pointSize: Qt.application.font.pointSize * 1.5
				
				text: "Motor speed:"
			}
			
			
			
			
			Text 
			{
				id: connectionStatusLabel
				objectName: "connectionStatusLabel"
				y: motorSpeedInfo.y + motorSpeedInfo.height + mainPanel.borderSizeF * 2
				font.pointSize: Qt.application.font.pointSize * 2
				anchors.horizontalCenter: parent.horizontalCenter
				
				text: "STATUS"
			}
			
			
			
			
			Text 
			{
				id: connectionStatus
				objectName: "connectionStatus"
				y: connectionStatusLabel.y + connectionStatusLabel.height + mainPanel.borderSizeF * 1.5
				anchors.horizontalCenter: parent.horizontalCenter
				font.pointSize: Qt.application.font.pointSize * 1.5
				color: "green"
				
				text: "CONNECTED"
			}
			
			
			
			
			
			
		}

	}
	
	Rectangle 
	{
		id: connectionPanel
		objectName: "connectionPanel"
		width: mainPanel.width / 2
		height: mainPanel.height / 2
		color: "white"
		visible: true
		
		anchors.centerIn: parent

		Text 
		{
			id: authLabel
			objectName: "authLabel"
			visible: true
			
			font.pointSize: Qt.application.font.pointSize * 2
			color: "red"
			
			anchors.horizontalCenter: parent.horizontalCenter
			y: connectionPanel.height / 5
			
			text: "Connect to the server"
		}
		
		TextField 
			{
				id: hostField
				objectName: "hostField"
				y: authLabel.y + authLabel.height + mainPanel.borderSizeF * 2
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 2 / 3 - mainPanel.borderSizeF * 2
				
				text: "http://127.0.0.1:8008"
			}
			
			
		Text 
		{
			id: credentialsLabel
			objectName: "credentialsLabel"
			
			font.pointSize: Qt.application.font.pointSize * 1.5
			color: "black"
			
			anchors.horizontalCenter: parent.horizontalCenter
			y: hostField.y + hostField.height + mainPanel.borderSizeF * 2
			
			text: "Username and password"
		}
		
		TextField 
			{
				id: usernameField
				objectName: "usernameField"
				y: credentialsLabel.y + credentialsLabel.height + mainPanel.borderSizeF * 2
				width: parent.width / 3 - mainPanel.borderSizeF * 2
				x: hostField.x
				
				text: "admin"
			}
			
		TextField 
			{
				id: passwordField
				objectName: "passwordField"
				y: usernameField.y
				width: parent.width / 3 - mainPanel.borderSizeF * 2
				x: usernameField.x + usernameField.width + mainPanel.borderSizeF * 2
				
				text: ""
			}
		
		Button 
		{
			objectName: "connectButton"
			text: qsTr("Connect")
			
			y: passwordField.y + passwordField.height + mainPanel.borderSizeF * 2
			anchors.horizontalCenter: parent.horizontalCenter
			
		}
	}
	
}

