### @SpringBootApplication注解
 `@SpringBootApplication `是`@Configuration`、`@EnableAutoConfiguration`、`@ComponentScan `注解的集合  
 这三个注解的作用分别是：  
- `@EnableAutoConfiguration`：启用 SpringBoot 的自动配置机制
- `@ComponentScan`： 扫描被`@Component` (`@Service`,`@Controller`)注解的bean，注解默认会扫描该类所在的包下所有的类。
- `@Configuration`：允许在上下文中注册额外的bean或导入其他配置类

### @Conditional注解
在满足指定条件的时候才将某个 bean 加载到应用上下文中，示例
```java
@Configuration
@EnableConfigurationProperties(value = { SwaggerProperties.class })//生成时加载配置文件到 Properties bean
@ConditionalOnProperty(name = "swagger.enable",havingValue = "true")//当存在该属性并且值为true时配置bean才生成
```