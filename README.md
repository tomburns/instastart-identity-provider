# Quickstart Identity Provider

Stuff you should know:

* This can be deployed to Heroku. [Click this link](https://heroku.com/deploy?template=https://github.com/layerhq/quickstart-identity-provider/tree/master&env[LAYER_KEY_ID]=blahblah-blah-blah-blahblah&env[LAYER_PROVIDER_ID]=bacon) and fill in the correct env variables. The deploy is configured in [`app.json`](blob/master/app.json); schema [documented here](https://devcenter.heroku.com/articles/app-json-schema)
* Upon deploy, the database will be [seeded with these values](blob/master/db/seeds.rb)
* `GET /deployed` should render the string `"ok"` and HTTP status `200` as a health check
* `GET /users` returns a JSON object: `{"users": [<user>,<user>,…]}`, where each `<user>` has an `id`, `email`, `first_name`, `last_name`, `display_name`, and `avatar_url` field (all strings)
* [`POST /authenticate`](blob/master/app/controllers/authentication_controller.rb) will return an identity token. Params should be `nonce`, `email` and `password`, matching one of the seeded users. Response is `{"identity_token": "blahtokenstring"}` and HTTP status `200` if `email` and `password` are valid, or an empty `identity_token` string and HTTP status `401` if not.