#include "tellduscenter.h"
#include <QtDeclarative>
#include "tellduslive.h"
#include "devicemodel.h"
#include "filtereddevicemodel.h"
#include "sensormodel.h"
#include "favoritemodel.h"
#include "device.h"
#include "sensor.h"

class TelldusCenter::PrivateData {
public:
	QDeclarativeView *view;
	DeviceModel *deviceModel;
	FilteredDeviceModel *filteredDeviceModel, *groupModel;
	SensorModel *sensorModel;
	FavoriteModel *favoriteModel;
};

TelldusCenter::TelldusCenter(QDeclarativeView *view, QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->view = view;
	d->deviceModel = new DeviceModel(this);
	d->filteredDeviceModel = new FilteredDeviceModel(d->deviceModel, Device::DeviceType, this);
	d->groupModel = new FilteredDeviceModel(d->deviceModel, Device::GroupType, this);
	d->favoriteModel = new FavoriteModel(d->deviceModel, this);
	d->sensorModel = new SensorModel(this);

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");
	qmlRegisterType<Sensor>("Telldus", 1, 0, "Sensor");
	qRegisterMetaType<QModelIndex>("QModelIndex");

	double scaleFactor = 1.0;
#ifdef Q_WS_MAEMO_5
	scaleFactor = 2.0;
#endif

	d->view->rootContext()->setContextProperty("telldusLive", TelldusLive::instance());
	d->view->rootContext()->setContextProperty("rawDeviceModel", d->deviceModel);
	d->view->rootContext()->setContextProperty("deviceModel", d->filteredDeviceModel);
	d->view->rootContext()->setContextProperty("groupModel", d->groupModel);
	d->view->rootContext()->setContextProperty("favoriteModel", d->favoriteModel);
	d->view->rootContext()->setContextProperty("sensorModel", d->sensorModel);
	d->view->rootContext()->setContextProperty("SCALEFACTOR", scaleFactor);
}

TelldusCenter::~TelldusCenter() {
	delete d;
}
