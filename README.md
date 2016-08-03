# GET /users
get list of all users for testing purpose

# POST /users
user creation, allowed for all

```javascript
{
  "name": "Jonh",
  "type": "manager"
}
```

# GET /tasks?token=!231342fsafasf==&lat=34.323&lng=32.312
allowed for drivers

# POST /tasks
task creation, only allowed for managers

```javascript
{  "task":
   {
     "description": "Some awesome task",
     "pickup": [12.12, 13.13],
     "delivery": [13.12, 13,14]
   },
   "token": "Ufo1De5LfqvL9vSyTJh16w=="
}
```

# PUT /tasks/assign
allowed for driver; task must have new state
id is for task id

```javascript
{
  "token": "GAdf134gdfg234==",
  "id": "_1231fsadf324wqf"
}
```

# PUT /tasks/done
allowed for driver; task must be assigned by same user
id is for task id

```javascript
{
  "token": "GAdf134gdfg234==",
  "id": "_1231fsadf324wqf"
}
```
