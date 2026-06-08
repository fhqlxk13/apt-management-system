package kr.or.ddit;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SimpleTest {
    public static void main(String[] args) throws IOException {
        String path = "D:\\Final\\workspace\\STEVEN_ZIPS";
        File file = new File(path);

        List<String> list = new ArrayList<>();
        read(file, list);

        for(String s : list){
            System.out.println("리스트 : " + s);
        }
    }

    public static void read(File file, List<String> list) {
        if(file == null) return;

        if(file.isDirectory()){
            File[] listFiles = file.listFiles();
            if(listFiles != null){
                for(File f : listFiles){
                    read(f, list);
                }
            }
        }else{
            list.add(file.getAbsolutePath());
        }
    }
}
