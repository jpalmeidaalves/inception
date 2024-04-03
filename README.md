# Inception

Embarking on a 42 project dedicated to mastering Docker and Docker-compose, the task at hand is to construct a structure to serve a wordpress site with three Docker containers. One container hosts Nginx, another accommodates Wordpress, while the third houses MariaDB. The ultimate aim is to orchestrate seamless collaboration among these containers over the Docker network, culminating in the display of a functioning local website.


## Usage

Launching this project requires a bit of setup:

* Clone this repository and `cd` into it.
* In the `srcs` folder, there is an `ExampleEnvFile` that must be filled out and saved into `srcs/.env`
* The Makefile has a `login` variable that should be edited to reflect your 42 school login

Once these steps are complete, you can use `make` to build and launch the docker containers.

The website should be viewable at the adresses `https://localhost` or `http://login.42.fr` (replacing your login with the value in the Makefile variable).
