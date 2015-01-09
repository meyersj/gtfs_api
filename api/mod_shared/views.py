import os
import sys
import time
import json

from flask import jsonify, request, Blueprint
from sqlalchemy import func

from api import app
from api import debug, error, Session


NAME = 'shared'
module = Blueprint(NAME, __name__, url_prefix=os.path.join('/', NAME))


def clean(arg):
    return arg.strip()

def build_query(select_from, where='', group='', order=''):
    query = select_from
    for clause in [where, group, order]:
        if clause:
            query += ' ' + clause
    return query += ';'

@module.route('/')
def index():
    return NAME


"""
returns the route number and description
for all routes found in the query below

optional route_id params may be provided
route_id
"""

@module.route('/routes', methods=['GET'])
def routes():
    response = []
    session = Session()
    select_from = """
        SELECT rte, rte_desc
        FROM v.lookup_rte
    """
    where = ""
    order = "ORDER BY rte"
    query = None
    params = {}
    if 'rte' in request.args.keys():
        route_id = clean(request.args['rte'])
        where = "rte = :rte"
        params["rte"] = route_id
    query = build_query(select_from, where=where, order=order)
    routes = session.execute(query, params)
    response = [{'rte':str(route[0]), 'rte_desc':route[1]}
        for route in routes]
    session.close()
    return jsonify(routes=response)




