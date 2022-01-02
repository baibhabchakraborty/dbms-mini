from flask import Flask, json,redirect,render_template,flash,request
from flask.globals import request, session
from flask.helpers import url_for
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash,check_password_hash

from flask_login import login_required,logout_user,login_user,login_manager,LoginManager,current_user

from flask_mail import Mail
import json


#my database connections
local_server = True
app = Flask(__name__)
app.secret_key = "baibhab"

with open('backend/config.json','r') as c:
    params=json.load(c)["params"]

app.config.update(
    MAIL_SERVER = 'smtp.gmail.com',
    MAIL_PORT = '465',
    MAIL_USE_SSL = True, 
    MAIL_USERNAME = params['gmail-user'],
    MAIL_PASSWORD = params['gmail-password']
)
mail = Mail(app)

#set login manager,getting unique user access
login_manager = LoginManager(app)
login_manager.login_view = 'login'


# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://username:password@localhost/databasename'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:@localhost/covid'
db = SQLAlchemy(app)






@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

class Test(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String(20))


class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key = True)
    srfid = db.Column(db.String(20), unique = True)
    email = db.Column(db.String(100))
    dob = db.Column(db.String(1000))

class Hospitaluser(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key = True)
    hcode = db.Column(db.String(20))
    email = db.Column(db.String(100))
    password = db.Column(db.String(1000))

@app.route("/")
def home():
    return render_template("index.html")



@app.route("/signup", methods = ['POST','GET'])
def signup():
    if request.method == 'POST':
        srfid = request.form.get('srf')
        email = request.form.get('email')
        dob = request.form.get('dob')
        # print(srfid, email, dob)

        encpassword = generate_password_hash(dob)
        user = User.query.filter_by(srfid = srfid).first()
        emailUser = User.query.filter_by(email = email).first()

        if user or emailUser:
            flash("Email or SRFid is already taken!","warning")
            return render_template("usersignup.html")

        new_user = db.engine.execute(f"INSERT INTO `user` (`srfid`, `email`, `dob`) VALUES ('{srfid}','{email}','{encpassword}')")
        user1 = User.query.filter_by(srfid = srfid).first()
        
        
        flash("Signup Success! Now Please Login!", "success")
        return render_template("userlogin.html")
    
    return render_template("usersignup.html")


@app.route("/login", methods = ['POST','GET'])
def login():
    if request.method == 'POST':
        srfid = request.form.get('srf')
        dob = request.form.get('dob')
        user = User.query.filter_by(srfid = srfid).first()

        if user and check_password_hash(user.dob, dob):
            login_user(user)
            flash("Login Success", "info")
            return render_template("index.html")
        else:
            flash("Invalid Credentials!", "danger")
    return render_template("userlogin.html")


@app.route("/hospitallogin", methods = ['POST','GET'])
def hospitallogin():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        user = Hospitaluser.query.filter_by(email = email).first()

        if user and check_password_hash(user.password, password):
            login_user(user)
            flash("Login Success", "info")
            return render_template("index.html")
        else:
            flash("Invalid Credentials!", "danger")
            return render_template("hospitallogin.html")
    
    
    return render_template("hospitallogin.html")
   

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("Logout Successful","warning")
    return redirect(url_for('login'))
    

@app.route("/admin", methods = ['POST','GET'])
def admin():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        if(username == params['user'] and password == params['password']):
            session['user'] = username
            flash("login success", "info")
            return render_template("addHosUser.html")
        else:
            flash("Invalid Credentials","warning")

    return render_template("admin.html")

@app.route("/addHospitalUser", methods = ['POST','GET'])
def hospitalUser():
    if('user' in session and session['user'] == params['user']):
        if request.method == 'POST':
            hcode = request.form.get('hcode')
            email = request.form.get('email')
            password = request.form.get('password')
            # print(srfid, email, dob)

            encpassword = generate_password_hash(password)
            emailUser = Hospitaluser.query.filter_by(email = email).first()

            if emailUser:
                flash("Email is already taken!","warning")
                return render_template("usersignup.html")
            new_user = db.engine.execute(f"INSERT INTO `hospitaluser` (`hcode`, `email`, `password`) VALUES ('{hcode}','{email}','{encpassword}')")
            mail.send_message("COVID CARE CENTER", sender = params['gmail-user'], recipients=[email], body=f"Welcome! Thanks for Choosing us! \n\n\n Your Login Credentials are: \n Email Address : {email}\n Password : {password} \n\n\n\n DO NOT SHARE YOUR PASSWORD WITH ANYONE\n\n Thank You!")
            flash("Data sent and Inserted successfully!", "success")
    else:
        flash("Login and try again", "message")
        return redirect("/admin")
    return render_template("addHosUser.html")


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


@app.route('/logoutadmin')
@login_required
def logoutadmin():
    logout_user()
    flash("Admin Logout Successful","warning")
    return redirect('/admin')


app.run(debug = True)

