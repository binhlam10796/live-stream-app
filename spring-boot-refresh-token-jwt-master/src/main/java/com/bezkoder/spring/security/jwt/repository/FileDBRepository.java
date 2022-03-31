package com.bezkoder.spring.security.jwt.repository;

import com.bezkoder.spring.security.jwt.models.FileDB;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Benjamin Lam on 3/29/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
@Repository
public interface FileDBRepository extends JpaRepository<FileDB, String> {

}
