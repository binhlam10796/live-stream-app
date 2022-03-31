package com.bezkoder.spring.security.jwt.repository;

import com.bezkoder.spring.security.jwt.models.StreamData;
import com.bezkoder.spring.security.jwt.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
@Repository
public interface StreamRepository extends JpaRepository<StreamData, Long> {

    List<StreamData> findByUser(User user);
}
