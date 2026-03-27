QT += quick quick3d quick3dassetutils

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

QML_IMPORT_PATH = $$PWD
QML_DESIGNER_IMPORT_PATH =

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
