package com.escuelita.www.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfig {
    
    //Bean del paquete que permite hacer peticiones a endpoints de terceros
    //En este caso a decolecta.com
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
