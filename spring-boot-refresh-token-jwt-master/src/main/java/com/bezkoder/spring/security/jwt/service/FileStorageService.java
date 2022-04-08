package com.bezkoder.spring.security.jwt.service;

import com.bezkoder.spring.security.jwt.models.FileDB;
import com.bezkoder.spring.security.jwt.repository.FileDBRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.stream.Stream;

/**
 * Created by Benjamin Lam on 3/29/2022.
 * SELF EDU
 * binhlam10796@gmail.com
 */
@Service
public class FileStorageService {

    @Autowired
    private FileDBRepository fileDBRepository;

    public String store(MultipartFile file) throws IOException {
        String fileName = StringUtils.cleanPath(file.getOriginalFilename());
        FileDB FileDB = new FileDB(fileName, file.getContentType(), file.getBytes());

        return fileDBRepository.save(FileDB).getId();
    }

    public FileDB getFile(String id) {
        return fileDBRepository.findById(id).get();
    }

    public Stream<FileDB> getAllFiles() {
        return fileDBRepository.findAll().stream();
    }
}
