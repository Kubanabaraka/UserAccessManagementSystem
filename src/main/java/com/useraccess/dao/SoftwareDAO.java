package com.useraccess.dao;

import com.useraccess.model.Software;
import com.useraccess.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Software entity.
 * Provides CRUD operations for the 'software' table.
 */
public class SoftwareDAO {

    /**
     * Create a new software entry.
     * @return true if software was created successfully
     */
    public boolean create(Software software) {
        String sql = "INSERT INTO software (name, description, access_levels) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, software.getName());
            ps.setString(2, software.getDescription());
            ps.setString(3, software.getAccessLevels());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            if ("23505".equals(e.getSQLState())) {
                // Duplicate key - software name already exists
                return false;
            }
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Find software by ID.
     */
    public Software findById(int id) {
        String sql = "SELECT id, name, description, access_levels FROM software WHERE id = ?";
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
     * Find software by name.
     */
    public Software findByName(String name) {
        String sql = "SELECT id, name, description, access_levels FROM software WHERE name = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
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
     * Get all software entries.
     */
    public List<Software> findAll() {
        List<Software> list = new ArrayList<>();
        String sql = "SELECT id, name, description, access_levels FROM software ORDER BY id";
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
     * Update an existing software entry.
     */
    public boolean update(Software software) {
        String sql = "UPDATE software SET name = ?, description = ?, access_levels = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, software.getName());
            ps.setString(2, software.getDescription());
            ps.setString(3, software.getAccessLevels());
            ps.setInt(4, software.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete software by ID.
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM software WHERE id = ?";
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
     * Map a ResultSet row to a Software object.
     */
    private Software mapRow(ResultSet rs) throws SQLException {
        Software sw = new Software();
        sw.setId(rs.getInt("id"));
        sw.setName(rs.getString("name"));
        sw.setDescription(rs.getString("description"));
        sw.setAccessLevels(rs.getString("access_levels"));
        return sw;
    }
}
