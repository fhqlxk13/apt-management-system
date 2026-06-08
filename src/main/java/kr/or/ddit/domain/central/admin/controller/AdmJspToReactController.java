package kr.or.ddit.domain.central.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/adm")
public class AdmJspToReactController {

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/home")
    public String home(HttpServletRequest request){
        String host = request.getServerName();

        return "redirect:http://"+host+":7777";
    }

}
