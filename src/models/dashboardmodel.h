#ifndef DASHBOARDMODEL_H
#define DASHBOARDMODEL_H

#include "tlistmodel.h"

class DashboardItem;
class FavoriteDeviceModel;
class FavoriteSensorModel;

class DashboardModel : public TListModel
{
	Q_OBJECT
public:
	DashboardModel(FavoriteDeviceModel *favoriteDeviceModel, FavoriteSensorModel *filteredSensorModel, QObject *parent = 0);
	~DashboardModel();
	Q_INVOKABLE void addDashboardItems();
	Q_INVOKABLE DashboardItem *findDashboardItem(int id) const;
	Q_INVOKABLE void removeDashboardItem(int id);

signals:
	void dashboardItemsLoaded(const QVariantList &dashboardItems);

private slots:
	void authorizationChanged();
	void onDashboardItemInfo(const QVariantMap &result);
	void onDashboardItemRemove(const QVariantMap &result, const QVariantMap &params);
	void onDashboardItemsList(const QVariantMap &result);

private:
	class PrivateData;
	PrivateData *d;
};

#endif // DASHBOARDMODEL_H
