# live-stream-app
The instruction can be found at:
[Live Stream App With Spring Boot And Firebase push notification](https://youtu.be/jAneqBOoW_o)
## Backend source structure
### Sử dụng Spring Boot JPA theo cấu trúc được chia thành các phần
`Controller`
`Advice`
`Exception`
`Models`
`Payload`
`Repository`
`Service`
`Security`

## Front end source structure
### Sử dụng Flutter theo mô hình Bloc Pattern được chia thành từng module riêng lẻ
### Trong từng model chứa các thành phần với các chức năng riêng biệt nhau
`Bloc` sử lý các logic dựa và các sự kiện (event) nhận từ các screen và trả trạng
thái theo các state cụ thể được định nghĩa trước đó
`Model` chức các object dùng để map vào các kiểu dữ liệu json trả về từ API hoặc
các object dùng cho việc truyền vào các API gửi đi.
`Repository` đóng vai trò như cầu nối từ ứng dụng đến API server
`Screen` chứa giao diện ứng dụng người dùng
### Ngoài ra trong cấu trúc còn các thành phần common được tái sử dụng lại nhiều lần
`Constants` chứa các object, variable, state, key được sử dụng ở nhiều nơi
`Utils` chứa các tiện ích được định nghĩa sẵn để tối ưu hoá việc
tránh phát sinh các hàm trùng nhau vì một tính năng cụ thể
`Widgets` chứa các Widgets trong Flutter được custom lại theo giao diện từ phía UI/UX

## Initialize database live_stream_app
![Screenshot 2022-03-30 160224](https://user-images.githubusercontent.com/42068261/161008277-cd3f9f24-3adf-4f33-aa2d-32c66873a31a.png)
### Table files
```
CREATE TABLE `files` (
 `id` varchar(255) NOT NULL,
 `data` mediumblob NOT NULL,
 `name` varchar(255) NOT NULL,
 `type` varchar(255) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
```
### Table users
```
CREATE TABLE `users` (
 `id` double NOT NULL AUTO_INCREMENT,
 `email` varchar(50) NOT NULL,
 `password` varchar(120) NOT NULL,
 `first_name` varchar(255) NOT NULL,
 `last_name` varchar(255) NOT NULL,
 `birthday` varchar(255) NOT NULL,
 `address` varchar(255) NOT NULL,
 `file` varchar(255) NOT NULL,
 `username` varchar(20) DEFAULT NULL,
 PRIMARY KEY (`id`),
 UNIQUE KEY `email` (`email`),
 UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
 UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`),
 KEY `file` (`file`),
 CONSTRAINT `users_ibfk_1` FOREIGN KEY (`file`) REFERENCES `files` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4
```
### Table refresh_token
```
CREATE TABLE `refresh_token` (
 `id` double NOT NULL AUTO_INCREMENT,
 `user_id` double NOT NULL,
 `token` text NOT NULL,
 `expiry_date` datetime NOT NULL,
 PRIMARY KEY (`id`),
 KEY `user_id` (`user_id`),
 CONSTRAINT `refresh_token_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4
```
### Table roles
```
CREATE TABLE `roles` (
 `id` double NOT NULL AUTO_INCREMENT,
 `name` varchar(255) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='Roles data'
```
### Table streams
```
CREATE TABLE `streams` (
 `id` double NOT NULL AUTO_INCREMENT,
 `user_id` double NOT NULL,
 `content` text NOT NULL,
 `active` tinyint(1) NOT NULL,
 `title` text NOT NULL,
 PRIMARY KEY (`id`),
 KEY `user_id` (`user_id`),
 CONSTRAINT `streams_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4
```
### Table user_roles
```
CREATE TABLE `user_roles` (
 `user_id` double NOT NULL,
 `role_id` double NOT NULL,
 PRIMARY KEY (`role_id`,`user_id`) USING BTREE,
 KEY `user_id` (`user_id`),
 CONSTRAINT `FKh8ciramu9cc9q3qcqiv4ue8a6` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
 CONSTRAINT `FKhfh9dx7w3ubf1co1vdev94g3f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
 CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
 CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
 CONSTRAINT `user_roles_ibfk_3` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
 CONSTRAINT `user_roles_ibfk_4` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
```

## Configure Spring Datasource, JPA, App properties
Open `src/main/resources/application.properties`

```properties
spring.datasource.url= jdbc:mysql://localhost:3306/live_stream_app?useSSL=false
spring.datasource.username= root
spring.datasource.password= 123456

spring.jpa.properties.hibernate.dialect= org.hibernate.dialect.MySQL5InnoDBDialect
spring.jpa.hibernate.ddl-auto= update

# App Properties
binhldq.app.jwtSecret= bezKoderSecretKey
binhldq.app.jwtExpirationMs= 3600000
binhldq.app.jwtRefreshExpirationMs= 86400000
```

## Run Spring Boot application
Go to Spring Boot folder `spring-boot-refresh-token-jwt-master`
```
mvn spring-boot:run
```

## Run following SQL insert statements
```
INSERT INTO roles(name) VALUES('ROLE_USER');
INSERT INTO roles(name) VALUES('ROLE_MODERATOR');
INSERT INTO roles(name) VALUES('ROLE_ADMIN');
```

## Final -> Run Flutter application
