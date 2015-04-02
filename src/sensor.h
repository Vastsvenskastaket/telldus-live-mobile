#ifndef SENSOR_H
#define SENSOR_H

#include <QObject>
#include <QMetaType>
#include <QVariantMap>
#include <QDateTime>

class Sensor : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool hasHumidity READ hasHumidity NOTIFY hasHumidityChanged)
	Q_PROPERTY(bool hasRainRate READ hasRainRate NOTIFY hasRainRateChanged)
	Q_PROPERTY(bool hasRainTotal READ hasRainTotal NOTIFY hasRainTotalChanged)
	Q_PROPERTY(bool hasTemperature READ hasTemperature NOTIFY hasTemperatureChanged)
	Q_PROPERTY(bool hasUV READ hasUV NOTIFY hasUVChanged)
	Q_PROPERTY(bool hasWatt READ hasWatt NOTIFY hasWattChanged)
	Q_PROPERTY(bool hasWindAvg READ hasWindAvg NOTIFY hasWindAvgChanged)
	Q_PROPERTY(bool hasWindGust READ hasWindGust NOTIFY hasWindGustChanged)
	Q_PROPERTY(bool hasWindDir READ hasWindDir NOTIFY hasWindDirChanged)
	Q_PROPERTY(QString humidity READ humidity WRITE setHumidity NOTIFY humidityChanged)
	Q_PROPERTY(QString rainRate READ rainRate WRITE setRainRate NOTIFY rainRateChanged)
	Q_PROPERTY(QString rainTotal READ rainTotal WRITE setRainTotal NOTIFY rainTotalChanged)
	Q_PROPERTY(QString temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged)
	Q_PROPERTY(QString uv READ uv WRITE setUV NOTIFY uvChanged)
	Q_PROPERTY(QString watt READ watt WRITE setWatt NOTIFY wattChanged)
	Q_PROPERTY(QString windAvg READ windAvg WRITE setWindAvg NOTIFY windAvgChanged)
	Q_PROPERTY(QString windGust READ windGust WRITE setWindGust NOTIFY windGustChanged)
	Q_PROPERTY(QString windDir READ windDir WRITE setWindDir NOTIFY windDirChanged)

	Q_PROPERTY(int id READ sensorId WRITE setId NOTIFY idChanged)
	Q_PROPERTY(QDateTime lastUpdated READ lastUpdated WRITE setLastUpdated NOTIFY lastUpdatedChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(int minutesAgo READ minutesAgo NOTIFY lastUpdatedChanged)
public:
	explicit Sensor(QObject *parent = 0);
	~Sensor();

	QString humidity() const;
	void setHumidity(const QString &humidity);
	bool hasHumidity() const;

	QString rainRate() const;
	void setRainRate(const QString &rainRate);
	bool hasRainRate() const;

	QString rainTotal() const;
	void setRainTotal(const QString &rainTotal);
	bool hasRainTotal() const;

	int sensorId() const;
	void setId(int id);

	QDateTime lastUpdated() const;
	void setLastUpdated(const QDateTime &lastUpdated);

	int minutesAgo() const;

	QString name() const;
	void setName(const QString &name);

	QString temperature() const;
	void setTemperature(const QString &temperature);
	bool hasTemperature() const;

	void update(const QVariantMap &data);

	QString uv() const;
	void setUV(const QString &uv);
	bool hasUV() const;

	QString watt() const;
	void setWatt(const QString &power);
	bool hasWatt() const;

	QString windAvg() const;
	void setWindAvg(const QString &windAvg);
	bool hasWindAvg() const;

	QString windGust() const;
	void setWindGust(const QString &windGust);
	bool hasWindGust() const;

	QString windDir() const;
	void setWindDir(const QString &windDir);
	bool hasWindDir() const;

signals:
	void idChanged();
	void hasHumidityChanged();
	void hasRainRateChanged();
	void hasRainTotalChanged();
	void hasTemperatureChanged();
	void hasUVChanged();
	void hasWattChanged();
	void hasWindAvgChanged();
	void hasWindGustChanged();
	void hasWindDirChanged();
	void humidityChanged(const QString &humidity);
	void rainRateChanged(const QString &);
	void rainTotalChanged(const QString &);
	void lastUpdatedChanged(const QDateTime &lastUpdated);
	void nameChanged(const QString &name);
	void temperatureChanged(const QString &temperature);
	void uvChanged(const QString &);
	void wattChanged(const QString &);
	void windAvgChanged(const QString &);
	void windGustChanged(const QString &);
	void windDirChanged(const QString &);

private slots:
	void fetchData();
	void onInfoReceived(const QVariantMap &);

private:
	class PrivateData;
	PrivateData *d;
};

Q_DECLARE_METATYPE(Sensor*)

#endif // SENSOR_H
