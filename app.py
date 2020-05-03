import os
import fdb
from bottle import Bottle, run, template, static_file, request, redirect

app = Bottle()

con, cur = None, None


def open_db(file_name) -> tuple:
    file_path = os.path.abspath(os.path.join('./databases', file_name))
    if not os.path.exists(file_path):
        raise FileNotFoundError
    con = fdb.connect(host='', database=file_path, port=3050, user='sysdba', password='masterkey')
    cur = con.cursor()
    return con, cur


@app.route('/static/<filename>')
def server_static(filename):
    return static_file(filename, root='/static/')


@app.route('/')
def home():
    global con, cur
    if con is None:
        redirect('/databases')

    return template('home.html')


@app.route('/databases', method='GET')
def databases():
    db_files = [name for name in os.listdir('./databases') if name[-3:].upper() == 'FDB']
    return template('db_list.html', db_files=db_files)


@app.route('/databases', method='POST')
def connect():
    db_name = request.forms.get('db_name')
    global con, cur
    con, cur = open_db(db_name)
    redirect('/')


@app.route('/disconnect', method='POST')
def disconnect():
    global con, cur
    con.close()
    con, cur = None, None
    redirect('/databases')


run(app, host='localhost', port=8080, debug=True, reloader=True)
