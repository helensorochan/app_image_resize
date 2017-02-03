Server API provides image uploading and resizing for users.
Users with their logins and passwords already exist in database.
Mobile APP uses Server API by sending packets to Server

# MODELS
##USER MODEL
###Fields
* login - String, mandatory
* password - String, mandatory, encrypted

##SESSION MODEL
For different devices and versions user gets different sessions on login.
###Fields
* value - String, mandatory
* user_id - Integer, mandatory
* app_version - Integer, mandatory
* device - String, mandatory
* created_at - DateTime
* updated_at - DateTime

##PICTURE MODEL
###Fields
* file_name - String, mandatory
* width - Integer, mandatory
* height - Integer, mandatory
* content_type - String, mandatory


#ALLOWED ROUTES
* 'pictures/upload', type: 'pictures', action: 'upload', session required
* 'pictures/resize', type: 'pictures', action: 'resize', session required
* 'pictures/collection', type: 'pictures', action: 'collection', session required
* 'users/login', type: 'users', action: 'login'
* 'users/logout', type: 'users', action: 'logout', session required

#ALWAYS MANDATORY PACKET REQUEST PARAMETERS
* device
* version
* type
* action

#ALWAYS MANDATORY PACKET RESPONSE PARAMETERS
* status (true = success)/(false = fail)

#USER PACKETS
##Login
###Request
```ruby
{
  type: 'users',
  action: 'login',
  login: 'login',
  password: 'password',
  version: '1',
  device: '12345'
}
```
####Fields
* type: String, mandatory
* action: String, mandatory
* login: String, mandatory
* password: String, mandatory
* version: Integer, mandatory
* device: Integer, mandatory
###Response
```ruby
{ session: 'session', status: true }
```


##Logout
###Request
```ruby
{ type: 'users', action: 'logout', session: 'session', version: '1', device: '12345' }
```
####Fields
* type: String, mandatory
* action: String, mandatory
* session: String, mandatory
* version: Integer, mandatory
* version: Integer, mandatory
* device: Integer, mandatory
###Response
```ruby
{ status: true }
```


#PICTURE PACKETS

##Upload
###Request
```ruby
{
  type: 'pictures',
  action: 'upload',
  session: 'session',
  version: '1',
  device: '12345',
  origin_file_name: '1.png',
  content_type: 'images/png',
  file: '@1.png',
  width: '100',
  height: '100'
}
```
####Fields
* type: String, mandatory
* action: String, mandatory
* session: String, mandatory
* version: Integer, mandatory
* device: Integer, mandatory
* origin_file_name: String, mandatory
* content_type: String, mandatory
* file: String, mandatory
* width: Integer, mandatory
* height: Integer, mandatory
###Response
```ruby
{ picture: { path: 'path', width: '100', height: '100', file_name: 'timestamp_1.png' }, status: true }
```

##Resize
###Request
```ruby
{
  type: 'pictures',
  action: 'resize',
  session: 'session',
  device: '12345',
  version: '1',
  file_name: 'timestamp_1.png',
  width: '200',
  height: '200'
}
```
####Fields
* type: String, mandatory
* action: String, mandatory
* session: String, mandatory
* device: Integer, mandatory
* version: Integer, mandatory
* file_name: String, mandatory
* width: Integer, mandatory
* height: Integer, mandatory
###Response
```ruby
{ picture: { path: 'path', width: '200', height: '200', file_name: 'timestamp_1.png' }, status: true }
```

##Collection
###Request
```ruby
{
  type: 'pictures',
  action: 'collection',
  session: 'session',
  version: '1',
  device: '12345'
}
```
####Fields
* type: String, mandatory
* action: String, mandatory
* session: String, mandatory
* version: Integer, mandatory
* device: Integer, mandatory
###Response
```ruby
[{ picture: { path: 'path1', width: '100', height: '100', file_name: 'timestamp_1.png' }, status: true },
 { picture: { path: 'path2', width: '100', height: '100', file_name: 'timestamp_2.png' }, status: true }]
```

#ERRORS LIST
* Wrong version format
* Unknown packet type
* Session not found
* User not found
* Wrong attempt to login
* Wrong attempt to logout
* Unknown action
* Wrong login
* Wrong password
* Unknown file content type
* Missing file name
* Missing file content
* Missing resize parameters
* Wrong attempt to attach image
* Picture not found
* Wrong attempt to resize image
