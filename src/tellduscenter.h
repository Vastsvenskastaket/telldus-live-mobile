#ifndef TELLDUSCENTER_H
#define TELLDUSCENTER_H

#include <QObject>
#include <QVariantList>
#include "config.h"

class AbstractView;

class TelldusCenter : public QObject
{
	Q_OBJECT
public:
	explicit TelldusCenter(AbstractView *view, QObject *parent = 0);
	virtual ~TelldusCenter();

signals:
	void backPressed();

public slots:
	void openUrl(const QUrl &url);
	void quit();

#if IS_FEATURE_PUSH_ENABLED
private slots:
	void pushMessageReceived(const QString &message);
#endif

private:
	class PrivateData;
	PrivateData *d;

#ifdef PLATFORM_IOS
	void init();
#endif

};

#endif // TELLDUSCENTER_H
