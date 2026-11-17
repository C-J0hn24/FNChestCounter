/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#if __has_include(<chestcounter.h>)
#  include <chestcounter.h>
#endif


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_FNChestCounter()
{
    qmlRegisterModule("FNChestCounter", 254, 0);
    QT_WARNING_PUSH QT_WARNING_DISABLE_DEPRECATED
    qmlRegisterTypesAndRevisions<ChestCounter>("FNChestCounter", 254);
    QT_WARNING_POP
    qmlRegisterModule("FNChestCounter", 254, 254);
}

static const QQmlModuleRegistration fNChestCounterRegistration("FNChestCounter", qml_register_types_FNChestCounter);
