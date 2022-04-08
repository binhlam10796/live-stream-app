package com.bezkoder.spring.security.jwt.controllers;

import com.bezkoder.spring.security.jwt.payload.request.ApproveRequest;
import com.bezkoder.spring.security.jwt.payload.request.PnsRequest;
import com.bezkoder.spring.security.jwt.payload.request.StreamRequest;
import com.bezkoder.spring.security.jwt.payload.response.MessageResponse;
import com.bezkoder.spring.security.jwt.payload.response.StreamResponse;
import com.bezkoder.spring.security.jwt.service.FCMService;
import com.bezkoder.spring.security.jwt.service.StreamService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * SELF EDU
 * binhlam10796@gmail.com
 */
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/stream")
public class StreamController {

    @Autowired
    private StreamService streamService;

    @Autowired
    private FCMService fcmService;

    @PostMapping("/upload")
    public ResponseEntity<MessageResponse> uploadNewStream(@Valid @RequestBody StreamRequest streamRequest) {
        String message = "";
        long streamID = streamService.store(streamRequest);

        ObjectMapper mapper = new ObjectMapper();
        try {
            String json = mapper.writeValueAsString(streamRequest);
            System.out.println("ResultingJSONstring = " + json);
            PnsRequest pnsRequest = new PnsRequest(
                    "admin",
                    "Detected new stream",
                    json
            );
            fcmService.pushNotification(pnsRequest);
            message = "Create new stream request successfully: " + streamID;
            return ResponseEntity.status(HttpStatus.OK).body(new MessageResponse(message));
        } catch (JsonProcessingException e) {
            message = "Create new stream request failure: " + streamID;
            return ResponseEntity.status(HttpStatus.OK).body(new MessageResponse(message));
        }
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/approve")
    public ResponseEntity<MessageResponse> approveStream(@Valid @RequestBody ApproveRequest approveRequest) {
        String message = "";
        long streamID = streamService.update(approveRequest);

        ObjectMapper mapper = new ObjectMapper();
        try {
            String json = mapper.writeValueAsString(approveRequest);
            System.out.println("ResultingJSONstring = " + json);
            PnsRequest pnsRequest = new PnsRequest(
                    String.valueOf(approveRequest.getUserID()),
                    approveRequest.isActive() ? "Approved stream" : "Refused stream",
                    json
            );
            fcmService.pushNotification(pnsRequest);
            message = "Approve stream request successfully: " + streamID;
            return ResponseEntity.status(HttpStatus.OK).body(new MessageResponse(message));
        } catch (JsonProcessingException e) {
            message = "Approve stream request failure: " + streamID;
            return ResponseEntity.status(HttpStatus.OK).body(new MessageResponse(message));
        }
    }

    @GetMapping("/by-user")
    public ResponseEntity<List<StreamResponse>> getStreamsByUser(@RequestParam long userID) {
        List<StreamResponse> streams = streamService.getStreamsByUser(userID).map(streamData -> new StreamResponse(
                streamData.getId(),
                streamData.getUser(),
                streamData.getTitle(),
                streamData.getContent(),
                streamData.isActive())).collect(Collectors.toList());

        return ResponseEntity.status(HttpStatus.OK).body(streams);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/all-stream")
    public ResponseEntity<List<StreamResponse>> getAllStream() {
        List<StreamResponse> streams = streamService.getAllStreams().map(streamData -> new StreamResponse(
                streamData.getId(),
                streamData.getUser(),
                streamData.getTitle(),
                streamData.getContent(),
                streamData.isActive())).collect(Collectors.toList());

        return ResponseEntity.status(HttpStatus.OK).body(streams);
    }
}
