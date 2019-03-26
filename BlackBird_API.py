from flask import Flask, jsonify, request
import subprocess
import json
import urllib

app = Flask(__name__)

@app.route('/blackbird', methods=['GET','POST'])
def get_arguments():
	
	if (request.method == 'POST'):
		token = request.form['token']
		target = request.form.get('text')
	        response_url = request.form.get('response_url')
                responseURL = urllib.unquote(response_url)

		if(token == ''): #Checking Access 
		
			if(target is None): #checks for blank targett
				return "No Target Specified"
			
			if(target == ''):
				return "No Target Specified"
				
			else:
				subprocess.call(['curl', '-X', 'POST', '-H', 'Content-type: application/json', '--data', '{"text":"Conducting flyover results will be in #blackbird-output"}', responseURL])
                                subprocess.call(['nohup', 'blackbird', '-d', target, '&'])
				return jsonify("Copy That"), 200
                                
		
		else: 
			return '', 403
	
	else:
		return '', 403

	
if __name__ == '__main__':
	app.run(host= '0.0.0.0', use_evalex=False)

