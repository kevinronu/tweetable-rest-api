# Tweetable

[https://tweetable.onrender.com/](https://tweetable.onrender.com/)

### Clone the repository

```shell
git clone git@github.com:kevinronu/tweetable-rest-api.git
cd tweetable-rest-api
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 3.1.4`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 3.1.4
```

## Install

```shell
bundle install
```

### Set environment variables

Using [OAuth Apps](https://github.com/settings/developers):

See [.env.example](https://github.com/kevinronu/tweetable-rest-api/blob/main/.env.example).

### Initialize the database

```shell
rails db:create db:migrate db:seed
```

## Init server

```shell
rails s
```

## Import to Insomnia

To test the API import this file into insomnia: [tweetable_insomnia](https://github.com/kevinronu/tweetable-rest-api/blob/main/tweetable_insomnia.json).
