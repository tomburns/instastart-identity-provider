# Instastart Identity Provider

This is a Rails app that provides a ready-to-deploy, sample Identity Provider which can be used with any Layer application. This README assumes that you are familiar with the structure of Rails applications, including routes and MVC.

# What is an Identity Provider?

An Identity Provider manages a user database and responds to authentication requests from Layer apps. Layer uses a _federated_ identity system, which means that users don't register or login to Layer; instead, we ask your server to confirm if a user is allowed to login or not. This repo provides such a server, and can be extended to meet your requirements. See our [Technical Overview](https://docs.layer.com/sdk/ios/introduction#2-user-management-identity-provider) for more information about user management and identity providers.

# What does this Identity Provider provide?

Out of the box, this Identity Provider does three things:

* [Connects to a database](config/database.yml) and [sets up a `users` table](db/migrate/20160930212656_create_users.rb) to store your list of users
* [Provides a basic UI](app/controllers/users_controller.rb) to view, create, and edit user entries in your database
* [Accepts authentication requests](app/controllers/authentication_controller.rb) from Layer sample apps and responds with with an _identity token_
* Automatically creates [an identity](https://docs.layer.com/reference/server_api/identities.out) when a User record is created
* Automatically [follows](https://docs.layer.com/reference/server_api/identities.out#following-a-user) other users when a new User record is created (only applies to first 10 created users by default)

A few [HTTP routes](config/routes.rb) are specified:

* `GET /` renders the homepage, which contains basic status information about your server and links to additional resources
* `GET /deployed` renders the string `"ok"` and HTTP status `200` as a health check
* `GET /users` renders a list of all the users currently in the database
* `GET /users/:id` renders the fields for a particular user in the database, specified by the `:id` parameter
* `POST /users` inserts a new entry into the `users` table containing the provided HTTP parameters
* `GET /users/:id/edit` renders a form allowing you to edit the fields stored for a particular user
* `PATCH /users/:id` saves changes, provided via HTTP parameters, for the specified user in the database
* `POST /authenticate` generates a [JWT](https://jwt.io) _identity token_ when provided with valid credentials (see below) and a `nonce`.

## User Authentication

The `POST /authenticate` endpoint expects three parameters: `email`, `password`, and `nonce`. This models a typical email-and-password login in an app. The `email` should correspond to an existing record in the `users` table. The `password` will be hashed ([using bcrypt](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password)) and checked against the `password_digest` field of that user record. If they match, the Identity Provider will use the provided `nonce` to generate an [identity token](https://docs.layer.com/sdk/ios/authentication#identity-token) (the Identity Provider does not verify that the `nonce` is well-formed or valid).

If the email and password are valid, the response looks like `{"identity_token": "<IDENTITY TOKEN AS A STRING>"}`. If not, the response will be `{"error": "<A DESCRIPTION OF THE ERROR>"}` and HTTP status `401`.

# Deployment

This app can be deployed on any server which can run Ruby 2.3 and PostgreSQL. It is easiest to deploy to [Heroku](https://www.heroku.com/what), which you can do for free:

* [Click this link](https://heroku.com/deploy?template=https://github.com/layerhq/instastart-identity-provider/tree/master) (this is configured in [app.json](app.json))
* Fill in the `ENV` variables at the bottom of the page with the keys from your [Layer developer dashboard](https://developer.layer.com/projects/keys). You will also need to [generate an RSA keypair](https://rietta.com/blog/2012/01/27/openssl-generating-rsa-key-from-command/) and paste the entire private key (including the `-----BEGIN RSA PRIVATE KEY-----` header and `-----END RSA PRIVATE KEY-----` footer) in the `LAYER_PRIVATE_KEY` field.
* Click the purple "Deploy" button; Heroku will take care of the rest. When it's finished, click "View app" to make sure everything is running.
