package com.bezkoder.spring.security.jwt.payload.response;

/**
 * Created by Benjamin Lam on 3/29/2022.
 * VNPT-IT KV5 LTD
 * binhldq.tgg@vnpt.vn
 */
public class FileResponse {
    private String name;
    private String url;
    private String type;
    private long size;

    public FileResponse(String name, String url, String type, long size) {
        this.name = name;
        this.url = url;
        this.type = type;
        this.size = size;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public long getSize() {
        return size;
    }

    public void setSize(long size) {
        this.size = size;
    }

}
