# Spring Boot v3 Keycloak Integration
See [this](https://github.com/Yasas4D/springboot-v3-keycloak/tree/main) repo!  
The Repo has been reworked a bit and tested with Keycloak Version 21.0.2. A keystore with a private key has been used to support TLS 1.3. Also a truststore is provided. For your testing, these two stores need to been generated by yourself; also the keycloak server must be installed somewhere and accessible.

## Get setup
To test the project (assumed a keycloak instance is already running and configured with TLS), first, generate the CA Cert and TLS Cert. Modify the config file in `generate-stores.sh` and execute `chmod u+x generate-stores.sh && ./generate-stores.sh` to generate all material.  
Then modify `application.yml` (`localhost`, `client-id`, `issuer-uri`, ...) to fit your needs.

Now start the Application. 

### Endpoints
Anonymous:
```
[GET] http://localhost:8081/api/test/anonymous
```
Admin:
```
[GET] http://localhost:8081/api/test/admin
Authorization - Bearer Token with admin privileges
```
User:
```
[GET] http://localhost:8081/api/test/user
Authorization - Bearer Token with admin or user privileges
```

<hr>
<br>
Medium Article Link: https://medium.com/geekculture/using-keycloak-with-spring-boot-3-0-376fa9f60e0b
