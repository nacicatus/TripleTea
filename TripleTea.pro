TEMPLATE = app
QT       += quick qml

SOURCES += \
        boardmodel.cpp \
        main.cpp


target.path = /tmp/$${TARGET}/bin

CONFIG += c++11

INSTALLS += target


HEADERS += \
        boardmodel.h

RESOURCES += \
    main.qml

INSTALLS += target

