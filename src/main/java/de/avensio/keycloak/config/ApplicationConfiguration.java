package de.avensio.keycloak.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.security.concurrent.DelegatingSecurityContextExecutorService;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

// Neue Implementierung des AsyncConfigurerSupport um den SecurityContext auch in asynchronen Aufrufen verfügbar zu haben
@Configuration
public class ApplicationConfiguration implements AsyncConfigurer {
    @Override
    public Executor getAsyncExecutor() {
        return new DelegatingSecurityContextExecutorService(Executors.newFixedThreadPool(5));
    }
}
