# README

* Start the app:
  * `docker-compose up`
  * visit localhost:3000
* Open a dev terminal while app is running:
  * `docker-compose exec web bash`
* Dev environment
  * save your open weather api key in your .env in the project root
    * OWM_API_KEY=1234567890abcdef
  * Dockerfile-dev is configured to write code changes to your host
    * You can run rails commands from the dev terminal
    * NO local ruby/rails env required
* Testing (from dev terminal)
  * `rails test`


