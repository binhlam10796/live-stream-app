package com.bezkoder.spring.security.jwt.repository;

import com.bezkoder.spring.security.jwt.models.StreamData;
import com.bezkoder.spring.security.jwt.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * SELF EDU
 * binhlam10796@gmail.com
 */
@Repository
public interface StreamRepository extends JpaRepository<StreamData, Long> {

    List<StreamData> findByUser(User user);
}
