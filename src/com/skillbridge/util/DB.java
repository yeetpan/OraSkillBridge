package com.skillbridge.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DB {
    private static final String url="jdbc:oracle:thin:@localhost:1521:xe";
    private static final String username="system";
    private static final String password="YourPassword123";
    static Connection connection=null;
public static Connection connect(){
    try{
         connection=DriverManager.getConnection(url,username,password);
        System.out.println("Connected to DB: " + connection.getMetaData().getURL());
    }catch (SQLException e){
        System.out.println(e.getMessage());
    }
    return connection;
}
}
