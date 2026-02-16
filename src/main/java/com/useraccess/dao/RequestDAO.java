package com.useraccess.dao;

import com.useraccess.model.Request;
import com.useraccess.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Request entity.
 * Provides CRUD operations for the 'requests' table.
 */
public class RequestDAO {

    /**
     * Create a new access request.
     * @return true if request was created successfully
     */
    public boolean create(Request req) {
        String sql = "INSERT INTO requests (user_id, software_id, access_type, reason, status) " +
                     "VALUES (?, ?, ?, ?, 'Pending')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, req.getUserId());
            ps.setInt(2, req.getSoftwareId());
            ps.setString(3, req.getAccessType());
            ps.setString(4, req.getReason());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Find a request by ID.
     */
    public Request findById(int id) {
        String sql = "SELECT r.id, r.user_id, r.software_id, r.access_type, r.reason, r.status, r.created_at, " +
                     "u.username, s.name AS software_name " +
                     "FROM requests r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN software s ON r.software_id = s.id " +
                     "WHERE r.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all requests (with user and software names).
     */
    public List<Request> findAll() {
        List<Request> list = new ArrayList<>();
        String sql = "SELECT r.id, r.user_id, r.software_id, r.access_type, r.reason, r.status, r.created_at, " +
                     "u.username, s.name AS software_name " +
                     "FROM requests r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN software s ON r.software_id = s.id " +
                     "ORDER BY r.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get all pending requests (for Manager approval view).
     */
    public List<Request> findPending() {
        List<Request> list = new ArrayList<>();
        String sql = "SELECT r.id, r.user_id, r.software_id, r.access_type, r.reason, r.status, r.created_at, " +
                     "u.username, s.name AS software_name " +
                     "FROM requests r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN software s ON r.software_id = s.id " +
                     "WHERE r.status = 'Pending' " +
                     "ORDER BY r.created_at ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get requests by user ID (for Employee to see their own requests).
     */
    public List<Request> findByUserId(int userId) {
        List<Request> list = new ArrayList<>();
        String sql = "SELECT r.id, r.user_id, r.software_id, r.access_type, r.reason, r.status, r.created_at, " +
                     "u.username, s.name AS software_name " +
                     "FROM requests r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN software s ON r.software_id = s.id " +
                     "WHERE r.user_id = ? " +
                     "ORDER BY r.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Update request status (Approve/Reject).
     */
    public boolean updateStatus(int requestId, String newStatus) {
        String sql = "UPDATE requests SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete a request by ID.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM requests WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map a ResultSet row to a Request object.
     */
    private Request mapRow(ResultSet rs) throws SQLException {
        Request req = new Request();
        req.setId(rs.getInt("id"));
        req.setUserId(rs.getInt("user_id"));
        req.setSoftwareId(rs.getInt("software_id"));
        req.setAccessType(rs.getString("access_type"));
        req.setReason(rs.getString("reason"));
        req.setStatus(rs.getString("status"));
        req.setCreatedAt(rs.getTimestamp("created_at"));
        req.setUsername(rs.getString("username"));
        req.setSoftwareName(rs.getString("software_name"));
        return req;
    }
}
