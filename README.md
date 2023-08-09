# Tweetable: Your Microblogging Prototype

Welcome to **Tweetable**, a captivating microblogging prototype that allows users to express themselves in bite-sized bursts of information. With a seamless account creation process, social authentication, and engaging features, Tweetable offers a delightful experience that mirrors the essence of Twitter.

## Experience the Prototype

Explore the prototype here: [Tweetable Prototype](https://tweetable.onrender.com/)

## Getting Started

To delve into the magic of Tweetable, follow these simple steps:

1. **Clone the Repository**: Get started by cloning the repository to your local machine:

   ```shell
   git clone git@github.com:kevinronu/tweetable-rest-api.git
   cd tweetable-rest-api
   ```

2. **Check Your Ruby Version**: Ensure you have the correct Ruby version installed:

   ```shell
   ruby -v
   ```

   If you don't have the right version, no worries. You can install it using [rbenv](https://github.com/rbenv/rbenv):

   ```shell
   rbenv install 3.1.4
   ```

3. **Install Dependencies**: Run the following command to install the necessary dependencies:

   ```shell
   bundle install
   ```

4. **Set Up Environment Variables**: For seamless integration, configure your OAuth Apps by visiting [GitHub OAuth Apps](https://github.com/settings/developers). Refer to the [.env.example](https://github.com/kevinronu/tweetable-rest-api/blob/main/.env.example) file for details.

5. **Initialize the Database**: Prepare the database for action:

   ```shell
   rails db:create db:migrate db:seed
   ```

6. **Start the Server**: Launch the Tweetable server and kick-start your microblogging journey:

   ```shell
   rails s
   ```

7. **Insomnia API Testing**: To explore and test the API, import the [tweetable_insomnia.json](https://github.com/kevinronu/tweetable-rest-api/blob/main/tweetable_insomnia.json) file into your Insomnia workspace.

## Join the Conversation

Tweetable offers an immersive experience that brings people closer together through the art of microblogging. Join us today, and let your voice be heard!

---

_Note: Tweetable is a prototype and does not encompass the full functionality of Twitter. It serves as a proof of concept and technology demonstration._
