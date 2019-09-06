import QtQuick 2.12
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import BoardModel 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 1080
    height: 760
//    minimumWidth: 475
//    minimumHeight: 300

    color: "#09102B"
    title: qsTr("Triple Tea")

    //! [tableview]
    TableView {
        id: tableView
        anchors.fill: parent

        rowSpacing: 1
        columnSpacing: 1

        delegate: Rectangle {
            id: cell
            implicitWidth: 15
            implicitHeight: 15

            color: model.value ?  "#b5b7bf" : "#ffffff"

            MouseArea {
                anchors.fill: parent
                onClicked: model.value = !model.value
            }
        }
        //! [model]
        model: BoardModel {
            id: boardModel
        }
        //! [model]
    }

    footer: Rectangle {
        signal nextStep

        id: footer
        height: 50
        color: "#F3F3F4"

        RowLayout {
            anchors.centerIn: parent

            Button {
                text: qsTr("Next Player")
                onClicked: boardModel.nextStep()
            }

            Button {
                text: timer.running ? "❙❙" : "▶️"
                onClicked: timer.running = !timer.running
            }
        }

        Timer {
            id: timer
            interval: 1000 - (980 * slider.value)
            running: true
            repeat: true

            onTriggered: boardModel.nextStep()
        }
    }

}
