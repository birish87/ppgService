Here is how we might invoke a jar file built from this solution:
java -Dserver.port=6492 -jar C:\path\to\theJarFile.jar


For example, my invocation looked like:

java -Dserver.port=6492 -jar C:\Users\birish\IdeaProjects\demo\classes\artifacts\com_example_demo_jar\ppgRestService.jar



If the jar doesn't run, you may need java installed on your machine. I can assist with that.

See also the json postman collection which contains some sample web calls & syntax found here: src>main>resources>
ppgServiceDemo.postman_collection_General.json

Just update your username and password to match your db usrname and pwd.

Note, /ctrlQuery endpoint takes login credentials, and an 'alias' parameter which references the 'name' of a query,
likely found in the postgres db > QA_QUERIES table (note, one of the columns is 'name' in that table). This table location
is tentative, but that is where the 'versioned' queries
should be existing at the time of the initial draft of this README.md you're reading.

the /adhocQuery endpoint also take login credential parameters, but here, you can pass in a 'customQuery' parameter, the
value of which is whatever custom query you want to run.

