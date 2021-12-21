from flask import Flask, redirect, render_template
from flask_sqlalchemy import SQLAlchemy

#my database connections
local_server = True
app = Flask(__name__)
app.secret_key = "baibhab"

# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://username:password@localhost/databasename'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:@localhost/covid'
db = SQLAlchemy(app)

class Test(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String(20))


@app.route("/")
def home():
    return render_template("index.html")

@app.route("/usersignup")
def usersignup():
    return render_template("usersignup.html")

@app.route("/userlogin")
def userlogin():
    return render_template("userlogin.html")


# testing whether the db is connected or not
@app.route("/test")
def test():
    try:
        a = Test.query.all()
        print(a)
        return 'MY DATABASE IS CONNECTED'
    except Exception as e:
        print(e)
        return 'MY DATABASE IS NOT CONNECTED'

app.run(debug = True)