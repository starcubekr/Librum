import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CustomComponents 1.0
import Librum.elements 1.0
import QtGraphicalEffects 1.15
import Librum.style 1.0
import Librum.icons 1.0


Item
{
    id: root
    property var itemToRedirectFocusTo
    property bool recording: false
    property string originalSequence: ""
    
    
    Glow
    {
        id: backgroundGlow
        visible: root.recording
        width: button.width
        height: button.height
        x: button.x
        y: button.y
        spread: 0
        samples: 12
        transparentBorder: true
        color: "#A92224"
        source: button
    }
    
    ColumnLayout
    {
        id: mainLayout
        anchors.fill: parent
        spacing: 2
        
        Label
        {
            id: header
            text: "Key"
            font.weight: Font.DemiBold
            font.pointSize: 12
            font.family: Style.defaultFontFamily
            color: Style.colorBaseTitle
        }
        
        
        Rectangle
        {
            id: button
            
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            radius: 4
            color: Style.colorBackground
            border.color: root.recording ? "#E8B9BA" : Style.colorLightBorder
            opacity: mouseArea.pressed ? 0.8 : 1
            
            onActiveFocusChanged: activeFocus ? root.startRecording() : root.stopRecording()
            
            
            KeySequenceRecorder
            {
                id: keySequenceRecorder
                originalSequence: root.originalSequence
                
                onReturnPressed: stopRecording()
            }
            
            
            RowLayout
            {
                id: contentLayout
                anchors.fill: parent
                spacing: 4
                
                
                Label
                {
                    id: recordLabel
                    Layout.fillWidth: true
                    Layout.leftMargin: 12
                    text: keySequenceRecorder.currentSequence === "" ? 
                              (keySequenceRecorder.originalSequence === "" ? "Press to record" : keySequenceRecorder.originalSequence)
                            : keySequenceRecorder.currentSequence
                    font.pointSize: 13
                    font.family: Style.defaultFontFamily
                    color: Style.colorLightText3
                    elide: Text.ElideLeft
                }
                
                Image
                {
                    id: microphoneIcon
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 12
                    source: root.recording ? Icons.activeMicrophone : Icons.microphone
                    sourceSize.width: 18
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
    
    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        
        onClicked:
        {            
            if(root.recording)
            {
                stopRecording();
                root.forceActiveFocus();
                return;
            }
            
            startRecording();
        }
    }
    
    
    SequentialAnimation
    {
        loops: Animation.Infinite
        id: buttonPulsatingAnimation
        
        
        PropertyAnimation
        {
            target: backgroundGlow
            property: "radius"
            duration: 600
            to: 10
        }
        
        PropertyAnimation
        {
            target: backgroundGlow
            property: "radius"
            duration: 600
            to: 2
        }
    }
    
    function clear()
    {
        keySequenceRecorder.resetSequence();
    }
    
    function startRecording()
    {
        keySequenceRecorder.forceActiveFocus();
        root.recording = true;
        buttonPulsatingAnimation.start();
    }
    
    function stopRecording()
    {
        itemToRedirectFocusTo.forceActiveFocus();
        root.recording = false;
        buttonPulsatingAnimation.stop();
    }
}