import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class ExportCurrentSchema {
    record Column(
            String tableName,
            String columnName,
            String dataType,
            Integer dataLength,
            Integer dataPrecision,
            Integer dataScale,
            String nullable,
            String dataDefault,
            String comment) {
    }

    record ConstraintDef(String name, String tableName, String type, List<String> columns, String rName) {
    }

    record ForeignKey(
            String name,
            String tableName,
            List<String> columns,
            String refTableName,
            List<String> refColumns,
            String deleteRule) {
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 4) {
            throw new IllegalArgumentException("Usage: java ExportCurrentSchema <url> <user> <password> <outputDir>");
        }

        String url = args[0];
        String user = args[1];
        String password = args[2];
        Path outputDir = Path.of(args[3]);
        Files.createDirectories(outputDir);

        Class.forName("oracle.jdbc.OracleDriver");
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            Map<String, List<Column>> tables = readColumns(conn);
            Map<String, ConstraintDef> constraints = readConstraints(conn);
            List<ForeignKey> foreignKeys = readForeignKeys(conn, constraints);

            String exportedAt = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            Files.writeString(outputDir.resolve("current_schema.sql"), buildDdl(tables, constraints, foreignKeys, user, exportedAt), StandardCharsets.UTF_8);
            Files.writeString(outputDir.resolve("current_erd.md"), buildMermaid(tables, constraints, foreignKeys, user, exportedAt), StandardCharsets.UTF_8);
            Files.writeString(outputDir.resolve("current_erd.html"), buildHtml(tables, constraints, foreignKeys, user, exportedAt), StandardCharsets.UTF_8);
            Files.writeString(outputDir.resolve("schema_summary.txt"), buildSummary(tables, constraints, foreignKeys, user, exportedAt), StandardCharsets.UTF_8);
            System.out.printf("Exported %d tables, %d constraints, %d foreign keys to %s%n",
                    tables.size(), constraints.size(), foreignKeys.size(), outputDir.toAbsolutePath());
        }
    }

    private static Map<String, List<Column>> readColumns(Connection conn) throws SQLException {
        String sql = """
                SELECT c.table_name,
                       c.column_name,
                       c.data_type,
                       c.data_length,
                       c.data_precision,
                       c.data_scale,
                       c.nullable,
                       c.data_default,
                       cc.comments
                  FROM user_tab_columns c
                  LEFT JOIN user_col_comments cc
                    ON cc.table_name = c.table_name
                   AND cc.column_name = c.column_name
                 WHERE c.table_name NOT LIKE 'BIN$%'
                 ORDER BY c.table_name, c.column_id
                """;
        Map<String, List<Column>> tables = new TreeMap<>();
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Column c = new Column(
                        rs.getString("table_name"),
                        rs.getString("column_name"),
                        rs.getString("data_type"),
                        intOrNull(rs, "data_length"),
                        intOrNull(rs, "data_precision"),
                        intOrNull(rs, "data_scale"),
                        rs.getString("nullable"),
                        rs.getString("data_default"),
                        rs.getString("comments"));
                tables.computeIfAbsent(c.tableName(), k -> new ArrayList<>()).add(c);
            }
        }
        return tables;
    }

    private static Map<String, ConstraintDef> readConstraints(Connection conn) throws SQLException {
        String sql = """
                SELECT uc.constraint_name,
                       uc.table_name,
                       uc.constraint_type,
                       uc.r_constraint_name,
                       ucc.column_name,
                       ucc.position
                  FROM user_constraints uc
                  JOIN user_cons_columns ucc
                    ON ucc.constraint_name = uc.constraint_name
                   AND ucc.table_name = uc.table_name
                 WHERE uc.constraint_type IN ('P', 'U', 'R')
                   AND uc.table_name NOT LIKE 'BIN$%'
                 ORDER BY uc.constraint_name, ucc.position
                """;
        Map<String, ConstraintDef> constraints = new LinkedHashMap<>();
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                String name = rs.getString("constraint_name");
                ConstraintDef existing = constraints.get(name);
                if (existing == null) {
                    existing = new ConstraintDef(
                            name,
                            rs.getString("table_name"),
                            rs.getString("constraint_type"),
                            new ArrayList<>(),
                            rs.getString("r_constraint_name"));
                    constraints.put(name, existing);
                }
                existing.columns().add(rs.getString("column_name"));
            }
        }
        return constraints;
    }

    private static List<ForeignKey> readForeignKeys(Connection conn, Map<String, ConstraintDef> constraints) throws SQLException {
        String sql = """
                SELECT uc.constraint_name,
                       uc.table_name,
                       uc.r_constraint_name,
                       uc.delete_rule
                  FROM user_constraints uc
                 WHERE uc.constraint_type = 'R'
                   AND uc.table_name NOT LIKE 'BIN$%'
                 ORDER BY uc.table_name, uc.constraint_name
                """;
        List<ForeignKey> fks = new ArrayList<>();
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                ConstraintDef fk = constraints.get(rs.getString("constraint_name"));
                ConstraintDef ref = constraints.get(rs.getString("r_constraint_name"));
                if (fk != null && ref != null) {
                    fks.add(new ForeignKey(
                            fk.name(),
                            fk.tableName(),
                            fk.columns(),
                            ref.tableName(),
                            ref.columns(),
                            rs.getString("delete_rule")));
                }
            }
        }
        return fks;
    }

    private static String buildDdl(
            Map<String, List<Column>> tables,
            Map<String, ConstraintDef> constraints,
            List<ForeignKey> foreignKeys,
            String user,
            String exportedAt) {
        StringBuilder sb = new StringBuilder();
        sb.append("-- Current Oracle schema export\n");
        sb.append("-- User: ").append(user).append('\n');
        sb.append("-- Exported at: ").append(exportedAt).append("\n\n");

        for (Map.Entry<String, List<Column>> entry : tables.entrySet()) {
            sb.append("CREATE TABLE \"").append(entry.getKey()).append("\" (\n");
            List<String> lines = new ArrayList<>();
            for (Column c : entry.getValue()) {
                StringBuilder line = new StringBuilder();
                line.append("    \"").append(c.columnName()).append("\" ").append(typeSql(c));
                if (c.dataDefault() != null && !c.dataDefault().isBlank()) {
                    line.append(" DEFAULT ").append(normalizeDefault(c.dataDefault()));
                }
                line.append(" ").append("N".equals(c.nullable()) ? "NOT NULL" : "NULL");
                lines.add(line.toString());
            }
            sb.append(String.join(",\n", lines));
            sb.append("\n);\n\n");
        }

        for (ConstraintDef c : constraints.values()) {
            if (!"P".equals(c.type()) && !"U".equals(c.type())) {
                continue;
            }
            String label = "P".equals(c.type()) ? "PRIMARY KEY" : "UNIQUE";
            sb.append("ALTER TABLE \"").append(c.tableName()).append("\" ADD CONSTRAINT \"")
                    .append(c.name()).append("\" ").append(label).append(" (")
                    .append(quotedList(c.columns())).append(");\n\n");
        }

        for (ForeignKey fk : foreignKeys) {
            sb.append("ALTER TABLE \"").append(fk.tableName()).append("\" ADD CONSTRAINT \"")
                    .append(fk.name()).append("\" FOREIGN KEY (").append(quotedList(fk.columns())).append(")\n")
                    .append("REFERENCES \"").append(fk.refTableName()).append("\" (").append(quotedList(fk.refColumns())).append(")");
            if ("CASCADE".equalsIgnoreCase(fk.deleteRule())) {
                sb.append("\nON DELETE CASCADE");
            } else if ("SET NULL".equalsIgnoreCase(fk.deleteRule())) {
                sb.append("\nON DELETE SET NULL");
            }
            sb.append(";\n\n");
        }

        for (List<Column> cols : tables.values()) {
            for (Column c : cols) {
                if (c.comment() != null && !c.comment().isBlank()) {
                    sb.append("COMMENT ON COLUMN \"").append(c.tableName()).append("\".\"").append(c.columnName())
                            .append("\" IS '").append(c.comment().replace("'", "''")).append("';\n");
                }
            }
        }
        return sb.toString();
    }

    private static String buildMermaid(
            Map<String, List<Column>> tables,
            Map<String, ConstraintDef> constraints,
            List<ForeignKey> foreignKeys,
            String user,
            String exportedAt) {
        return "# Current ERD\n\n"
                + "- User: `" + user + "`\n"
                + "- Exported at: `" + exportedAt + "`\n"
                + "- Tables: `" + tables.size() + "`\n"
                + "- Foreign keys: `" + foreignKeys.size() + "`\n\n"
                + "```mermaid\n"
                + mermaidBody(tables, constraints, foreignKeys)
                + "```\n";
    }

    private static String buildHtml(
            Map<String, List<Column>> tables,
            Map<String, ConstraintDef> constraints,
            List<ForeignKey> foreignKeys,
            String user,
            String exportedAt) {
        return """
                <!doctype html>
                <html lang="ko">
                <head>
                  <meta charset="utf-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1">
                  <title>Current ERD</title>
                  <style>
                    body { margin: 0; padding: 24px; font-family: Georgia, 'Times New Roman', serif; background: #f7f1e6; color: #1f2722; }
                    h1 { margin: 0 0 8px; font-size: 34px; }
                    .meta { margin-bottom: 20px; color: #5f665f; }
                    .wrap { overflow: auto; border: 1px solid #d7ccb9; background: #fffaf0; border-radius: 16px; padding: 18px; }
                  </style>
                </head>
                <body>
                  <h1>Current ERD</h1>
                """
                + "  <div class=\"meta\">User: " + esc(user) + " | Exported: " + esc(exportedAt)
                + " | Tables: " + tables.size() + " | FKs: " + foreignKeys.size() + "</div>\n"
                + "  <div class=\"wrap\"><pre class=\"mermaid\">\n"
                + esc(mermaidBody(tables, constraints, foreignKeys))
                + "  </pre></div>\n"
                + """
                  <script type="module">
                    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
                    mermaid.initialize({ startOnLoad: true, securityLevel: 'loose', er: { useMaxWidth: false } });
                  </script>
                </body>
                </html>
                """;
    }

    private static String mermaidBody(
            Map<String, List<Column>> tables,
            Map<String, ConstraintDef> constraints,
            List<ForeignKey> foreignKeys) {
        Map<String, List<String>> keyMarkers = new LinkedHashMap<>();
        for (ConstraintDef c : constraints.values()) {
            if ("P".equals(c.type())) {
                for (String col : c.columns()) {
                    keyMarkers.computeIfAbsent(c.tableName() + "." + col, k -> new ArrayList<>()).add("PK");
                }
            } else if ("R".equals(c.type())) {
                for (String col : c.columns()) {
                    keyMarkers.computeIfAbsent(c.tableName() + "." + col, k -> new ArrayList<>()).add("FK");
                }
            }
        }

        StringBuilder sb = new StringBuilder("erDiagram\n");
        for (ForeignKey fk : foreignKeys) {
            sb.append("    ").append(fk.refTableName()).append(" ||--o{ ").append(fk.tableName())
                    .append(" : \"").append(String.join(",", fk.columns())).append("\"\n");
        }
        for (Map.Entry<String, List<Column>> entry : tables.entrySet()) {
            sb.append("    ").append(entry.getKey()).append(" {\n");
            for (Column c : entry.getValue()) {
                String marker = String.join(",", keyMarkers.getOrDefault(c.tableName() + "." + c.columnName(), List.of()));
                sb.append("        ").append(mermaidType(c)).append(" ").append(c.columnName());
                if (!marker.isBlank()) {
                    sb.append(" ").append(marker);
                }
                sb.append('\n');
            }
            sb.append("    }\n");
        }
        return sb.toString();
    }

    private static String buildSummary(
            Map<String, List<Column>> tables,
            Map<String, ConstraintDef> constraints,
            List<ForeignKey> foreignKeys,
            String user,
            String exportedAt) {
        long pkCount = constraints.values().stream().filter(c -> "P".equals(c.type())).count();
        long ukCount = constraints.values().stream().filter(c -> "U".equals(c.type())).count();
        long columnCount = tables.values().stream().mapToLong(List::size).sum();

        StringBuilder sb = new StringBuilder();
        sb.append("Current Oracle schema export\n");
        sb.append("User: ").append(user).append('\n');
        sb.append("Exported at: ").append(exportedAt).append('\n');
        sb.append("Tables: ").append(tables.size()).append('\n');
        sb.append("Columns: ").append(columnCount).append('\n');
        sb.append("Primary keys: ").append(pkCount).append('\n');
        sb.append("Unique keys: ").append(ukCount).append('\n');
        sb.append("Foreign keys: ").append(foreignKeys.size()).append("\n\n");
        sb.append("Tables\n");
        for (Map.Entry<String, List<Column>> entry : tables.entrySet()) {
            sb.append("- ").append(entry.getKey()).append(" (").append(entry.getValue().size()).append(" columns)\n");
        }
        return sb.toString();
    }

    private static String typeSql(Column c) {
        String type = c.dataType();
        if ("VARCHAR2".equals(type) || "CHAR".equals(type) || "NVARCHAR2".equals(type) || "NCHAR".equals(type)
                || "RAW".equals(type)) {
            return type + "(" + c.dataLength() + ")";
        }
        if ("NUMBER".equals(type)) {
            if (c.dataPrecision() == null) {
                return "NUMBER";
            }
            if (c.dataScale() == null || c.dataScale() == 0) {
                return "NUMBER(" + c.dataPrecision() + ")";
            }
            return "NUMBER(" + c.dataPrecision() + "," + c.dataScale() + ")";
        }
        if (type != null && type.startsWith("TIMESTAMP") && c.dataScale() != null) {
            return "TIMESTAMP(" + c.dataScale() + ")";
        }
        return type;
    }

    private static String mermaidType(Column c) {
        return typeSql(c).replaceAll("[^A-Za-z0-9_]", "_");
    }

    private static String quotedList(List<String> values) {
        List<String> quoted = new ArrayList<>();
        for (String value : values) {
            quoted.add("\"" + value + "\"");
        }
        return String.join(", ", quoted);
    }

    private static String normalizeDefault(String value) {
        return value.replace("\r", " ").replace("\n", " ").trim();
    }

    private static Integer intOrNull(ResultSet rs, String column) throws SQLException {
        int value = rs.getInt(column);
        return rs.wasNull() ? null : value;
    }

    private static String esc(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
}
