package com.bezkoder.spring.security.jwt.models;

import javax.persistence.*;

/**
 * Created by Benjamin Lam on 3/30/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
@Entity
@Table(name = "streams")
public class StreamData {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @OneToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private boolean active;

    public StreamData() {
    }

    public StreamData(User user, String title, String content, boolean active) {
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
