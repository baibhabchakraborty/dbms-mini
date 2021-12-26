from flask import Flask, redirect, render_template, request, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_required, logout_user, login_user, login_manager, LoginManager, current_user
from flask.helpers import url_for

#my database connections
local_server = True
app = Flask(__name__)
app.secret_key = "baibhab"

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
   

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("Logout Successful","warning")
    return redirect(url_for('login'))
    


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