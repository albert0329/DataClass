import datetime as dt
import numpy as np
import pandas as pd

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify

#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################

@app.route("/")
def welcome():
	"""List all available api routes."""
	return (
		f"Available Routes:<br/>"
		f"/api/v1.0/precipitation<br/>"
		f"/api/v1.0/stations<br/>"
		f"/api/v1.0/tobs<br/>"
		f"/api/v1.0/start<br/>"
		f"/api/v1.0/start/end<br/>"

	)

@app.route("/api/v1.0/precipitation")
def precipitation():
	latest_date = session.query(func.max(Measurement.date)).scalar()
	past_year = (dt.datetime.strptime(latest_date, "%Y-%m-%d") - dt.timedelta(365)).strftime("%Y-%m-%d")

	precipitation_last_12months = session.query(Measurement.date, Measurement.prcp, Measurement.station).filter(Measurement.date >= past_year).all()
	rain_list = []
	for row in precipitation_last_12months:
		rain_dict = {}
		rain_dict["date"] = row.date
		rain_dict["percipitation"] = row.prcp
		#rain_dict["station"] = row.station
		rain_list.append(rain_dict)

	return jsonify(rain_list)

@app.route("/api/v1.0/stations")
def stations():
	stations_query = session.query(Station.name).all()
	stations_list = list(np.ravel(stations_query))

	return jsonify(stations_list)

@app.route("/api/v1.0/tobs")
def tobs():
	latest_date = session.query(func.max(Measurement.date)).scalar()
	past_year = (dt.datetime.strptime(latest_date, "%Y-%m-%d") - dt.timedelta(365)).strftime("%Y-%m-%d")

	temperature_last_12months = session.query(Measurement.date, Measurement.tobs).filter(Measurement.date >= past_year).all()
	temperature_list = []
	for row in temperature_last_12months:
		temp_dict = {}
		temp_dict["date"] = row.date
		temp_dict["temperature"] = row.tobs
		temperature_list.append(temp_dict)

	return jsonify(temperature_list) 


@app.route("/api/v1.0/<start>")
def startdate(start):
    min_temp = session.query(func.min(Measurement.tobs)).filter(Measurement.date >= start).scalar()
    max_temp = session.query(func.max(Measurement.tobs)).filter(Measurement.date >= start).scalar()
    avg_temp = session.query(func.avg(Measurement.tobs)).filter(Measurement.date >= start).scalar()
    return f' From {start} the min temp was {min_temp}, high temp was {max_temp}, and avg temp was {avg_temp}'

@app.route("/api/v1.0/<start>/<end>")
def daterange(start, end):
    min_temp = session.query(func.min(Measurement.tobs)).filter(Measurement.date >= start, Measurement.date <= end).scalar()
    max_temp = session.query(func.max(Measurement.tobs)).filter(Measurement.date >= start, Measurement.date <= end).scalar()
    avg_temp = session.query(func.avg(Measurement.tobs)).filter(Measurement.date >= start, Measurement.date <= end).scalar()
    return f'Between {start} and {end} the min temp was {min_temp}, high temp was {max_temp} and avg temp was {avg_temp}'


if __name__ == '__main__':
    app.run(debug=True)







