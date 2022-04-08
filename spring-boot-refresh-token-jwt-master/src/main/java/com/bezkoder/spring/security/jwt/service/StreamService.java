package com.bezkoder.spring.security.jwt.service;

import com.bezkoder.spring.security.jwt.models.StreamData;
import com.bezkoder.spring.security.jwt.payload.request.ApproveRequest;
import com.bezkoder.spring.security.jwt.payload.request.StreamRequest;
import com.bezkoder.spring.security.jwt.repository.StreamRepository;
import com.bezkoder.spring.security.jwt.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.stream.Stream;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * SELF EDU
 * binhlam10796@gmail.com
 */
@Service
public class StreamService {

    @Autowired
    StreamRepository streamRepository;

    @Autowired
    UserRepository userRepository;

    public long store(StreamRequest streamRequest) {
        StreamData streamData = new StreamData(
                userRepository.findById(streamRequest.getUserId()).get(),
                streamRequest.getTitle(),
                streamRequest.getContent(),
                false
        );
        return streamRepository.save(streamData).getId();
    }

    public long update(ApproveRequest approveRequest) {
        StreamData streamFromDB = streamRepository.findById(approveRequest.getStreamID()).get();
        streamFromDB.setActive(approveRequest.isActive());
        return streamRepository.save(streamFromDB).getId();
    }

    public Stream<StreamData> getAllStreams() {
        return streamRepository.findAll().stream();
    }

    public Stream<StreamData> getStreamsByUser(long userID) {
        return streamRepository.findByUser(userRepository.findById(userID).get()).stream();
    }
}
