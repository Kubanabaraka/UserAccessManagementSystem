package com.useraccess.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Request JavaBean - represents an access request in the system.
 * Maps to the 'requests' table in the database.
 */
public class Request implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private int softwareId;
    private String accessType;  // Read, Write, Admin
    private String reason;
    private String status;      // Pending, Approved, Rejected
    private Timestamp createdAt;

    // Joined fields for display
    private String username;
    private String softwareName;

    public Request() {}

    public Request(int id, int userId, int softwareId, String accessType,
                   String reason, String status, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.softwareId = softwareId;
        this.accessType = accessType;
        this.reason = reason;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getSoftwareId() { return softwareId; }
    public void setSoftwareId(int softwareId) { this.softwareId = softwareId; }

    public String getAccessType() { return accessType; }
    public void setAccessType(String accessType) { this.accessType = accessType; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getSoftwareName() { return softwareName; }
    public void setSoftwareName(String softwareName) { this.softwareName = softwareName; }

    @Override
    public String toString() {
        return "Request{id=" + id + ", userId=" + userId + ", softwareId=" + softwareId +
               ", accessType='" + accessType + "', status='" + status + "'}";
    }
}
