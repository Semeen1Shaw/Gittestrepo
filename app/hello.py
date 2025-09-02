from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hello World!"


@app.route('/hello/<name>')
def hello_name(name):
    return "Hello %s!" %name
    

@app.route("/blogs/<int:id>")
def show_blogs(id):
    return "The Blog is %s!" %id

@app.route("/contact-us")
def contact_us():
    return "Connect us on: 00000000"

if (__name__) == "__main__":
    app.debug = True
    app.run()
