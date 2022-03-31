package com.bezkoder.spring.security.jwt.service;

import com.bezkoder.spring.security.jwt.payload.request.PnsRequest;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import org.springframework.stereotype.Service;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
@Service
public class FCMService {

    public String pushNotification(PnsRequest pnsRequest) {
        Message message = Message.builder()
                .setTopic(String.valueOf(pnsRequest.getTopic()))
                .putData("content", pnsRequest.getTitle())
                .putData("body", pnsRequest.getContent())
                .build();

        String response = null;
        try {
            response = FirebaseMessaging.getInstance().send(message);
        } catch (FirebaseMessagingException e) {
            e.printStackTrace();
        }
        return response;
    }
}
