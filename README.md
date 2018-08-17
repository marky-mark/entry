# entry
A handy entry script for docker containers which need to wait on other services to be up for docker compose.

## How it works
Before executing the jar, has some awaitility if preceded by "wait <number_of_apps> <app_address> <app_port> <app_name>"
The jar will not get executed unless these addresses can be reached.
After this the arguments are trimmed off and any trailing arguments will be passed as command line arguments to be executed.

Example:
`wait 2 localhost 9042 cassandra localhost 8080 myapp java -jar app.jar -DFOO=bar` 
