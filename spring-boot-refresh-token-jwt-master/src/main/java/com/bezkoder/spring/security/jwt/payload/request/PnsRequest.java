package com.bezkoder.spring.security.jwt.payload.request;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
public class PnsRequest {
    private String topic;
    private String title;
    private String content;

    public PnsRequest(String topic, String title, String content) {
        this.topic = topic;
        this.title = title;
        this.content = content;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }
}
