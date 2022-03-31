package com.bezkoder.spring.security.jwt.payload.request;

import javax.validation.constraints.NotNull;

/**
 * Created by Benjamin Lam on 3/31/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
public class ApproveRequest {

    @NotNull
    private long streamID;

    @NotNull
    private long userID;

    @NotNull
    private boolean active;

    public long getStreamID() {
        return streamID;
    }

    public void setStreamID(long streamID) {
        this.streamID = streamID;
    }

    public long getUserID() {
        return userID;
    }

    public void setUserID(long userID) {
        this.userID = userID;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
