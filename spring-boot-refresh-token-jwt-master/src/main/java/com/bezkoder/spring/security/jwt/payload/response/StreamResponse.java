package com.bezkoder.spring.security.jwt.payload.response;

import com.bezkoder.spring.security.jwt.models.User;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
public class StreamResponse {
    private long id;
    private User user;
    private String title;
    private String content;
    private boolean active;

    public StreamResponse(long id, User user, String title, String content, boolean active) {
        this.id = id;
        this.user = user;
        this.title = title;
        this.content = content;
        this.active = active;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
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

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
