import json
import httplib

class RemoteLoader():
	def __init__(self, app_id="TuarREq18Ufbz9UdEa6zgMsCM8U8ggjd96gk9NbP", rest_api_key="ehb89elt3huqh88J2Te9eM3hstr4nYP0FMkGAtH4"):
		self.app_id = app_id
		self.rest_api_key = rest_api_key
		self.domain = 'parseapi.back4app.com'
		self.parse_headers = {
			"X-Parse-Application-Id": self.app_id,
			"X-Parse-REST-API-Key": self.rest_api_key,
			"Content-Type": "application/json"
		}

	def get_connection(self):
		connection = httplib.HTTPSConnection(self.domain, 443)
		connection.connect()
		return connection

	def run_cloud_function(self, name, params):
		connection = self.get_connection()
		connection.request('POST', '/functions/%s' % name, json.dumps(params), parse_headers)
		result = json.loads(connection.getresponse().read())
		return result

	def create_object(self, class_name, params):
		connection = self.get_connection()
		connection.request('POST', '/classes/{class_name}'.format(class_name=class_name), json.dumps(params), self.parse_headers)
		result = json.loads(connection.getresponse().read())
		print result
		return result

	def delete_object(self, class_name, object_id):
		connection = self.get_connection()
		connection.request('DELETE', '/classes/{class_name}/{object_id}'.format(class_name=class_name, object_id=object_id))
		result = json.loads(connection.getresponse().read())
		return result