package com.bezkoder.spring.security.jwt.controllers;

import com.bezkoder.spring.security.jwt.payload.request.PnsRequest;
import com.bezkoder.spring.security.jwt.service.FCMService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/pns")
public class PnsController {

    @Autowired
    private FCMService fcmService;

    @PostMapping("/notification")
    public String sendSampleNotification(@RequestBody PnsRequest pnsRequest) {
        return fcmService.pushNotification(pnsRequest);
    }
}
