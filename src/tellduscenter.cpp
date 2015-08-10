#include <QtQuick>

#include "client.h"
#include "commonview.h"
#include "device.h"
#include "sensor.h"
#include "tellduscenter.h"
#include "tellduslive.h"
#include "user.h"
#include "models/clientmodel.h"
#include "models/devicemodel.h"
#include "models/dashboardModel.h"
#include "models/favoritemodel.h"
#include "models/filtereddevicemodel.h"
#include "models/groupdevicemodel.h"
#include "models/schedulermodel.h"
#include "models/sensormodel.h"
#include "utils/dev.h"
#include "config.h"

#ifdef PLATFORM_ANDROID
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include "AndroidPushNotifications.h"
#endif

class TelldusCenter::PrivateData {
public:
	AbstractView *view;
	FilteredDeviceModel *rawDeviceModel, *deviceModel, *groupModel;
	DashboardModel *dashboardModel;
	FavoriteModel *favoriteModel;
	ClientModel *clientModel;
	User *user;
	static TelldusCenter *instance;
};

TelldusCenter *TelldusCenter::PrivateData::instance = 0;

TelldusCenter::TelldusCenter(AbstractView *view, QObject *parent) :QObject(parent) {
	TelldusLive *tdLive = TelldusLive::instance();
#ifdef PLATFORM_ANDROID
	connect(AndroidPushNotifications::instance(), &AndroidPushNotifications::sendRegisterPushTokenWithApi, tdLive, &TelldusLive::registerPushTokenWithApi );
#endif

	tdLive->setupManager();

	d = new PrivateData;
	d->view = view;
	d->rawDeviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::AnyType, this);
	d->deviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::DeviceType, this);
	d->groupModel = new FilteredDeviceModel(DeviceModel::instance(), Device::GroupType, this);
	d->dashboardModel = new DashboardModel(DeviceModel::instance(), this);
	d->favoriteModel = new FavoriteModel(DeviceModel::instance(), this);
	d->clientModel = new ClientModel(this);
	d->user = new User(this);

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Client>("Telldus", 1, 0, "Client");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");
	qmlRegisterType<Sensor>("Telldus", 1, 0, "Sensor");
	qmlRegisterType<GroupDeviceModel>("Telldus", 1, 0, "GroupDeviceModel");
	qRegisterMetaType<QModelIndex>("QModelIndex");
	d->view->setContextProperty("telldusLive", tdLive);
	d->view->setContextProperty("dev", Dev::instance());
	d->view->setContextProperty("core", this);
	d->view->setContextProperty("deviceModelController", DeviceModel::instance());
	d->view->setContextProperty("rawDeviceModel", d->rawDeviceModel);
	d->view->setContextProperty("schedulerModel", SchedulerModel::instance());
	d->view->setContextProperty("deviceModel", d->deviceModel);
	d->view->setContextProperty("groupModel", d->groupModel);
	d->view->setContextProperty("favoriteModel", d->favoriteModel);
	d->view->setContextProperty("dashboardModel", d->dashboardModel);
	d->view->setContextProperty("clientModel", d->clientModel);
	d->view->setContextProperty("sensorModel", SensorModel::instance());
	d->view->setContextProperty("user", d->user);
}

TelldusCenter::~TelldusCenter() {
	delete d;
}

void TelldusCenter::openUrl(const QUrl &url) {
#ifdef PLATFORM_IOS
	qobject_cast<CommonView *>(d->view)->openUrl(url);
#else
	QDesktopServices::openUrl(url);
#endif  // PLATFORM_IOS
}

#ifdef PLATFORM_ANDROID
void TelldusCenter::fromJavaSendRegistrationToServer(JNIEnv *env, jobject thiz, jstring token, jstring name, jstring manufacturer, jstring model, jstring os_version) {
	Q_UNUSED(thiz);
	const char* nativeToken = env->GetStringUTFChars(token, 0);
	const char* nativeName = env->GetStringUTFChars(name, 0);
	const char* nativeManufacturer = env->GetStringUTFChars(manufacturer, 0);
	const char* nativeModel = env->GetStringUTFChars(model, 0);
	const char* nativeOsVersion = env->GetStringUTFChars(os_version, 0);
	qDebug() << "[TelldusCenter] Token from Java in C++" << QString(nativeToken);
	qDebug() << "[TelldusCenter] Name from Java in C++" << QString(nativeName);
	qDebug() << "[TelldusCenter] Model from Java in C++" << QString(nativeModel);
	qDebug() << "[TelldusCenter] Manufacturer from Java in C++" << QString(nativeManufacturer);
	qDebug() << "[TelldusCenter] OsVersion from Java in C++" << QString(nativeOsVersion);
	AndroidPushNotifications::instance()->receivePushData(QString(nativeToken), QString(nativeName), QString(nativeManufacturer), QString(nativeModel), QString(nativeOsVersion));
}
#endif
TelldusCenter * TelldusCenter::instance(AbstractView *view, QObject *parent) {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new TelldusCenter(view, parent);
	}
	return PrivateData::instance;
}