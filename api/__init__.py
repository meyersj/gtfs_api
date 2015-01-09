from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy import create_engine

app = Flask(__name__)
app.config.from_object('config')

#modifed to False if deploying with wsgi
app.debug = True

engine = create_engine(app.config['DB_CONFIG'])
Session = scoped_session(sessionmaker(bind=engine))

# assign new function names
# to make debug and error logging easier
debug = app.logger.debug
error = app.logger.error

from api.mod_shared import module as mod_shared
from api.mod_onoff import module as mod_onoff
from api.mod_intercept import module as mod_intercept

app.register_blueprint(mod_shared)
app.register_blueprint(mod_onoff)
app.register_blueprint(mod_intercept)

from api import views
